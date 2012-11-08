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