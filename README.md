test-helpers
---------------

A collection of helper methods, matchers, and other various other freebies that we all use across multiple projects.  To see what is included in this package, navigate to the [Documentation](#docs) (coming soon).

#### Usage

Get the gem:
```ruby
gem 'test-helpers'
```

Require the gem:
```ruby
require 'test-helpers'
```

Configure the default timeout if you need to.  By default, the timeout is set to five(5) seconds.

```ruby
#features\support\env.rb or 
TestHelpers.configuration.wait_timeout = 30
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


#### Why?

I've seen a lot of duplicate code across various projects.  This is a way to consolidate our convenience objects and have a single point of failure.

Contribute
--------------
1. Fork the project
2. Write specs
3. Implement code
4. Create Pull Request