require 'byebug'
require 'open-uri'
require 'httparty'
class Methods
    attr_reader :class_url, :parsed_url, :name, :selected_list, :search, :related_arr
    attr_writer :parsed_url

    def initialize (element)
        @name = element
        @related_arr = []
    end

    def create_sub_url(doc)
        doc.sub_url= @current_element
        self.parsed_url = doc.sub_url
        @class_url = doc.s_url
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
        method_list_url = @parsed_url.css('#method-list-section').css('ul').css('li')
        method_list_url.each {|element| method_list << element.text}
        method_list
    end

    def search_by_name(search, doc)
        array = self.selected_list
        @search = search
        validate = 0
        array.each do |element|
            s_length = search.length
            if element.downcase == search
                @current_element = element
                validate = 1
            elsif element[0...s_length].downcase == search
                @related_arr << element
                validate = 2
            end
        end
        validate
    end

    def no_methods?
      self.method_names.empty? ? true : false
    end


end