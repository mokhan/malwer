require 'socket'

class FakeAgent
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
    end

    listener.start
    sleep
  end

  def scan(directory)
    Dir["Rakefile"].each do |file|
      next unless File.file?(file)
      url = "#{endpoint}/agents/#{id}/files/#{fingerprint_for(file)}"
      body = {
        name: 'lookup',
        data: {
          path: File.expand_path(file)
        }
      }
      response = Typhoeus.get(url, body: body)
      body = JSON.parse(response.body)
      puts body.inspect
      case body["state"]
      when "malicious"
        publish_event(:quarantined, [file])
      when "unknown"
        puts "file is unknown"
      end
    end
  end

  private

  def publish_event(event, files)
    files.each do |file|
      fingerprint = fingerprint_for(file)
      url = "#{endpoint}/agents/#{id}/events/"
      body = {
        event: {
          agent_id: id,
          name: event,
          data: {
            fingerprint: fingerprint,
            path: file,
            hostname: Socket.gethostname,
            ip_addresses: ip_addresses,
          }
        }
      }
      puts [url, body].inspect
      Typhoeus.post(url, body: body)
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
end
