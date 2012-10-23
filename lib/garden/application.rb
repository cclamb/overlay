#--
# Copyright (c) 2012 Christopher C. Lamb
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
# http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
#
# See the License for the specific language governing permissions and
# limitations under the License.
#++
# Predefining the Garden namespace to ensure
# it exists prior to application layer class
# inclusion.
module Garden 
  module Application
  end
end

# Application layer class definitions.
require_relative 'application/context_manager_service'
require_relative 'application/node_service'
require_relative 'application/peer_node_service'
require_relative 'application/router_service'