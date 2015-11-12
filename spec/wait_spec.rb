require 'spec_helper'

describe TestHelpers::Wait do

  before :all do
    TestHelpers.configuration.wait_timeout = 1
  end

  describe '.poll_and_assert' do

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
        expect(end_time - start_time).to be >= TestHelpers.configuration.wait_timeout
        expect(end_time - start_time).to be < TestHelpers.configuration.wait_timeout + 1
      end

      it 'should not raise an error until the specified timeout has elapsed' do
        start_time = Time.now
        begin
          dummy_class.poll_and_assert(3) { expect(true).to be false }
        rescue Exception
          end_time = Time.now
        end
        expect(end_time - start_time).to be >= 3
      end

      it 'yields to the block multiple times' do
        expect { |probe| dummy_class.poll_and_assert(1, &probe) }.to yield_control.at_least(:twice)
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
    end

    context 'for a failing test' do
      it 'should eventually raise an error' do
        statement = -> { dummy_class.wait_until { true == false } }
        expect { statement.call }.to raise_error(TimeoutError)
      end

      it 'should not raise an error until the default timeout has elapsed' do
        start_time = Time.now
        expect { dummy_class.wait_until { true == false } }.to raise_error(TimeoutError)
        end_time = Time.now
        expect(end_time - start_time).to be >= TestHelpers.configuration.wait_timeout
        expect(end_time - start_time).to be < TestHelpers.configuration.wait_timeout + 1
      end

      it 'should not raise an error until the specified timeout has elapsed' do
        start_time = Time.now
        expect { dummy_class.wait_until(3) { true == false } }.to raise_error(TimeoutError)
        end_time = Time.now
        expect(end_time - start_time).to be >= 3
      end

      it 'yields to the block multiple times' do
        expect { |probe| dummy_class.wait_until(1, &probe) }.to yield_control.at_least(:twice).and raise_error(TimeoutError)
      end
    end
  end


end