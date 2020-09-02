class Url
  attr_reader :url, :parsed_page, :sub_method_parsed, :s_url
  def initialize
    @url = 'https://ruby-doc.org/core-2.7.1/'
    @unparsed_page = URI.open(url)
    @parsed_page = Nokogiri::HTML(@unparsed_page)
  end

  def sub_url(name)
    @s_url = @url + name + '.html'
    unparsed_page = URI.open(@s_url)
    @sub_method_parsed = Nokogiri::HTML(unparsed_page)
    @s_url
  end
end
