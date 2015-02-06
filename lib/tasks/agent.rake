namespace :agent do
  require 'fake_agent'

  desc "watch all files"
  task watch: :environment do
    agent = FakeAgent.new(Agent.first.id, 'http://localhost:3000')
    agent.watch(Dir.pwd)
  end

  desc "scan directory"
  task scan: :environment do
    agent = FakeAgent.new(Agent.first.id, 'http://localhost:3000')
    agent.scan(Dir.pwd)
  end

  desc "scan network traffic"
  task nfm: :environment do
    agent = FakeAgent.new(Agent.first.id, 'http://localhost:3000')
    agent.sniff('en1')
  end
end
