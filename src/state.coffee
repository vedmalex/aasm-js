{starts, ends, compact, count, merge, extend, flatten, del, last, capitalize} = require './helpers'
# тип состояние
module.exports = class State
  # конструктор параметры название и опции

  # список опций
  # display - display name
  # + State Actions 
  # beforeEnter
  # enter
  # afterEnter
  # beforeExit
  # exit
  # afterExit

  constructor: (name, options = {}) ->
    @name = name
    @update(options)
  # равенство определяется равенством имён
  equals: (state) ->
    @this.name is state

  # вызов действий последовательность такая
  # beforeEnter
  # enter
  # afterEnter
  # beforeExit
  # exit
  # afterExit

  callAction: (action, record) ->
    action = @options[action]
    if Array.isArray action
      try
        _callAction(anAction, record) for anAction in action
      catch HaltAasmChain
        #ignore
    else
      _callAction(action, record)
  # пары значений для выбора из списка
  forSelect: () -> [@displayName, @name]
  # установить значения опций для состояния
  update: (options = {}) ->
    if options.display
      @displayName = del options, 'display'
    else
      @displayName = capitalize(@name.replace(/_/g, ' '))
    @options = options
    this
  # вызов метода
  _callAction= (action, record)->
    switch typeof action
      when 'string'
        record[action].call(record)
      when 'function'
        action.call(action, record)
