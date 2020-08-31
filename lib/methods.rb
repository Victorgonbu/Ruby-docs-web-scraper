require 'byebug'
require 'open-uri'
require 'httparty'
class Methods
    include Validator
    attr_reader :class_url, :parsed_url, :name, :selected_list
    attr_writer :parsed_url

    def initialize (element)
        @name = element
    end

    def method_list(s, parsed_page)
        list = parsed_page.css("p.#{s}")
        @selected_list = []
        list.each { |element| @selected_list << element.css('a').text }
        @selected_list
    end

    def class_methods(string)
        method_details = []
        method_heading = []
        champeta = []
        arr = []
        byebug
        class_method = @parsed_url.css("#public-#{string}-method-details").css('div.method-detail')
        class_method.each do |element|
            method_heading << element.css('div.method-heading').text

        end
        method_heading.each_with_index do |element1, i1|
            var = method_heading[i1].split("\n          ")
            var = var.reject {|e| e.to_s.empty? || e == "  " || e == "  click to toggle source"}
            champeta << var
        end
        champeta
    end
    
    def method_names
        method_list = []
        method_list_url = parsed_url.css('#method-list-section').css('ul').css('li')
        method_list_url.each {|element| method_list << element.text}
        method_list
    end



end