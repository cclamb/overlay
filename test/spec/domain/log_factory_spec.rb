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

describe LogFactory  do

    after(:all) do
      File.delete log_file_name if File.exists? log_file_name
    end
    
    it 'should be creatable' do
      repo = LogFactory.new 'some bucket name'
      repo.should_not eq nil
    end

    it 'should return a system logger' do
      repo = LogFactory.new 'some bucket name'
      logger = repo.create_system_log self
      logger.should_not eq nil
    end

    it 'should return an overlay logger' do
      repo = LogFactory.new 'some bucket name'
      logger = repo.create_overlay_log self
      logger.should_not eq nil
    end

end