$LOAD_PATH << File.dirname(__FILE__)
module TestHelpers
  class << self
    attr_accessor :configuration
  end

  def self.configuration
    @configuration ||= Configuration.new
  end

  def self.configure
    yield(configuration) if block_given?
  end

  class Configuration
    attr_accessor :wait_timeout, :wait_interval, :default_error

    def initialize
      @wait_timeout = 5.0
      @wait_interval = 0.1
      @default_error = TimeoutError.new('Timed out waiting for block')
    end
  end

end