class Methods
  private

  attr_reader :parsed_url, :selected_list

  def fix_name(search_input)
    if search_input.include?('::')
      search_input = search_input.split('::')
      number_words = search_input.length
      transformed_input = ''
      number_words.times do |index|
        transformed_input += if index + 1 == number_words
                               search_input[index]
                             else
                               search_input[index] + '/'
                             end
      end
      return transformed_input
    end
    search_input
  end

  public

  attr_reader :instance_url, :name, :search, :related_results

  def initialize(type_name)
    @name = type_name
    @related_results = []
  end

  def class_module_list(method_type, parsed_page)
    list = parsed_page.css("p.#{method_type}")
    @selected_list = []
    list.each { |element| @selected_list << element.css('a').text }
    @selected_list
  end

  def select_methods(class_instance)
    method_heading = []
    selected_methods = []
    method_detail = @parsed_url.css("#public-#{class_instance}-method-details").css('div.method-detail')
    method_detail.each { |heading| method_heading << heading.css('div.method-heading').text }
    method_heading.length.times do |index|
      method_example = method_heading[index].split("\n          ")
      method_example = method_example.reject { |sp| sp.to_s.empty? || sp == '  ' || sp == '  click to toggle source' }
      selected_methods << method_example
    end
    selected_methods
  end

  def all_methods
    method_list = []
    method_list_url = @parsed_url.css('#method-list-section').css('ul').css('li')
    method_list_url.each { |li| method_list << li.text }
    method_list
  end

  def method_list_for(method_type)
    if method_type == 'instance'
      length = all_methods.length
      start = select_methods('class').length
      all_methods[start..length]
    else
      all_methods
    end
  end

  def search_by_name(search)
    selected_array = selected_list
    @search = search
    validate = 0
    selected_array.each do |class_module|
      s_length = search.length
      if class_module.downcase == search
        @current_search = class_module
        validate = 1
        break
      elsif class_module[0...s_length].downcase == search
        @related_results << class_module
        validate = 2
      end
    end
    validate
  end

  def create_sub_url(doc)
    @current_search = fix_name(@current_search)
    doc.sub_url(@current_search)
    @parsed_url = doc.sub_method_parsed
    @instance_url = doc.s_url
  end

  def no_methods?
    all_methods.empty? ? true : false
  end
end
