{_callAction} = require '../lib/helpers'
describe 'Helper', ->
	describe 'callAction', ->

		it 'All methods should be executed', ->
			class TestCallClass
				init: -> true
			someTestClass = new TestCallClass()
			spyOn(someTestClass,"init")
			_callAction("init",someTestClass)
			expect(someTestClass.init).toHaveBeenCalled()

		it 'All methods should be executed context of this class', ->
			class TestCallClass
				init: -> true
			someTestClass = new TestCallClass()
			spyOn(someTestClass,"init")
			someMethod = ()-> @init()
			_callAction(someMethod,someTestClass)
			expect(someTestClass.init).toHaveBeenCalled()

		it 'All methods should be executed if it if an Array of string', ->
			class TestCallClass
				init: -> true
				done: -> true
			someTestClass = new TestCallClass()
			spyOn(someTestClass,"init")
			spyOn(someTestClass,"done")
			_callAction(["init",'done'],someTestClass)
			expect(someTestClass.init).toHaveBeenCalled()
			expect(someTestClass.done).toHaveBeenCalled()

		it 'All methods should be executed if it if an Array of functions', ->
			class TestCallClass
				init: -> true
				done: -> true
			someTestClass = new TestCallClass()
			spyOn(someTestClass,"init")
			spyOn(someTestClass,"done")
			someMethod = ()-> @init()
			someOther = ()-> @done()
			_callAction([someMethod,someOther],someTestClass)
			expect(someTestClass.init).toHaveBeenCalled()			
			expect(someTestClass.done).toHaveBeenCalled()		
				
		it 'All methods should be executed if it if mixed array', ->
			class TestCallClass
				init: -> true
				done: -> true
			someTestClass = new TestCallClass()
			spyOn(someTestClass,"init")
			spyOn(someTestClass,"done")
			someMethod = ()-> @init()
			_callAction([someMethod,"done"],someTestClass)
			expect(someTestClass.init).toHaveBeenCalled()			
			expect(someTestClass.done).toHaveBeenCalled()						