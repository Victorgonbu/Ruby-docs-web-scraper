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
    puts "
Search by name in #{input.capitalize}"
    search = gets.chomp.downcase
    classes.search_by_name(search, @doc)
when 2
    input = "module"
    modules = Methods.new(input)
    method_list = modules.method_list("module", @doc.parsed_page)
    puts "#{input.capitalize} (#{method_list.length})"
    puts method_list
    puts "
Search by name in #{input.capitalize}"
    search = gets.chomp.downcase
    modules.search_by_name(search, @doc)
when 3
    exit
else
    puts "Sorry, it seem there is no match for #{input}"
    menu
end


end


menu