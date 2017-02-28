module TestHelpers
  module Wait
    def self.configuration
      default_configuration
    end

    def self.default_configuration
      @configuration ||= Configuration.new
    end

    def self.configure
      yield(default_configuration) if block_given?
    end

    class << self
      extend ::Gem::Deprecate
      deprecate :configuration, :default_configuration, 2017, 04
    end

    class Configuration
      attr_accessor :wait_timeout, :wait_interval, :error_message

      def initialize
        @wait_timeout = 5.0
        @wait_interval = 0.1
        @error_message = 'Timed out waiting for block'
      end
    end

    def poll_and_assert(options = {})
      return unless block_given?
      timeout = Float(options[:timeout] || TestHelpers::Wait.default_configuration.wait_timeout)
      interval = Float(options[:interval] || TestHelpers::Wait.default_configuration.wait_interval)
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
      timeout = Float(options[:timeout] || TestHelpers::Wait.default_configuration.wait_timeout)
      interval = Float(options[:interval] || TestHelpers::Wait.default_configuration.wait_interval)
      error_message = options[:error_message] || TestHelpers::Wait.default_configuration.error_message
      end_time = ::Time.now + timeout
      until ::Time.now > end_time
        begin
          result = yield
          return result if result
          sleep interval
        rescue ::StandardError
          sleep interval
        end
      end
      result = yield
      return result if result
      raise Timeout::Error.new(error_message)
    end

  end
end
