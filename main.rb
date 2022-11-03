require_relative './event_bus'

EventBus.subscribe(:event_happened) do |params|
    puts "Event handled with block: #{params.inspect}"
end

class EventHandler
  def event_happened(params)
    puts "Event handled with method: #{params.inspect}"
  end
end

EventBus.broadcast(param1: 'hello', param2: 'world', param3: 'islam')

cls = Class.new do
  def second_event(params)
    puts "Second Event handled with method: #{params.inspect}"
  end
end

obj = cls.new
bus = EventBus.new 
bus.subscribe(:second_event, obj)
bus.broadcast(request: 'Handle This')