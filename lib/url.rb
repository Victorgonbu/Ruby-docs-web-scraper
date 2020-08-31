class Url
    attr_reader :url,:parsed_page, :sub_url
    def initialize
      @url = "https://ruby-doc.org/core-2.7.1/"
      @unparsed_page = URI.open(url)
      @parsed_page = Nokogiri::HTML(@unparsed_page)
    end
    def sub_url=(string)
        begin
        url = @url + string + ".html"
        unparsed_page = URI.open(url)
        @sub_url = Nokogiri::HTML(unparsed_page)
        rescue
        puts "upps, url error"
        
        end
    end
end