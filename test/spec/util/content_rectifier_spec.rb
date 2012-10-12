require 'rspec'
require_relative '../../../lib/garden'

include Garden

describe Util::ContentRectifier do

  new_detail = File.read "#{File.dirname __FILE__}/../../../etc/demo/new-location-detail.xml"
  old_detail = File.read "#{File.dirname __FILE__}/../../../etc/demo/old-location-detail.xml"

	context 'with a nil rectifier' do
    it 'should pass data through untouched' do
      Util::NilContentRectifier.new.process(:artifact => new_detail).should eq new_detail
    end
  end
  context 'with an artifact containing a policy' do

    context 'with a redaction strategy' do

      it 'should redact indicated content - sensitivity' do
        class Foo
          def context
            {
              :link => {
                :sensitivity => :secret,
                :category => :magenta,
                :organization => :eurasia,
                :mission_affiliation => :tropic_thunder
              },
              :user => {
                :clearance => :top_secret,
                :category => :magenta,
                :organziation => :oceania,
                :mission_affiliation => :tropic_thunder,
                :device => :tablet
              }
            }
          end
        end
        ctx_mgr = Foo.new
        cr = Util::ContentRectifier.new \
          :umm => Domain::UsageManagementMechanism.new,
          :context_manager => ctx_mgr,
          :confidentality_strategy => :redact
        xml = cr.process :artifact => new_detail
        puts xml
      end

      it 'should redact indicated content - category'
      it 'should redact indicated content - mission affiliation'
      it 'should redact indicated content - organization'
      it 'should redact indicated content - device'
      it 'should redact indicated content - os'
    end
    context 'with an encryption strategy' do
      # it 'should ecrypt indicated content - sensitivity'
      # it 'should ecrypt indicated content - category'
      # it 'should ecrypt indicated content - mission affiliation'
      # it 'should ecrypt indicated content - organization'
      # it 'should ecrypt indicated content - device'
      # it 'should ecrypt indicated content - os'
    end
    context 'with an out-of-band-strategy' do
      # it 'should reroute indicated content - sensitivity'
      # it 'should reroute indicated content - category'
      # it 'should reroute indicated content - mission affiliation'
      # it 'should reroute indicated content - organization'
      # it 'should reroute indicated content - device'
      # it 'should reroute indicated content - os'
    end
  end
  context 'with an artifact without a policy' do
    it 'should pass data through the artifact without alteration'
  end
end