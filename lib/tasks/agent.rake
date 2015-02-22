namespace :agent do
  require 'fake_agent'

  desc "watch all files"
  task watch: :environment do
    agent = FakeAgent.new
    agent.register
    agent.watch(Dir.pwd)
  end

  desc "scan directory"
  task scan: :environment do
    agent = FakeAgent.new
    agent.register
    agent.scan(Dir.pwd)
  end

  desc "scan network traffic"
  task :nfm do
    agent = FakeAgent.new
    agent.register
    agent.packet_capture('eth0')
  end
end
