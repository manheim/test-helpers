module TestHelpers
  module Wait
    def poll_and_assert(timeout = TestHelpers.configuration.wait_timeout, interval = TestHelpers.configuration.wait_interval)
      return unless block_given?
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

    def wait_until(timeout = TestHelpers.configuration.wait_timeout, interval = TestHelpers.configuration.wait_interval)
      return unless block_given?
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
      raise TimeoutError.new('Timed out waiting for block')
    end
  end
end