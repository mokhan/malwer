namespace :agent do
  require 'fake_agent'
  ENDPOINT='http://localhost:3000'

  desc "watch all files"
  task watch: :environment do
    agent = FakeAgent.new(Agent.first.id, ENDPOINT)
    agent.watch(Dir.pwd)
  end

  desc "scan directory"
  task scan: :environment do
    agent = FakeAgent.new(Agent.first.id, ENDPOINT)
    agent.scan(Dir.pwd)
  end

  desc "scan network traffic"
  task :nfm do
    id = Agent.first.id
    agent = FakeAgent.new(id, ENDPOINT)

    agent.packet_capture('eth0')
  end
end
