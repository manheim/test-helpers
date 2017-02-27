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
      attr_accessor :wait_timeout, :wait_interval, :error_message

      def initialize
        @wait_timeout = 5.0
        @wait_interval = 0.1
        @error_message = 'Timed out waiting for block'
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
      error_message = options[:error_message] || TestHelpers::Wait.configuration.error_message
      end_time = ::Time.now + timeout
      until ::Time.now > end_time
        begin
          result = yield
          if result.status
            return result
          else
            sleep interval
          end
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
