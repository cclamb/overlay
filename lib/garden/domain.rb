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
# The namespace definition for the domain namespace.
# We ensure that Garden is defined prior to including
# any of the domain classes.
module Garden 
  module Application
  end
end

# Domain layer class definitions.
require_relative 'domain/component_factory'
require_relative 'domain/data_repository'
require_relative 'domain/node'
require_relative 'domain/peer_node'
require_relative 'domain/router'
require_relative 'domain/context_manager'
require_relative 'domain/usage_manager'
require_relative 'domain/configuration'
require_relative 'domain/usage_management_mechanism'
require_relative 'domain/dispatcher'
require_relative 'domain/artifact_repository'