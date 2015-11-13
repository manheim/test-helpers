module TestHelpers
  module Wait
    def poll_and_assert(options = {})
      return unless block_given?
      timeout = Float(options[:timeout] || TestHelpers.configuration.wait_timeout)
      interval = Float(options[:interval] || TestHelpers.configuration.wait_interval)
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
      timeout = Float(options[:timeout] || TestHelpers.configuration.wait_timeout)
      interval = Float(options[:interval] || TestHelpers.configuration.wait_interval)
      error = options[:error] || TestHelpers.configuration.default_error
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
