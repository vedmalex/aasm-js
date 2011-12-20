{_callAction} = require './helpers'
module.exports = class StateTransition
	# конструктор для объекта перехода
	constructor: (opts) ->
		# from:откуда, 
		# to:куда, 
		# guard: условие, 
		# onTransition: что делать когда выполняется переход
		# onError: error han
		{from: @from, to: @to, guard: @guard, onTransition: @onTransition, onError: @onError} = opts
		@opts = opts
	#throws error
	handleError: (record, error)->
		throw error unless @onError? 
		_callAction(@onError, record)

	# проверка можно ли выполнить переход
	# принимает дополнительные параметры, которые передает в функцию
	perform: (obj, args...) ->
		try
			_callAction(@guard, obj, args...)
		catch error
			@handleError error
			false

	# выполнить переход
	execute: (obj, args...) ->
		try
			_callAction(@onTransition, obj, args...)
		catch error
			@handleError obj, error

	# два состояния равны друг другу если состояния их назначение и источники равны
	equals: (obj) -> @from is obj.from and @to is obj.to
	# проверка отсюда ли этот переход
	isFrom: (value) -> @from is value
	# проверка сюда ли переход
	isTo: (value) -> @to is value
