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
  # onError

  constructor: (name, options = {}) ->
    @name = name
    @onError = del options, 'onError'
    @update(options)
  
  handleError: (record, error)->
    if not (error is "halt_aasm_chain")
      if @onError?
        switch typeof @onError
          when 'string'
            record[@onError].call(record, error)
          when 'function'
            @onError.call(@onError, record, error)
      else 
        throw error

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

  callAction: (action, record, args...) ->
    action = @options[action]
    try
      if Array.isArray action
        @_callAction(anAction, record) for anAction in action
      else
        @_callAction(action, record)
    catch error
      @handleError(record, error)

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
  _callAction: (action, record, args...)->
    switch typeof action
      when 'string'
        record[action].call(record, args...)
      when 'function'
        action.call(action, record, args...)
