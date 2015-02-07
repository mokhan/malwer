require 'socket'

class FakeAgent
  include PacketFu
  attr_reader :id, :endpoint

  def initialize(id, endpoint)
    @id = id
    @endpoint = endpoint
  end

  def watch(directory)
    listener = Listen.to(directory, debug: true) do |modified, added, removed|
      publish_event(:modified, modified)
      publish_event(:added, added)
      publish_event(:removed, removed)
      (modified + added + removed).flatten.each do |file|
        scan_file(file)
      end
    end

    listener.start
    sleep
  end

  def scan(directory)
    Dir["**/**/*"].each do |file|
      scan_file(file)
    end
  end

  def scan_file(file)
    return unless File.file?(file)

    case disposition_for(file)
    when "malicious"
      publish_event(:quarantined, [file])
    when "unknown"
      puts "file is unknown"
    end
  end

  def sniff(interface)
    capture = Capture.new(iface: interface, start: true)
    capture.stream.each do |p|
      packet = Packet.parse(p)
      if packet.is_ip?
        yield packet if block_given?
      end
    end
  end

  def packet_capture(interface)
    sniff(interface) do |packet|
      if packet.ip_saddr == Utils.ifconfig(interface)[:ip_saddr]
      else
        packet_info = [packet.ip_saddr, packet.ip_daddr, packet.size, packet.proto.last]
        #puts packet.dissect
        puts "%-15s -> %-15s %-4d %s" % packet_info
      end
    end
  end

  private

  def publish_event(event, files)
    files.each do |file|
      body = {
        event: {
          agent_id: id,
          name: event,
          data: {
            fingerprint: fingerprint_for(file),
            path: file,
            hostname: Socket.gethostname,
            ip_addresses: ip_addresses,
          }
        }
      }
      Typhoeus.post(event_url, body: body)
    end
  rescue => e
    puts "#{e.message} #{e.backtrace.join(' ')}"
  end

  def fingerprint_for(file)
    return nil unless File.exist?(file)
    result = `shasum -a 256 #{file}`
    sha, * = result.split(' ')
    sha
  end

  def ip_addresses
    Socket.ip_address_list.find_all { |x| x.ipv4? }.map { |x| x.ip_address }
  end

  def disposition_for(file)
    fingerprint = fingerprint_for(file)
    body = {
      name: 'lookup',
      data: {
        fingerprint: fingerprint,
        path: File.expand_path(file)
      }
    }
    JSON.parse(Typhoeus.get(file_query_url(fingerprint), body: body).body)["state"]
  end

  def file_query_url(fingerprint)
    "#{endpoint}/agents/#{id}/files/#{fingerprint}"
  end

  def event_url
    "#{endpoint}/agents/#{id}/events/"
  end
end
