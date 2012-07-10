require 'rspec'

require_relative '../../lib/data_repository'

describe DataRepository do

  it 'should be creatable' do
    repo = DataRepository.new :context_url => 'http://bit.ly/x'
    repo.should_not eq nil
  end

  it 'should fail-fast with bad parameters' do
    expect { DataRepository.new }.to raise_error
    expect { DataRepository.new :context_url => nil }.to raise_error
  end

  context 'with a configuration factory' do

    it 'should return a valid configuration when needed' do
      url = 'https://s3.amazonaws.com/chrislambistan_configuration/current?AWSAccessKeyId=AKIAISEWSKLPOO37DVVQ&Expires=1339852918&Signature=CRKBIsQ4Gie7TacV9FVtx6xeQts%3D'
      repo = DataRepository.new :context_url => url
      repo.should_not eq nil
      repo.get_configuration.should_not eq nil
    end

  end
end