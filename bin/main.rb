require 'open-uri'
require 'nokogiri'
require 'byebug'
require_relative '../lib/validator.rb'
require_relative '../lib/methods.rb'
require_relative '../lib/url.rb'

puts "Welcome to ruby docs scrapper"
puts 'Here you will find all classes and mudules in ruby-doc.org version 2.7.1'

@doc = Url.new

def menu
puts '----------Menu----------'
puts '1.Show all Ruby classes'
puts '2.Show all Ruby modules'
puts '3.Exit'
input = gets.chomp.to_i

case input
when 1
    input = "class"
    classes = Methods.new(input)
    method_list = classes.method_list("class", @doc.parsed_page)
    puts "#{input.capitalize} (#{method_list.length})"
    puts method_list
    search_by_name(classes, input)
when 2
    input = "module"
    modules = Methods.new(input)
    method_list = modules.method_list("module", @doc.parsed_page)
    puts "#{input.capitalize} (#{method_list.length})"
    puts method_list
    search_by_name(modules, input)
when 3
    exit
else
    puts "Sorry, it seem there is no match for #{input}"
end


end


def search_by_name(type, string)
    array = type.selected_list
    puts "Seach by name in #{string}"
    search = gets.chomp.downcase
    arr = []
    validate = 0
    array.each do |element|
        s_length = search.length
        if element.downcase == search
            @doc.sub_url= element
            type.parsed_url = @doc.sub_url
        elsif element[0...s_length].downcase == search
                arr << element
                validate = 1
        end
    end

    if validate  == 1
        puts "Related results for #{search}"
        puts arr
        search_by_name(type, string)
    elsif type.parsed_url.nil?
        puts "there is no match for #{search} in #{string} "
    elsif type.method_names.empty?
        puts "No methods for #{search.capitalize}"
    else

           puts "--------#{search.capitalize}--------- "
          puts "1. see class methods
              2. see instance methods"
           option = gets.chomp.to_i
          
            if option == 1
                puts "#{search.capitalize} Class methods"
                array = type.class_methods("class")
                list = type.method_names
                puts "method classes not found" if array.empty?
                array.each_with_index do |element, i|
    
                puts "-----------#{list[i]}----------------"
                puts element
    
                end
        
            elsif option == 2
            length = type.method_names.length
            start = type.class_methods('class').length
            puts "#{search.capitalize} Intance methods"
            array = type.class_methods("instance")
            list = type.method_names[start..length]
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


menu