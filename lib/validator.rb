
module Validator
  def valid_option?(input)
    input > 0 && input < 4 ? true : false 
  end
end