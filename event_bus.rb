require 'forwardable'

class EventBus
    class << self
        extend Forwardable

        def [](*events)
            Module.new.tap do |m|
                m.define_singleton_method(:included) do |base|
                    events.each { |e| EventBus.subscribe(e, base) }
                end
            end
        end

        def instance
            @instance ||= new
        end

        def_delegators :instance, :broadcast, :subscribe, :unsubscribe
    end

    def initialize
        @subscribers = handler_hash
    end

    def broadcast(*args)
        handler_caller(*args)
    end

    def subscribe(event, obj_hlr = nil, &hlr)
        handler = hlr || obj_hlr
        raise ArgumentError, 'object or proc handler required' if handler.nil?
        @subscribers[event][handler.object_id] = handler
        handler.object_id 
    end

    def unsubscribe(event, id)
        @subscribers[event].delete(id)
    end

    def events
        @subscribers
    end

    private

    def handler_hash
        Hash.new { |h, k| h[k] = {} }
    end

    def handler_caller(*args)
        @subscribers.each do |key, value|
            value.each do |id, method|
                if method.is_a?(Proc)
                    method.call(*args)
                else
                    method.send(key, *args)
                end
            end
        end
    end
end