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
    Dir["**/**/*"].each do |file|
      next unless File.file?(file)
      url = "#{endpoint}/agents/#{id}/files/#{fingerprint_for(file)}"
      response = Typhoeus.get(url)
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
            full_path: file,
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
end
