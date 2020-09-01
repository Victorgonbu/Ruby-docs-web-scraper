require_relative '../lib/methods.rb'
require_relative '../lib/url.rb'
require 'rspec'
require 'open-uri'
require 'nokogiri'


describe Methods do
  let(:doc) { Url.new }
  let(:object) { Methods.new('class') }

  describe '.initialize' do
    context 'has either class or module string as input' do
      it 'name (class) as attribute' do
        expect(object).to have_attributes(name: 'class')
      end
      it 'invalid name as attribute' do
        expect(object).to_not have_attributes(name: 'string')
      end
    end
  end
  describe '#create_sub_url' do
    it 'creates a url based search last results' do
    end
  end

  describe '#method_list' do
    context 'class/module list' do
      it 'return an array with all ruby class' do
        instance = object.method_list('class', doc.parsed_page)
        expect(instance.length).to eql(108)
      end
      it 'return an array with all ruby molules' do
        instance = object.method_list('module', doc.parsed_page)
        expect(instance.length).to eql(23)
      end

      it 'return an empty array if string neither class nor module' do
        instance = object.method_list('victor', doc.parsed_page)
        expect(instance.length).to eql(0)
      end
    end
  end

  describe '#select_methods' do
    context 'return an array with either class or intance methods' do
      it 'return array with all class methods' do
        object.method_list('class', doc.parsed_page)
        object.search_by_name('array')
        object.create_sub_url(doc)
        instance = object.select_methods('class')
        expect(instance.length).to eql(3)
      end
      it 'return array with all instance methods' do
        object.method_list('module', doc.parsed_page)
        object.search_by_name('enumerable')
        object.create_sub_url(doc)
        instance = object.select_methods('instance')
        expect(instance.length).to eql(59)
      end
      it 'return empty array if there are no methods for class given' do
        object.method_list('module', doc.parsed_page)
        object.search_by_name('enumerable')
        object.create_sub_url(doc)
        instance = object.select_methods('class')
        expect(instance.length).to eql(0)
      end
    end
  end

  describe '#all_methods' do
    it 'return all methods from given class' do
      object.method_list('module', doc.parsed_page)
      object.search_by_name('enumerable')
      object.create_sub_url(doc)
      instance = object.all_methods
      expect(instance.length).to eql(59)
    end

    it 'return an empty array does not have any method' do
      object.method_list('class', doc.parsed_page)
      object.search_by_name('fatal')
      object.create_sub_url(doc)
      instance = object.all_methods
      expect(instance.length).to eql(0)
    end
  end

  describe '#search_by_name' do
    context 'return a number betwenn 0 and 3' do
      it 'retunr 0 if there is no match for serach' do
        object.method_list('class', doc.parsed_page)
        instance = object.search_by_name('fatalo')
        expect(instance).to eql(0)
      end
      it 'return 1 if the there is a exact match' do
        object.method_list('class', doc.parsed_page)
        instance = object.search_by_name('string')
        expect(instance).to eql(1)
      end
      it 'return 2 if search match with part of class name' do
        object.method_list('class', doc.parsed_page)
        instance = object.search_by_name('stri')
        expect(instance).to eql(2)
      end
    end
  end
  describe '#create_sub_url' do
    it 'set class parsed url' do
      object.method_list('class', doc.parsed_page)
      object.search_by_name('fatal')
      instance = object.create_sub_url(doc)
      expect(instance).to eql('https://ruby-doc.org/core-2.7.1/fatal.html')
    end
    it 'raise an error if search results do not match any element' do
      object.method_list('class', doc.parsed_page)
      object.search_by_name('fatalo')
      expect { object.create_sub_url(doc) }.to raise_error(NoMethodError)
    end
  end
  describe '#no_methods?' do
    context 'return true or false if element has or has no methods' do
      it 'true if array empty' do
        object.method_list('class', doc.parsed_page)
        object.search_by_name('fatal')
        object.create_sub_url(doc)
        object.all_methods
        instance = object.no_methods?
        expect(instance).to be(true)
      end
      it 'false if array is not empty' do
        object.method_list('class', doc.parsed_page)
        object.search_by_name('array')
        object.create_sub_url(doc)
        object.all_methods
        instance = object.no_methods?
        expect(instance).to be(false)
      end
    end
  end
end
