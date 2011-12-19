{starts, ends, compact, count, merge, extend, flatten, del, last, capitalize, _callAction} = require './helpers'
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
      throw error unless @onError?
      _callAction(@onError, record, error)

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
    try
      _callAction(@options[action], record, args...)
    catch error
      @handleError(record, error)

  # пары значений для выбора из списка
  forSelect: () -> [@displayName, @name]
  # установить значения опций для состояния
  update: (options = {}) ->
    @displayName = if options.display 
      del(options, 'display') 
    else 
      capitalize(@name.replace(/_/g, ' '))

    @options = options
    this