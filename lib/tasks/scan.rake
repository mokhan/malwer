namespace :scan do
  desc "scan all files"
  task dir: :environment do
    require 'net/http'

    agent = Agent.first
    Dir['**/**/*'].each do |file|
      if File.file?(file)
        result = `shasum -a 256 #{file}`
        sha, * = result.split(' ')
        full_path = File.expand_path(file)

        url = "http://localhost:3000/agents/#{agent.id}/files/#{sha}"
        Typhoeus.get(url, body: { 
          payload: {
            full_path: full_path 
          }
        })
      end
    end
  end
end
