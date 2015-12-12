test-helpers
---------------

A collection of helper methods, matchers, and other various other freebies that we all use across multiple projects.

#### Usage

Get the gem:

```ruby
gem install test-helpers
```

or add to your ```Gemfile```

```ruby
gem 'test-helpers'
```

Require parts of the gem that you want to use (or require everything):
```ruby
require 'test-helpers/wait'
```
or
```ruby
require 'test-helpers/all'
```

### TestHelpers::Wait
The wait module contains two methods:  ```poll_and_assert``` and ```wait_until```.  

##### poll_and_assert
is useful when you are asserting on something that has a timing componenet.  For example, you need to assert on an asynchronous response to an API request but the response isn't immediately available.  In these types of situation, use the ```poll_and_assert``` method and pass in your expectation.  The method will poll the assertion until it returns true or it times out.  If it times out, you will get the actual assertion message back instead of a generic timeout message.

```ruby
#will poll the assert until true or default timeout
poll_and_assert { expect(true).to be false } 
```

```ruby
#will poll the assert until true or specified
poll_and_assert(timeout: 30) { expect(true).to be false }  timeout
```

##### wait_until
is useful when you want to wait until something happens before continuing.  This method will trap all ```StandardError```s until the block returns true or it times out.  If it times out, you will get the default timeout error message or you can pass in a custom error message for better reporting.

```ruby
#will poll the assert until true or specified timeout every 0.5 seconds
poll_and_assert(interval: 0.5) { expect(true).to be false } 
```

```ruby
#raise a TimeoutError with the given error message.
wait_until(error_message:  'True never equaled false' ) { true == false } 
```

##### Configuration

There are multiple default configuration options that you can set.

```ruby
# features\support\env.rb
# or
# spec_helper.rb
TestHelpers::Wait.configuration do |config|
  config.wait_timeout = 30 #timeout after 30 seconds
  config.wait_interval = 0.5 #poll the given block every 0.5 seconds
  config.error_message = 'My default error message'
end
```

If you don't set your own defaults the following defaults will apply:
```ruby
TestHelpers::Wait.configuration do |config|
  config.wait_timeout = 5.0
  config.wait_interval = 0.1
  config.error_message = 'Timed out waiting for block'
end
```

(optional) Include it in Cucumber's ```World``` object:
```ruby
#features\support\env.rb
World(TestHelpers::Wait)
```

Contribute
--------------
1. Fork the project
2. Write specs
3. Implement code
4. Create Pull Request
