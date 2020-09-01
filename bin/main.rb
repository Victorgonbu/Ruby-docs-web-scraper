require 'open-uri'
require 'nokogiri'

require_relative '../lib/methods.rb'
require_relative '../lib/url.rb'

puts 'Welcome to ruby docs scrapper'
puts 'Here you will find all classes and mudules in ruby-doc.org version 2.7.1'

@doc = Url.new

def menu
  puts '
----------Menu----------'
  puts '1.Show all Ruby classes'
  puts '2.Show all Ruby modules'
  puts '3.Exit'
  input = gets.chomp.to_i
  input_case(input)
end

def input_case(input)
  case input
  when 1
    input = 'class'
    selection(input)
  when 2
    input = 'module'
    selection(input)

  when 3
    exit
  else
    puts 'Sorry, it seem there is no match for that option'
    menu
  end
end

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
  result = object.search_by_name(search)
  validate_search(result, object)
end

def validate_search(result, object)
  if result == 2
    puts "Related results for #{object.search}"
    puts object.related_arr
    object.search_by_name(object.search)
    search(object)
  elsif result.zero?
    puts "there is no match for #{object.search} in #{object.name} "
    search(object)
  elsif result == 1
    object.create_sub_url(@doc)
    if object.no_methods?
      puts "There are no methods for #{object.search}"
      menu
    else
      content_table(object)
    end

  end
end

def display_methods(string, object)
  if string == 'instance'
    length = object.all_methods.length
    start = object.select_methods('class').length
    list = object.all_methods[start..length]
  else
    list = object.all_methods
  end

  puts "#{object.search.capitalize} #{string.capitalize} methods"
  array = object.select_methods(string)
  puts "URL : #{object.class_url}"
  puts 'Method classes not found' if array.empty?
  array.each_with_index do |element, i|
    puts "----------(#{list[i]})----------"
    puts element
  end
end

def content_table(object)
  puts "--------#{object.search.capitalize}--------- "
  puts '1.Show class methods '
  puts '2.Show instance methods'
  option = gets.chomp.to_i
  option_case(option, object)
end

def option_case(option, object)
  case option
  when 1
    display_methods('class', object)

  when 2
    display_methods('instance', object)
  else
    puts 'invalid input'
    content_table(object)
  end
  menu
end
menu
