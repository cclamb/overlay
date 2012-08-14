require 'rspec'

require_relative '../../../lib/garden/domain'

include Garden::Domain

describe ArtifactRepository do

  it 'should be creatable' do
    repo = ArtifactRepository.new({})
    repo.should_not eq nil
  end

  context 'with a valid store' do

    it 'should retrieve artifacts with a key' do
      repo = ArtifactRepository.new({ :key_1 => 'data' })
      repo.artifact(:key_1).should eq 'data'
    end

    it 'should retrieve all keys when artifacts is called' do
      repo = ArtifactRepository.new({ :key_1 => 'data1', :key_2 => 'data2' })
      keys = repo.artifacts
      keys[0].should eq :key_1
      keys[1].should eq :key_2
    end

  end
  
end