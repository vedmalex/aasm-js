StateTransition = require '../lib/state_transition'


describe 'StateTransition', ->
	it 'should set from, to, and opts attr readers', ->
		opts = {from: 'foo', to: 'bar', guard: 'g'}
		st = new StateTransition(opts)
		expect(st.from).toEqual(opts.from)
		expect(st.to).toEqual(opts.to)
		expect(st.opts).toEqual(opts)

	it 'should pass equality check if from and to are the same', ->
		opts = {from: 'foo', to: 'bar', guard: 'g'}
		st = new StateTransition(opts)
		obj = {from: opts.from, to: opts.to}
		expect(st.equals(obj)).toBeTruthy()


	it 'should fail equality check if from are not the same', ->
		opts = {from: 'foo', to: 'bar', guard: 'g'}
		st = new StateTransition(opts)
		obj = {from: 'blah', to: opts.to}
		expect(st.equals(obj)).toBeFalsy()
		expect(st).toNotEqual(obj)

	describe '- when performing guard checks', ->
		it 'should return true of there is no guard', ->
			opts = {from: 'foo', to: 'bar'}
			st = new StateTransition(opts)
			expect(st.perform(null)).toBeTruthy()

		it 'should call the method on the object if guard is a string', ->
			opts = {from: 'foo', to: 'bar', guard: 'test'}
			st = new StateTransition(opts)
			object = test: ->
			spyOn(object, 'test')
			st.perform(object)
			expect(object.test).toHaveBeenCalled()

		it 'should call the proc passing the object if the guard is a function', ->
			opts = {from: 'foo', to: 'bar', guard: () -> @test() }
			st = new StateTransition(opts)
			obj = test: ->
			spyOn(obj, 'test')
			st.perform(obj)
			expect(obj.test).toHaveBeenCalled() 

	describe 'Error handling', ->

		it 'should execute each method is listed in onTransition',->
			opts = {from: 'foo', to: 'bar', onTransition: ["test","a"] }
			st = new StateTransition(opts)
			obj =
				test: -> 
				a: -> 
			spyOn(obj, 'test')
			spyOn(obj, 'a')
			st.execute(obj)
			expect(obj.test).toHaveBeenCalled() 
			expect(obj.a).toHaveBeenCalled() 

		it 'should throw error if no handler is specified',->
			opts = {from: 'foo', to: 'bar', onTransition: ["test","a"] }
			st = new StateTransition(opts)
			obj =
				test: -> 
				a: ->
			spyOn(obj, 'test').andThrow("some")
			spyOn(obj, 'a')
			expect(-> st.execute(obj)).toThrow("some")
			expect(obj.test).toHaveBeenCalled() 
			expect(obj.a).not.toHaveBeenCalled() 

		it 'should call errorHandler if it is specified as string',->
			opts = {from: 'foo', to: 'bar', onTransition: ["test","a"], onError:'error' }
			st = new StateTransition(opts)
			obj =
				test: -> 
				a: ->
				error: ->
			spyOn(obj, 'test').andThrow("some")
			spyOn(obj, 'a')
			spyOn(obj, 'error')
			expect(-> st.execute(obj)).not.toThrow("some")
			expect(obj.test).toHaveBeenCalled() 
			expect(obj.a).not.toHaveBeenCalled()
			expect(obj.error).toHaveBeenCalled()  

		it 'should call errorHandler if it is specified as method',->

			opts = {from: 'foo', to: 'bar', onTransition: ["test","a"],onError:()-> @error() }
			st = new StateTransition(opts)
			obj =
				test: ->
				a: ->
				error: ->
			spyOn(obj, 'test').andThrow("some")
			spyOn(obj, 'a')
			spyOn(obj, 'error')
			expect(-> st.execute(obj)).not.toThrow("some")
			expect(obj.test).toHaveBeenCalled() 
			expect(obj.a).not.toHaveBeenCalled()
			expect(obj.error).toHaveBeenCalled() 