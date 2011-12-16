{merge} = require './helpers'
State = require './state'
### статический класс для хранение всех доступных машин состояний.###
module.exports = class StateMachine extends Object
  ### машины состояний для классов ###
  @machines = {}
  ### зарегистрировать машину ###
  @register: (klass) ->
    sm = new StateMachine('')
    @machines[klass] = sm
    @[klass] = sm
  
  ### конструктор машини состояний ###
  constructor: (name) ->
    @name = name
    @initialState = null
    @states = []
    @events = {}
    @config = {}
  
  ### клонировать ###
  clone: () ->
    klone = merge(this, {})
    klone.states = merge @states, {}
    klone.events = merge @events, {}
    klone
  ### список доступных состояний ###
  statesName: ()-> @states.map (state)-> state.name
  ### создать состояние ###
  createState: (name, options) ->
    #DONE check for dup state name
    if not @states.some((s)-> s.name is name)
      @states.push(new State(name, options))
    else
      existingState = @states.filter (s)-> s.name is name
      existingState[0].update(options)