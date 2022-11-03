require File.expand_path('../../event_bus.rb', __FILE__)
describe EventBus do
    before(:each) { @bus = EventBus.new }

    it 'handles events with blocks' do
      ran = false
      
      @bus.subscribe(:test_event) { ran = true }
      
      expect(ran).to be(false)
      
      @bus.broadcast()
      
      expect(ran).to be(true)
    end
  
    it 'handles events with objects' do
      event_handler = Class.new do
        
        attr_reader :ran
        
        def initialize
          @ran = false
        end

        def test_event
          @ran = true
        end
      end
      
      handler = event_handler.new
      
      @bus.subscribe(:test_event, handler)
      
      expect(handler.ran).to be(false)
      
      @bus.broadcast()
      
      expect(handler.ran).to be(true)
    end
  
    it 'broadcast events without handlers' do
      expect { @bus.broadcast(:event_with_no_handler) }.to_not raise_error
    end
  
    it 'calls handlers every time' do
      counter = 0
      
      @bus.subscribe(:increment) { counter += 1 }
      
      50.times { @bus.broadcast() }
      
      expect(counter).to equal(50)
    end

    
    it 'removes handlers' do
      counter = 0
      
      id = @bus.subscribe(:increment) { counter += 1 }
      
      @bus.broadcast(:increment)
      
      @bus.unsubscribe(:increment, id)
      
      5.times { @bus.broadcast() }
      
      expect(counter).to equal(1)
    end
  
    it 'works as a singleton' do
      ran = false
      
      EventBus.subscribe(:test_event) { ran = true }
      
      expect(ran).to be(false)
      
      EventBus.broadcast()
      
      expect(ran).to be(true)
    end
  
    it 'can be included in classes' do
      handler_class = Class.new do
        include EventBus[:class_event]
        
        class << self
          
          def ran
            @ran || false
          end

          def class_event
            puts 'wat'
            @ran = true
          end

        end
      end
      
      expect(handler_class.ran).to be(false)
      
      EventBus.broadcast()
      
      expect(handler_class.ran).to be(true)
    end
  end