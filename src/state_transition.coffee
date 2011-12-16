module.exports = class StateTransition
  # конструктор для объекта перехода
  constructor: (opts) ->
    # from:откуда, 
    # to:куда, 
    #guard: условие, 
    #onTransition: что делать когда выполняется переход
    {from: @from, to: @to, guard: @guard, onTransition: @onTransition} = opts
    @opts = opts
  # проверка можно ли выполнить переход
  # принимает дополнительные параметры, которые передает в функцию
  perform: (obj, args...) ->
    switch typeof @guard 
      when 'string' # если guard строка, то нужно вызывать метод класса
        try
          obj[@guard].call(obj, args...)
        catch error
          console.trace()
      when 'function' # если guard функция, вызвать функцию
        try
          @guard.call(null, obj, args...)
        catch error
          console.trace()
      else
        true
  # выполнить переход
  execute: (obj, args...) ->
    # проверяем является ли параметр onTransition массивом или это функция
    if Array.isArray @onTransition
      # если параметр массив, то каждый элемент массива необходимо запустить 
      @_execute(obj, ot, args...) for ot in @onTransition
    else
      # иначе просто запускаем действие
      @_execute(obj, @onTransition, args...)
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
        try
          obj[onTransition].call(obj, obj, args...)
        catch error
          console.trace()
      # иначе попытаемся запустить метод, применив его к объекту 
      when 'function'
        try
          onTransition.call(obj, obj, args...)
        catch error
          console.trace()