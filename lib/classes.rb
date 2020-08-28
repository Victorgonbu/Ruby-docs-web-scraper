require 'byebug'
class Classes 
    attr_reader :class_url

    def initialize (element)
        @class_url = "https://ruby-doc.org/core-2.7.0/#{element.capitalize}.html"

    end
end