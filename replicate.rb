class Rep
  require './error'
  attr_accessor :my_hash
  
  def initialize(hash={'location' => '/'})
    @my_hash = hash
  end

  def [](key)
    my_hash[key]
  end

  def []=(key, value)
    my_hash[key] = value
  end
  
  def set_code(code)
      @code = code
  end
  
  def code
      @code = "200" if @code == nil
      @code
  end
  
  def error!
    CustomError::MyError
  end
end

a = Rep.new
puts a['location']