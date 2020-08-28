require 'httparty'
require 'nokogiri'
require 'byebug'

puts "Welcome to ruby docs scrapper"
puts 'Here you will find all classes and mudules in ruby-doc.org version 2.7.1'
puts '------Menu------'
puts "1. see all ruby classes"
puts '2. see all ruby modules'
input = gets.chomp.to_i

puts "what are you doing" unless input == 1 || input == 2


def display(s, parsed_page)
    array = parsed_page.css("p.#{s}")
    selected_array = []
    array.each do |element|
            value = element.css('a').text
            selected_array << value
    end
    puts s.capitalize + "(#{selected_array.length})"
    selected_array.each {|element| puts element}
end

def scrapper(input)
    url = "https://ruby-doc.org/core-2.7.1/"
    unparsed_page = HTTParty.get(url)
    parsed_page = Nokogiri::HTML(unparsed_page)
    
    if input == 1
        display("class", parsed_page)
    elsif input == 2
        display("module", parsed_page)
    end
end

scrapper(input)