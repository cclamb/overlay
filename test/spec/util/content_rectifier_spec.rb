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

      it 'should redact indicated content (secret)' do
        context = {
          :sensitivity => :secret,
          :category => :magenta,
          :organization => :eurasia,
          :mission_affiliation => :tropic_thunder
        }

        cr = Util::ContentRectifier.new \
          :umm => Domain::UsageManagementMechanism.new,
          :confidentality_strategy => :redact
        xml = cr.process :artifact => new_detail, :context => context

        doc = Nokogiri::XML xml
        sections = doc.xpath '//artifact/data-object/content/section'
        sections.each do |section|
          policy_name = section.attr 'policy'
          fail unless policy_name == 'description'
        end
      end

      it 'should redact indicated content (magenta)' do
        context = {
          :sensitivity => :top_secret,
          :category => :magenta,
          :organization => :eurasia,
          :mission_affiliation => :tropic_thunder
        }

        cr = Util::ContentRectifier.new \
          :umm => Domain::UsageManagementMechanism.new,
          :confidentality_strategy => :redact
        xml = cr.process :artifact => new_detail, :context => context
        
        doc = Nokogiri::XML xml
        sections = doc.xpath '//artifact/data-object/content/section'
        sections.each do |section|
          policy_name = section.attr 'policy'
          fail unless policy_name == 'description' || policy_name == 'history'
        end
      end

    end
    context 'with an encryption strategy' do
      it 'should ecrypt indicated content (secret)'
      it 'should ecrypt indicated content (magenta)'
    end
    context 'with an out-of-band-strategy' do
      it 'should reroute indicated content (secret)'
      it 'should reroute indicated content (magenta)'
    end
  end
  context 'with an artifact without a policy' do
    it 'should pass data through the artifact without alteration'
  end
end