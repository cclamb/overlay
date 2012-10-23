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
# This is a facade of various classes that need to be 
# included  to run the simulation.  This references
# the three application areas, the application layer,
# the domain layer, and the utility layer.  These layers
# have their own similar files.
require_relative 'garden/application'
require_relative 'garden/domain'
require_relative 'garden/util'