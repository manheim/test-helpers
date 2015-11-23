test-helpers
---------------

A collection of helper methods, matchers, and other various other freebies that we all use across multiple projects.  To see what is included in this package, navigate to the [Documentation](#docs) (coming soon).

#### Usage

Get the gem:

```ruby
gem install test-helpers
```

or add to your ```Gemfile```

```ruby
gem 'test-helpers'
```

Require parts of the gem the gem that you want to use (or require everything):
```ruby
require 'test-helpers/wait'
```
or
```ruby
require 'test-helpers/all'
```

### TestHelpers::Wait
##### Configuration

There are multiple default configuration options that you can set.

```ruby
# features\support\env.rb
# or
# spec_helper.rb
TestHelpers::Wait.configuration do |config|
  config.wait_timeout = 30 #timeout after 30 seconds
  config.wait_interval = 0.5 #poll the given block every 0.5 seconds
  config.default_error = ArgumentError.new('It brokez') #raise this error every time a block times out
end
```

(optional) Include it in Cucumber's ```World``` object:
```ruby
#features\support\env.rb
World(TestHelpers::Wait)
```

Use it!
```ruby
poll_and_assert { expect(true).to be false } #will poll the assert until true or default timeout
```

```ruby
poll_and_assert(30) { expect(true).to be false } #will poll the assert until true or specified timeout
```

```ruby
wait_until { true == false }
```

#### Why?

I've seen a lot of duplicate code across various projects that I've been on.  This is a way to consolidate and have a single point of failure.  Also sharing is caring.

Contribute
--------------
1. Fork the project
2. Write specs
3. Implement code
4. Create Pull Request