require 'socket'

class FakeAgent
  include PacketFu
  DEFAULT_ENDPOINT='http://localhost:3000'
  attr_reader :id, :endpoint

  def initialize(endpoint = DEFAULT_ENDPOINT)
    @endpoint = endpoint
  end

  def register
    response = Typhoeus.post(registration_url, body: { agent: { hostname: hostname } })
    json = JSON.parse(response.body)
    @id = json["id"]
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
  rescue StandardError => error
    log_error(error)
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
          type: event,
          data: {
            fingerprint: fingerprint_for(file),
            path: file,
            hostname: hostname,
            ip_addresses: ip_addresses,
          }
        }
      }
      Typhoeus.post(event_url, body: body)
    end
  rescue StandardError => error
    log_error(error)
  end

  def fingerprint_for(file)
    return nil unless File.exist?(file)
    result = `shasum -a 256 #{file}`
    sha, * = result.split(' ')
    sha
  end

  def hostname
    @hostname ||= Socket.gethostname
  end

  def ip_addresses
    @ipaddresses ||= Socket.ip_address_list.find_all { |x| x.ipv4? }.map { |x| x.ip_address }
  end

  def disposition_for(file)
    fingerprint = fingerprint_for(file)
    body = {
      data: {
        fingerprint: fingerprint,
        path: File.expand_path(file)
      }
    }
    JSON.parse(Typhoeus.get(file_query_url(fingerprint), body: body).body)["state"]
  end

  def file_query_url(fingerprint)
    "#{endpoint}/api/agents/#{id}/files/#{fingerprint}"
  end

  def event_url
    "#{endpoint}/api/agents/#{id}/events/"
  end

  def registration_url
    "#{endpoint}/api/agents"
  end

  def log_error(error)
    puts "#{error.message} #{error.backtrace.join(' ')}"
  end
end
