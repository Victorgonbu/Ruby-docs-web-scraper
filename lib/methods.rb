class Methods
  private
  attr_reader :parsed_url, :selected_list
  
  public
  attr_reader :instance_url, :name, :search, :related_arr

  def initialize(element)
    @name = element
    @related_arr = []
  end

  def method_list(string, parsed_page)
    list = parsed_page.css("p.#{string}")
    @selected_list = []
    list.each { |element| @selected_list << element.css('a').text }
    @selected_list
  end

  def select_methods(string)
    method_heading = []
    selected = []
    method_detail = @parsed_url.css("#public-#{string}-method-details").css('div.method-detail')
    method_detail.each { |element| method_heading << element.css('div.method-heading').text }
    method_heading.each_with_index do |_element1, i1|
      var = method_heading[i1].split("\n          ")
      var = var.reject { |e| e.to_s.empty? || e == '  ' || e == '  click to toggle source' }
      selected << var
    end
    selected
  end

  def all_methods
    method_list = []
    method_list_url = @parsed_url.css('#method-list-section').css('ul').css('li')
    method_list_url.each { |element| method_list << element.text }
    method_list
  end

  def search_by_name(search)
    array = selected_list
    @search = search
    validate = 0
    array.each do |element|
      s_length = search.length
      if element.downcase == search
        @current_element = element
        validate = 1
        break
      elsif element[0...s_length].downcase == search
        @related_arr << element
        validate = 2
      end
    end
    validate
  end
  
  def fix_name(search_input)
    if search_input.include?('::')
      search_input = search_input.split('::')
      number_words = search_input.length
      transformed_input = ''
      number_words.times do |index|
        if index + 1 == number_words
          transformed_input += search_input[index]
        else
          transformed_input += search_input[index] + '/'
        end
      end
      return transformed_input
    end
    search_input
  end

  def create_sub_url(doc)
    @current_element = fix_name(@current_element)
    doc.sub_url(@current_element)
    @parsed_url = doc.sub_method_parsed
    @instance_url = doc.s_url
  end

  def no_methods?
    all_methods.empty? ? true : false
  end
end
