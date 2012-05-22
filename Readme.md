# Press

A data and exception printer.

### Using

```ruby
require "press"

module Willy
  extend Press
  
  def self.main
    pd(one: "two", three: "four", now: Time.now, pi: 3.14159265)
    pd(spaces: "hello world", hash: {user: "password"}, array: ["cat", "dog"])
    pdfm __FILE__, __method__, hello: "world")

    pd(event: "a block") { 2 + 2 }
    pdfm __FILE__, __method__, event: "another block") { 10 * 10 }

    pde(StandardError.new("something bad happened"), near: "weirdness")
    pdfme(__FILE__, __method__, StandardError.new("worse"), joe: "blow")
  end
end
```

```bash
one=two three=four now=2012-05-21T16:59:21-07:00 pi=3.142
spaces="hello world" hash={.. array=[..
file=silly fn=main hello=world
event="a block" at=start
event="a block" at=finish elapsed=0.000
file=silly fn=main event="another block" at=start
file=silly fn=main event="another block" at=finish elapsed=0.000
at=error class=StandardError message="something bad happened" near=weirdness
file=silly fn=main at=error class=StandardError message=worse joe=blow
```