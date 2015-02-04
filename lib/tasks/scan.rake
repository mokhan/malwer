namespace :scan do
  desc "scan all files"
  task dir: :environment do
    require 'net/http'

    agent = Agent.first
    Dir['**/**/*'].each do |file|
      if File.file?(file)
        result = `shasum -a 256 #{file}`
        sha = result.split(' ').first

        uri = URI("http://localhost:3000/agents/#{agent.id}/files/#{sha}")
        puts [sha, Net::HTTP.get(uri)].inspect
      end
    end
  end
end
