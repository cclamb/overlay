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
class Garden::Domain::PeerNode

  def initialize artifact_repo = [], &search_adapter
    @artifact_repo = artifact_repo
    @search_adapter = search_adapter
  end

  def find_artifact id, search_ctx = {}, remote_ctx = {}
    return [] if id == nil || search_ctx == nil || remote_ctx == nil
    hop_count = search_ctx[:hop_count]
    local_results = @artifact_repo.select { |record| record[:id] == id }
    remote_results = if search_remotely? hop_count
      @search_adapter.call id, search_ctx, remote_ctx
    end


    local_results
  end

  def find_available_artifacts id, search_ctx, remote_ctx

  end

  private

  def search_remotely? hop_count
    hop_count != nil && hop_count > 0
  end
  
end