class Url
    attr_reader :url,:parsed_page, :sub_url, :s_url
    def initialize
      @url = "https://ruby-doc.org/core-2.7.1/"
      @unparsed_page = URI.open(url)
      @parsed_page = Nokogiri::HTML(@unparsed_page)
      
    end
    def sub_url=(string)
        @s_url = @url + string + ".html"
        unparsed_page = URI.open(@s_url)
        @sub_url = Nokogiri::HTML(unparsed_page) 
       
    end
end