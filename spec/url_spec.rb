require_relative '../lib/methods.rb'
require_relative '../lib/url.rb'
require 'rspec'
require 'Nokogiri'


describe Url do
    let(:doc) { Url.new }
    let(:ruby_url) { 'https://ruby-doc.org/core-2.7.1/' }
    describe "#initialize" do
      it 'initialize Ruby url' do
        expect(doc.url).to eql(ruby_url)
      end
    end

    describe "#sub-url" do

        it 'initialize class/module url if class/module only if it exist' do
            instance = doc.sub_url("Array")
            expect(instance).to eql('https://ruby-doc.org/core-2.7.1/Array.html')
        end
    end
      
end