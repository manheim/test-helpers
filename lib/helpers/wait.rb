module TestHelpers
  module Wait
    def poll_and_assert(options = {})
      return unless block_given?
      timeout = Integer(options[:timeout]) || TestHelpers.configuration.wait_timeout
      interval = Integer(options[:interval]) || TestHelpers.configuration.wait_interval
      end_time = ::Time.now + timeout
      until ::Time.now > end_time
        begin
          result = yield
          return result if result
        rescue ::RSpec::Expectations::ExpectationNotMetError
          sleep interval
        end
      end
      yield
    end

    def wait_until(options = {})
      return unless block_given?
      timeout = Integer(options[:timeout]) || TestHelpers.configuration.wait_timeout
      interval = Integer(options[:interval]) || TestHelpers.configuration.wait_interval
      error = options[:error] || TimeoutError.new('Timed out waiting for block')
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
