#--
# Copyright (c) 2012 Christopher C. Lamb
#
# SBIR DATA RIGHTS
# Contract No. FA8750-11-C-0195
# Contractor: AHS Engineering Services (under subcontract to Modus Operandi, Inc.)
# Address: 5909 Canyon Creek Drive NE, Albuquerque, NM 87111
# Expiration Date: 05/03/2018
# 
# The Government’s rights to use, modify, reproduce, release, perform, display, 
# or disclose technical data or computer software marked with this legend are 
# restricted during the period shown as provided in paragraph (b) (4) 
# of the Rights in Noncommercial Technical Data and Computer Software-Small 
# Business Innovative Research (SBIR) Program clause contained in the above 
# identified contract. No restrictions apply after the expiration date shown 
# above. Any reproduction of technical data, computer software, or portions 
# thereof marked with this legend must also reproduce the markings.
#++
require 'rspec'

require_relative '../../../lib/garden/domain'

log_file_name = 'system.log'

include Garden::Domain

def build_raw_repo_uri
  s3 = AWS::S3.new
  url = s3.buckets[:chrislambistan_repos] \
    .objects['repo_1.dat'] \
    .url_for :read
  URI::parse url.to_s
end

describe ComponentFactory do

  before(:all) do
    creds_file_name = 'etc/creds.yaml'

    creds = YAML::load File::open(creds_file_name)

    access_key = creds['amazon']['access_key']
    secret_key = creds['amazon']['secret_key']

    AWS.config \
      :access_key_id => access_key, \
      :secret_access_key => secret_key
  end

  after(:all) do
    File.delete log_file_name if File.exists? log_file_name
  end

  it 'should be creatable' do
    factory = ComponentFactory::instance :bucket_name => 'test'
    factory.should_not eq nil
    factory = ComponentFactory::instance.should_not eq nil
  end

  it 'should create a rectifier' do
    ComponentFactory::instance(:bucket_name => 'foo').create_rectifier.should_not eq nil
    ComponentFactory::instance(:bucket_name => 'foo').create_rectifier(:managed => true).should_not eq nil
  end

  context 'with a LogFactory' do

    it 'should create a system log' do
      factory = ComponentFactory::instance :bucket_name => 'test'
      factory.create_system_log(self).should_not eq nil
    end

    it 'should create an overlay log' do
      factory = ComponentFactory::instance :bucket_name => 'test'
      factory.create_overlay_log(self).should_not eq nil
    end

  end

  context 'with a node record factory' do

    it 'should create a node record' do
      f = ComponentFactory::instance :bucket_name => 'test'
      yaml_values = { 'hostname' => 1, \
        'test_0' => 0, \
        'test_1' => 1, \
        'test_2' => 2 }
      node = f.create_node_record yaml_values
      node[:id].should eq 1
      node[:test_0].should eq 0
      node[:test_1].should eq 1
      node[:test_2].should eq 2
    end

  end

  context 'with an artifact repository' do

    it 'should create a respository with a valid URL to an S3 repo' do
      repo = ComponentFactory::instance.create_artifact_repo build_raw_repo_uri
      repo.should_not eq nil
      artifacts = repo.artifacts
      artifacts.should_not eq nil
      artifacts.size.should > 0
      artifact = repo.artifact :key_1
      artifact.should eq 'this is data from the repo'
    end

  end

  context 'with a router creation request' do
    it 'should create a router' do
      ComponentFactory.instance.create_router({}).should_not eq nil
    end
  end

  context 'with a node creation request' do
    it 'should create a node' do
      ComponentFactory.instance.create_node(:repo_uri => build_raw_repo_uri).should_not eq nil
    end

    it 'should create a node with a nil repo' do
      ComponentFactory.instance.create_node(:parent => 'parent').should_not eq nil
    end
  end

  context 'with a context manager request' do
    it 'should create a context manager'
  end

end