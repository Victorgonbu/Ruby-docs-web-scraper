require 'byebug'
require 'open-uri'
require 'httparty'
class Classes 
    attr_reader :class_url, :parsed_url, :name

    def initialize (element)
        @name = element
        @class_url = "https://ruby-doc.org/core-2.7.0/#{@name.capitalize}.html"
        begin
        @unparsed_url = HTTParty.get(class_url) 
        rescue 
            puts  "que falla mi pes ->"
        end
        @parsed_url =  Nokogiri::HTML(@unparsed_url)
    end

    def class_methods
        method_details = []
        method_heading = []
        champeta = []
        arr = []
        class_method = @parsed_url.css('#public-class-method-details').css('div.method-detail')
        class_method.each do |element|
            method_heading << element.css('div.method-heading').text

        end
        method_heading.each_with_index do |element1, i1|
            var = method_heading[i1].split("\n          ")
            var = var.reject {|e| e.to_s.empty? || e == "  " || e == "  click to toggle source"}
            puts "this is #{var} "
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

    def instace_methods
        
    end
    
    def method_details
    end
    


end