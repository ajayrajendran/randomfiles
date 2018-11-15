module CustomError
  class MyError < StandardError
    attr_reader :custom
    def initialize(msg="My default message", custom="apple")
      @custom = custom
      super(msg)
    end
  end
end