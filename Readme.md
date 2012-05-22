# Press

A data and exception printer.

### Using

```ruby
require "press"

module Willy
  extend Press
  
  def self.main
    print(one: "two", three: "four", now: Time.now, pi: 3.14159265)
    print(spaces: "hello world", hash: {user: "password"}, array: ["cat", "dog"])
    printfm(__FILE__, __method__, hello: "world")

    print(event: "a block") { 2 + 2 }
    printfm(__FILE__, __method__, event: "another block") { 10 * 10 }

    printe(StandardError.new("something bad happened"), near: "weirdness")
    printfme(__FILE__, __method__, StandardError.new("worse"), joe: "blow")
  end
end
```