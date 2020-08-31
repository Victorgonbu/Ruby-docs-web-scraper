require 'open-uri'
require 'nokogiri'
require 'byebug'
require_relative '../lib/validator.rb'
require_relative '../lib/methods.rb'
require_relative '../lib/url.rb'

puts "Welcome to ruby docs scrapper"
puts 'Here you will find all classes and mudules in ruby-doc.org version 2.7.1'

@doc = Url.new

def selection(input)
    object = Methods.new(input)
    method_list = object.method_list(input, @doc.parsed_page)
    puts "#{input.capitalize} (#{method_list.length})"
    puts method_list
    search(object)
end

def search(object)
    puts "
Search by name in #{object.name}"
            search = gets.chomp.downcase
            result = object.search_by_name(search, @doc)
            validate_search(result, object)
end


def menu
puts '----------Menu----------'
puts '1.Show all Ruby classes'
puts '2.Show all Ruby modules'
puts '3.Exit'
input = gets.chomp.to_i

case input
when 1
    input = "class"
    selection(input)
when 2
    input = "module"
    selection(input)
    
when 3
    exit
else
    puts "Sorry, it seem there is no match for #{input}"
    menu
end


end

def validate_search(result, object)

    if result == 2
        puts "Related results for #{object.search}"
        puts object.related_arr
        object.search_by_name(object.search, @doc)
        search(object)
    elsif result == 0
        puts "there is no match for #{object.search} in #{object.name} "
        search(object)
    elsif result == 1
        object.create_sub_url(@doc)
        content_table(object)
    
    end
   
end


def content_table(object)
    puts "--------#{object.search.capitalize}--------- "
    puts "1. see class methods "
    puts "2. see instance methods"
    option = gets.chomp.to_i
      
    if option == 1
        puts "#{object.search.capitalize} Class methods"
        array = object.class_methods("class")
        list = object.method_names
        puts "URL : #{object.class_url}"
        puts "Method classes not found" if array.empty?
        array.each_with_index do |element, i|

            puts "----------(#{list[i]})----------"
            puts element

            end
    
    elsif option == 2
        length = object.method_names.length
        start = object.class_methods('class').length
        puts "#{object.search.capitalize} Intance methods"
        array = object.class_methods("instance")
        list = object.method_names[start..length]
        puts "method classe not found" if array.nil?
        array.each_with_index do |element, i|

            puts "----------(#{list[i]})----------"
            puts element
            puts ""
        end
        

    else
          puts "invalid input"
          content_table(object)
    end
end

menu