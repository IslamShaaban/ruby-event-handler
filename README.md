# EventBus
Event Bus is A Class to Handle Multiple Event with Number of Arguments

## Usage
Use the `EventBus` class as a singleton, or instantiate new instances of it.

```ruby

require_relative './event-bus'

# Handled with block of Code
EventBus.subscribe(:event_happened) do |params|
  puts "Event handled with block: #{params.inspect}"
end

class EventHandler
  def event_happened(params)
    puts "Event handled with method: #{params.inspect}"
  end
end

EventBus.broadcast(param1: 'hello', param2: 'world')

# Use As Instance
bus = EventBus.new

bus.subscribe(:event_happened, EventHandler.new)

bus.broadcast(request: 'handle THIS')
```
