require 'rspec'
require_relative '../../../lib/garden/util/content_rectifier'

include Garden::Util

describe ContentRectifier do
	context 'with a nil rectifier' do
    it 'should pass data through untouched'
  end
  context 'with an artifact containing a policy' do
    context 'with a redaction strategy' do
      it 'should redact indicated content - sensitivity'
      it 'should redact indicated content - category'
      it 'should redact indicated content - mission affiliation'
      it 'should redact indicated content - organization'
      it 'should redact indicated content - device'
      it 'should redact indicated content - os'
    end
    context 'with an encryption strategy' do
      it 'should ecrypt indicated content - sensitivity'
      it 'should ecrypt indicated content - category'
      it 'should ecrypt indicated content - mission affiliation'
      it 'should ecrypt indicated content - organization'
      it 'should ecrypt indicated content - device'
      it 'should ecrypt indicated content - os'
    end
    context 'with an out-of-band-strategy' do
      it 'should reroute indicated content - sensitivity'
      it 'should reroute indicated content - category'
      it 'should reroute indicated content - mission affiliation'
      it 'should reroute indicated content - organization'
      it 'should reroute indicated content - device'
      it 'should reroute indicated content - os'
    end
  end
  context 'with an artifact without a policy' do
    it 'should pass data through the artifact without alteration'
  end
end