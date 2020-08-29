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
                @var = Modules.new(element)
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
    else 
        array = @var.class_methods
        byebug
        array.each_with_index do |element, i|

            puts "-----------#{(i+1)}METHOD----------------"
            puts element

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