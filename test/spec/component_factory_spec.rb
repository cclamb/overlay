require 'rspec'

require_relative '../../lib/domain/component_factory'

log_file_name = 'system.log'

describe ComponentFactory do

  after(:all) do
    File.delete log_file_name if File.exists? log_file_name
  end

  it 'should be creatable' do
    factory = ComponentFactory.new :bucket_name => 'test'
    factory.should_not eq nil
  end

  it 'should fail fast with incorrect parameters' do
    expect { ComponentFactory.new }.to raise_error
    expect { ComponentFactory.new :bucket_name => nil }.to raise_error
  end

  context 'with a LogFactory' do

    it 'should create a system log' do
      factory = ComponentFactory.new :bucket_name => 'test'
      factory.create_system_log(self).should_not eq nil
    end

    it 'should create an overlay log' do
      factory = ComponentFactory.new :bucket_name => 'test'
      factory.create_overlay_log(self).should_not eq nil
    end

  end

  context 'with a node factory' do

    it 'should create a node' do
      f = ComponentFactory.new :bucket_name => 'test'
      yaml_values = { 'hostname' => 1, \
        'test_0' => 0, \
        'test_1' => 1, \
        'test_2' => 2 }
      node = f.create_node yaml_values
      node[:id].should eq 1
      node[:test_0].should eq 0
      node[:test_1].should eq 1
      node[:test_2].should eq 2
    end

  end

end