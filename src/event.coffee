StateTransition = require './state_transition'
{merge, flatten, _callAction} = require './helpers'

module.exports = class Event
  ### конструктор события
  принимает в качестве параметра 
  name
  options
  > after
  > before
  > success
  > error
  callback
  ###
  constructor: (name, options = {}, callback) ->
    #ensure that all parameters will be assigned
    if typeof options is 'function'
      callback = options
      options = {}
    @name = name
    @_transitions = []
    @update(options, callback)
  ### запустить событие
  obj
  toState --> пеермотать до определенного состояния
  все параметры после toState пойдут на вызовы эвента
  один event может выпольнить хранить переходы в разные состояния: например мы может поставить 
  событие Закрыть документ, и оно может быть выполнено для объектов которые находятся в разных 
  состояниях и соответственно по ним нужно будет выполнить разные действия. вот для этого и нужен 
  парамерт toState, т.е. необходим для того чтобы мы моглы выбрать необходимый переход и запустить 
  его.
  если парамент toState не задан, то будет осуществлен переход по первому из списка
  returns функция возвращает новое состояние
  ###
  fire: (obj, toState, args...) ->
    aasmCurrentState = if typeof obj.aasmCurrentState is 'function'
      obj.aasmCurrentState()
    else
      obj.aasmCurrentState
    # найдем все переходы для текущего события из текущего состояния объекта
    transitions = @_transitions.filter (t)-> t.from is aasmCurrentState
    # если не нашли -- вызываем ошибку
    # тут надо написать код для обработки ошибки и вызова соответствующего метода
    # тут может быть надо вернуть пустое состояние?
    if transitions.length is 0
      throw {name: "InvalidTransition", message: "Event '#{@name}' cannot transition from '#{aasmCurrentState}'"}
    # новое состояние пустое
    nextState = null
    # по всем переходам
    for transition in transitions
      # приводим все переходу в состояние к массиву 
      flattered = flatten([transition.to])
      # если состояния к которому надо перейти нет в списке доступных для выбранного перехода берем следующую переменную
      continue if toState and flattered.indexOf(toState) < 0
      # если мы здесь значит переход будет в необходимое состояние
      if transition.perform(obj, args...)
        # если переход ведет в необходимое состояние или состояние не задано
        nextState = toState ? flattered[0]
        # выполняем переход
        transition.execute(obj, args...)
        break
    # возвращаем следующее состояние
    nextState

  # проверяет ведет ли этот евент в заданное состояние
  isTransitionsFromState: (state) ->
    # some -- функция array которая проверяет есть ли в массиве заданный элемент
    @_transitions.some (t) -> t.from is state

  # возвращает список переходов из заданного состояния
  transitionsFromState: (state) ->
    #filter - функция array которая выбирает все значения которые удовлетворяют заданному услувию
    @_transitions.filter (t) -> t.from is state

  # вызвать событие
  callAction: (action, record) ->
    action = @options[action]
    if Array.isArray action
      _callAction(anAction,record) for anAction in action
    else
      _callAction(action, record)

  equals: (event) ->
    @name is event.name

  # перенести свойства в атрибуты экземпляра
  update: (options = {}, block)->
    if options.success
      @success = options.success
    if options.error
      @error = options.error
    if block
      _callAction(block,this)
    @options = options
    this

  # выполнить код по успешному переходу
  executeSuccessCallback: (obj, success = null)->
    callback = success ? @success
    _callAction(callback, obj)

  # выполнить код по аварийному переходу
  executeErrorCallback: (obj, error, errorCallback=null)->
    callback = errorCallback || @error
    throw error unless callback
    throw {name: "NoMethodError", message: "No such method #{callback}"} unless obj[callback]
    _callAction(callback, obj, error)

  # одновременно и get-тер и set-тер для переходов
  transitions: (transOpts) ->
    # параметр пустой?
    if transOpts?
      # массив?
      if Array.isArray(transOpts.from)
        # Добавить конфигурацию из массива
        for from in transOpts.from
          @_transitions.push(new StateTransition(merge(transOpts, {from: from})))
      else
        # добавить один
        @_transitions.push(new StateTransition(transOpts))
    else
      # вернуть все текущие переходы 
      @_transitions


