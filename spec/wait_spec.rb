require 'spec_helper'
require 'test-helpers/wait'

describe TestHelpers::Wait do

  describe TestHelpers::Wait do

    let(:default_configuration) { TestHelpers::Wait.default_configuration }

    describe '.default_configuration' do
      it 'should be a Test::Helpers::Configuration object' do
        expect(default_configuration).to be_a_kind_of TestHelpers::Wait::Configuration
      end
    end

    describe '.wait_timeout' do
      it 'should return the default wait timeout' do
        expect(default_configuration.wait_timeout).to eql 5.0
      end

      it 'should update default wait timeout with the given value' do
        default_configuration.wait_timeout = 30
        expect(default_configuration.wait_timeout).to eql 30
      end
    end

    describe '.wait_interval' do
      it 'should return the default wait interval' do
        expect(default_configuration.wait_interval).to eql 0.1
      end

      it 'should update default wait interval with the given value' do
        default_configuration.wait_interval = 2
        expect(default_configuration.wait_interval).to eql 2
      end
    end

    describe '.error_message' do
      it 'should return the default error message' do
        expect(default_configuration.error_message).to eql 'Timed out waiting for block'
      end

      it 'should update the default error message to the given string' do
        default_configuration.error_message = 'A new error message'
        expect(default_configuration.error_message).to eql 'A new error message'
      end
    end

    describe '.configuration' do
      it 'should redirect to .default_configuration' do
        allow(TestHelpers::Wait).to receive(:default_configuration)
        TestHelpers::Wait.configuration
        expect(TestHelpers::Wait).to have_received(:default_configuration)
      end
    end

  end

  describe '.poll_and_assert' do

    before :all do
      TestHelpers::Wait.configure do |config|
        config.wait_timeout = 1
        config.wait_interval = 0.5
      end
    end

    let(:dummy_class) { Class.new { extend TestHelpers::Wait } }

    context 'for a passing test' do
      it 'should pass' do
        statement = -> { dummy_class.poll_and_assert { expect(true).to be true } }
        expect { statement.call }.not_to raise_error
      end

      it 'should pass fast' do
        start_time = Time.now
        dummy_class.poll_and_assert { expect(true).to be true }
        end_time = Time.now
        expect(end_time - start_time).to be < 1
      end

      it 'yields to the block once' do
        allow(dummy_class).to receive(:poll_and_assert) { |&block| block.call(expect(true).to be(true)) }
        expect { |probe| dummy_class.poll_and_assert(&probe) }.to yield_control.exactly(:once)
      end

      it 'should not sleep' do
        expect(dummy_class).to_not receive(:sleep)
        dummy_class.poll_and_assert { expect(true).to be true }
      end
    end

    context 'for a failing test' do
      it 'should eventually raise an error' do
        statement = -> { dummy_class.poll_and_assert { expect(true).to be false } }
        expect { statement.call }.to raise_error(RSpec::Expectations::ExpectationNotMetError)
      end

      it 'should not raise an error until the default timeout has elapsed' do
        start_time = Time.now
        begin
          dummy_class.poll_and_assert { expect(true).to be false }
        rescue Exception
          end_time = Time.now
        end
        expect(end_time - start_time).to be >= TestHelpers::Wait.default_configuration.wait_timeout
        expect(end_time - start_time).to be < TestHelpers::Wait.default_configuration.wait_timeout + 1
      end

      it 'should not raise an error until the specified timeout has elapsed' do
        start_time = Time.now
        begin
          dummy_class.poll_and_assert(timeout: 3) { expect(true).to be false }
        rescue Exception
          end_time = Time.now
        end
        expect(end_time - start_time).to be >= 3
      end

      it 'should sleep for interval duration' do
        expect(dummy_class).to receive(:sleep).at_least(1).times.with(TestHelpers::Wait.default_configuration.wait_interval)
        allow(dummy_class).to receive(:raise).and_return(false)
        dummy_class.poll_and_assert { expect(true).to be false }
      end

    end
  end


  describe '.wait_until' do
    let(:dummy_class) { Class.new { extend TestHelpers::Wait } }

    context 'for a passing test' do
      it 'should pass' do
        statement = -> { dummy_class.wait_until { true == true } }
        expect { statement.call }.not_to raise_error
      end

      it 'should pass fast' do
        start_time = Time.now
        expect { dummy_class.wait_until { true == true } }.not_to raise_error
        end_time = Time.now
        expect(end_time - start_time).to be < 1
      end

      it 'yields to the block once' do
        allow(dummy_class).to receive(:wait_until) { |&block| block.call(true == true) }
        expect { |probe| dummy_class.wait_until(&probe) }.to yield_control.exactly(:once)
      end

      it 'should not sleep' do
        expect(dummy_class).to_not receive(:sleep)
        dummy_class.wait_until { expect(true).to be true }
      end
    end

    context 'for a failing test' do
      it 'should eventually raise an error' do
        statement = -> { dummy_class.wait_until { true == false } }
        expect { statement.call }.to raise_error(Timeout::Error)
      end

      it 'should not raise an error until the default timeout has elapsed' do
        start_time = Time.now
        expect { dummy_class.wait_until { true == false } }.to raise_error(Timeout::Error)
        end_time = Time.now
        expect(end_time - start_time).to be >= TestHelpers::Wait.default_configuration.wait_timeout
        expect(end_time - start_time).to be < TestHelpers::Wait.default_configuration.wait_timeout + 1
      end

      it 'should not raise an error until the specified timeout has elapsed' do
        start_time = Time.now
        expect { dummy_class.wait_until(timeout: 3) { true == false } }.to raise_error(Timeout::Error)
        end_time = Time.now
        expect(end_time - start_time).to be >= 3
      end

      it 'yields to the block multiple times' do
        expect { |probe| dummy_class.wait_until(timeout: 1, &probe) }.to yield_control.at_least(:twice).and raise_error(Timeout::Error)
      end

      it 'should sleep for interval duration' do
        expect(dummy_class).to receive(:sleep).at_least(1).times.with(TestHelpers::Wait.default_configuration.wait_interval)
        allow(dummy_class).to receive(:raise).and_return(false)
        dummy_class.poll_and_assert { expect(true).to be false }
      end

      context 'when a custom error message is passed in' do
        it 'should eventually raise the given error' do
          error_message = 'blah'
          statement = -> { dummy_class.wait_until(error_message: error_message) { true == false } }
          expect { statement.call }.to raise_error(Timeout::Error, error_message)
        end
      end
    end
  end


end