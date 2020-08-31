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
    display("class", @doc.parsed_page)
when 2
    display("module", @doc.parsed_page)
when 3
    exit
else
    puts "Sorry, it seem there is no match for #{input}"
end


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
                @var = Methods.new(element)
            else 
                @var = Methods.new(element)
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


menu