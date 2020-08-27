require 'httparty'
require 'nokogiri'
require 'byebug'

require 'byebug'
require 'httparty'
require 'nokogiri'

puts "Welcome to ruby docs scrapper"
puts 'Here you will find all classes and mudules in ruby-doc.org version 2.7.1'


def scrapper
    url = "https://ruby-doc.org/core-2.7.1/"
    unparsed_page = HTTParty.get(url)
    parsed_page = Nokogiri::HTML(unparsed_page)
    classes = parsed_page.css('p.class')
    new_array = []
    classes.each_with_index {|element|
    new_array << element.css('a').text
}

byebug

  
end

scrapper