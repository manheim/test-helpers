project_root = File.expand_path(File.dirname(__FILE__))
Dir.glob(project_root + '/helpers/*.rb').each { |file| require file }

module TestHelpers
  class << self
    attr_accessor :configuration
  end

  def self.configuration
    @configuration ||= Configuration.new
  end

  def self.configure
    yield(configuration) # if  block_given?
  end

  class Configuration
    attr_accessor :wait_timeout, :wait_interval

    def initialize
      @wait_timeout = 5.0
      @wait_interval = 0.1
    end
  end

end