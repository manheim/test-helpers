module TestHelpers
  module Wait
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

    def poll_and_assert(options = {})
      return unless block_given?
      timeout = Float(options[:timeout] || TestHelpers::Wait.configuration.wait_timeout)
      interval = Float(options[:interval] || TestHelpers::Wait.configuration.wait_interval)
      end_time = ::Time.now + timeout
      failure = nil
      until ::Time.now > end_time
        begin
          result = yield
          return result if result
        rescue ::RSpec::Expectations::ExpectationNotMetError => e
          failure = e
          sleep interval
        end
      end
      raise failure
    end

    def wait_until(options = {})
      return unless block_given?
      timeout = Float(options[:timeout] || TestHelpers::Wait.configuration.wait_timeout)
      interval = Float(options[:interval] || TestHelpers::Wait.configuration.wait_interval)
      error = options[:error] || TestHelpers::Wait.configuration.default_error
      end_time = ::Time.now + timeout
      until ::Time.now > end_time
        begin
          result = yield
          return result if result
        rescue ::StandardError
          sleep interval
        end
      end
      result = yield
      return result if result
      raise error
    end

  end
end
