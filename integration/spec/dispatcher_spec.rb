require 'rspec'
require 'stringio'

require_relative '../../lib/garden/domain'
require_relative '../../lib/garden/util/test_interface'

include Garden::Domain

pid = nil

class TestService < TestInterface
	get '/search/artifacts/*' do
    'retrieved artifacts'
	end
	get '/search/artifact/*' do
    'retrieved an artifact'
	end
end

describe Dispatcher do

  before(:all) do
    Domain::ComponentFactory::instance :bucket_name => 'foo'
    pid = fork do
      $stdout = StringIO.new
      $stderr = StringIO.new
      TestService::run!
    end
    sleep 1
  end

  after(:all) do
  	File.delete('system.log') if File.exists?('system.log')
  	Process::kill :KILL, pid
  end

  it 'should be creatable' do
    d = Dispatcher.new [], 4567
  end

  it 'should dispatch to indicated hosts via HTTP on artifacts requests' do
    d = Dispatcher.new ['http://localhost'], 4567
    responses = d.dispatch_artifacts 'cclamb', 'iphone'
    fail if responses.empty? == true or responses == nil
    responses.each { |r| r.should eq 'retrieved artifacts' }
  end

  it 'should dispatch to indicated hosts via HTTP on single artifact requests' do
    d = Dispatcher.new ['http://localhost'], 4567
    responses = d.dispatch_artifact 'cclamb', 'iphone', 'some_id'
    fail if responses.empty? == true or responses == nil
    responses.each { |r| r.should eq 'retrieved an artifact' }
  end

end