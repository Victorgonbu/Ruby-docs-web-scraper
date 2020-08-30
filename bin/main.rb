require 'open-uri'
require 'nokogiri'
require 'byebug'
require_relative '../lib/classes.rb'
require_relative '../lib/modules.rb'

puts "Welcome to ruby docs scrapper"
puts 'Here you will find all classes and mudules in ruby-doc.org version 2.7.1'

def menu
puts '------Menu------'
puts '1. see all ruby classes'
puts '2. see all ruby modules'
input = gets.chomp.to_i

puts "what are you doing" unless input == 1 || input == 2

scrapper(input)
end


def display(s, parsed_page)
    array = parsed_page.css("p.#{s}")
    selected_array = []
    array.each do |element|
            value = element.css('a').text
            selected_array << value
    end
    puts s.capitalize + "(#{selected_array.length})"
    selected_array.each {|element| puts element}

    search_by_name(selected_array, s)

end

def search_by_name(array, string)
    puts "Seach by name in #{string}"
    search = gets.chomp.downcase
    arr = []
    validate = false
    array.each do |element|
        s_length = search.length
        if element.downcase == search
            if string == 'class'
                @var = Classes.new(element)
            else 
                @var = Classes.new(element)
            end
            break
        elsif element[0...s_length].downcase == search
                arr << element
                validate = true
        end
    end

    if validate
        puts "Related results for #{search}"
        puts arr
        search_by_name(array, string)
    elsif @var.nil?
        puts "there is no match for #{search} in #{string} "
    elsif @var.method_names.empty?
        puts "No methods for #{search.capitalize}"
    else

           puts "--------#{search.capitalize}--------- "
          puts "1. see class methods
              2. see instance methods"
           option = gets.chomp.to_i
          
            if option == 1
                puts "#{search.capitalize} Class methods"
                array = @var.class_methods("class")
                list = @var.method_names
                puts "method classes not found" if array.empty?
                array.each_with_index do |element, i|
    
                puts "-----------#{list[i]}----------------"
                puts element
    
                end
                byebug
            elsif option == 2
            length = @var.method_names.length
            start = @var.class_methods('class').length
            puts "#{search.capitalize} Intance methods"
            array = @var.class_methods("instance")
            list = @var.method_names[start..length]
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

def scrapper(input)
    url = "https://ruby-doc.org/core-2.7.1/"
    unparsed_page = URI.open(url)
    parsed_page = Nokogiri::HTML(unparsed_page)     
    
    if input == 1
        display("class", parsed_page)
    elsif input == 2
        display("module", parsed_page)
    end
end

menu