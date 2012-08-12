require 'rspec'

require_relative '../../lib/garden/domain'
require_relative '../../lib/garden/util/test_interface'

include Garden::Domain

pid = nil



class TestService < TestInterface

	
	
	get '/artifacts/*' do

	end
	get '/artifact/*' do

	end
end

describe Dispatcher do

  before(:all) do
    Domain::ComponentFactory::instance :bucket_name => 'foo'
    pid = fork { TestInterface::run! }
    puts "PID: #{pid}"
    sleep 1
  end

  after(:all) do
  	File.delete('syslog.log') if File.exists?('syslog.log')
  	puts "Killing process with PID: #{pid}"
  	Process::kill :KILL, pid
  end

  it 'should be creatable' do
    d = Dispatcher.new [], 4567
  end

  it 'should dispatch to indicated hosts via HTTP' do

  end

end