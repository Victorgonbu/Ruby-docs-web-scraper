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

    def search_by_name(search, doc)
        array = self.selected_list
        arr = []
        validate = false
        array.each do |element|
            s_length = search.length
            if element.downcase == search
                doc.sub_url= element
                self.parsed_url = doc.sub_url
            elsif element[0...s_length].downcase == search
                    arr << element
                    validate = true
            end
        end
    end
    
        if validate 
            puts "Related results for #{search}"
            puts arr
            search_by_name(search)
        elsif self.parsed_url.nil?
            puts "there is no match for #{search} in #{name} "
        elsif self.method_names.empty?
            puts "No methods for #{search.capitalize}"
        else
    
            puts "--------#{search.capitalize}--------- "
            puts "1. see class methods "
            puts "2. see instance methods"
            option = gets.chomp.to_i
              
                if option == 1
                    puts "#{search.capitalize} Class methods"
                    array = self.class_methods("class")
                    list = self.method_names
                    puts "method classes not found" if array.empty?
                    array.each_with_index do |element, i|
        
                    puts "-----------#{list[i]}----------------"
                    puts element
        
                    end
            
                elsif option == 2
                length = self.method_names.length
                start = self.class_methods('class').length
                puts "#{search.capitalize} Intance methods"
                array = self.class_methods("instance")
                list = self.method_names[start..length]
                puts "method classe not found" if array.nil?
                array.each_with_index do |element, i|
        
                    puts "-----------(#{list[i]})----------------"
                    puts element
                    puts ""
                end
                
    
                else
                  puts "invalid input"
                end
         
        end
        
    
    



end