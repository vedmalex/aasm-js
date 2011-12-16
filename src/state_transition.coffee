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
    if @onError?
      switch typeof @onError
        when 'string'
          record[@onError].call(error)
        when 'function'
          @onError.call(@onError, record, error)
    else 
      throw error

  # проверка можно ли выполнить переход
  # принимает дополнительные параметры, которые передает в функцию
  perform: (obj, args...) ->
    try
      switch typeof @guard 
        when 'string' # если guard строка, то нужно вызывать метод класса
            obj[@guard].call(obj, args...)
        when 'function' # если guard функция, вызвать функцию
            @guard.call(null, obj, args...)
        else
          true
    catch error
      @handleError error
      false

  # выполнить переход
  execute: (obj, args...) ->
    try
      # проверяем является ли параметр onTransition массивом или это функция
      if Array.isArray @onTransition
        # если параметр массив, то каждый элемент массива необходимо запустить 
        @_execute(obj, ot, args...) for ot in @onTransition
      else
        # иначе просто запускаем действие
        @_execute(obj, @onTransition, args...)
    catch error
      @handleError obj, error

  # два состояния равны друг другу если состояния их назначение и источники равны
  equals: (obj) ->
    @from is obj.from and @to is obj.to
  # проверка отсюда ли этот переход
  isFrom: (value) -> @from is value
  # проверка сюда ли переход
  isTo: (value) -> @to is value
  # выполнить переход
  _execute: (obj, onTransition, args...) ->
      switch typeof onTransition
        # если переход задан строкой, то выполним соответствующий метода
        when 'string'
            obj[onTransition].call(obj, obj, args...)
        # иначе попытаемся запустить метод, применив его к объекту 
        when 'function'
            onTransition.call(obj, obj, args...)
