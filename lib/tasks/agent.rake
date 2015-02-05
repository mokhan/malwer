namespace :agent do
  desc "watch all files"
  task watch: :environment do
    require 'fake_agent'
    agent = FakeAgent.new(Agent.first.id, 'http://localhost:3000')
    agent.run(Dir.pwd)
  end
end
