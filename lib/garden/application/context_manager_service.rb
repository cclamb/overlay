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
require 'socket'
require 'net/http'
require 'uri'
require 'json'

require_relative '../domain/component_factory'
require_relative '../util/test_interface'

class Garden::Application::ContextManagerService < TestInterface
  enable :inline_templates

  def self::load_initial_context filename
    instance_eval File.read(filename) || {}
  end

  def self::initialize params = {}
    @@repo = load_initial_context params[:initial_context_file]
    ctx = params[:ctx]
    set ctx if ctx != nil
    @@syslog = Domain::ComponentFactory::instance \
      .create_system_log self.to_s
  end

  def generate_return id
    status = @@repo[id] || halt(404)
    { :edge => id, :status => status }
  end

  get '/status/all' do
    @@repo
  end

  get '/status/:id' do
    id = params[:id]
    content_type 'application/json', :charset => 'utf-8'
    JSON.generate generate_return(id)
  end

  post '/status/:id' do
    new_level = params[:value]
    id = params[:id]
params.each { |k,v| puts "#{k} : #{v}"}
puts "#{id} : #{params[:value]}"
    return if new_level == nil

    new_level = new_level.kind_of?(String) ? instance_eval(new_level) : new_level

    new_level.each do |k,v|
      bag = @@repo[id] || {}

      if v.kind_of? Array
        new_v = []
        v.each { |v| new_v.push v.to_sym }
        bag[k.to_sym] = new_v
      else
        bag[k.to_sym] = v.to_sym
      end
      @@repo[id] = bag
    end

    @@repo[id]
  end

end