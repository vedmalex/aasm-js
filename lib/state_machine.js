(function() {
  var State, StateMachine, merge;
  var __hasProp = Object.prototype.hasOwnProperty, __extends = function(child, parent) { for (var key in parent) { if (__hasProp.call(parent, key)) child[key] = parent[key]; } function ctor() { this.constructor = child; } ctor.prototype = parent.prototype; child.prototype = new ctor; child.__super__ = parent.prototype; return child; };

  merge = require('./helpers').merge;

  State = require('./state');

  /* статический класс для хранение всех доступных машин состояний.
  */

  module.exports = StateMachine = (function() {

    __extends(StateMachine, Object);

    /* машины состояний для классов
    */

    StateMachine.machines = {};

    /* зарегистрировать машину
    */

    StateMachine.register = function(klass) {
      var sm;
      sm = new StateMachine('');
      this.machines[klass] = sm;
      return this[klass] = sm;
    };

    /* конструктор машини состояний
    */

    function StateMachine(name) {
      this.name = name;
      this.initialState = null;
      this.states = [];
      this.events = {};
      this.config = {};
    }

    /* клонировать
    */

    StateMachine.prototype.clone = function() {
      var klone;
      klone = merge(this, {});
      klone.states = merge(this.states, {});
      klone.events = merge(this.events, {});
      return klone;
    };

    /* список доступных состояний
    */

    StateMachine.prototype.statesName = function() {
      return this.states.map(function(state) {
        return state.name;
      });
    };

    /* создать состояние
    */

    StateMachine.prototype.createState = function(name, options) {
      var existingState;
      if (!this.states.some(function(s) {
        return s.name === name;
      })) {
        return this.states.push(new State(name, options));
      } else {
        existingState = this.states.filter(function(s) {
          return s.name === name;
        });
        return existingState[0].update(options);
      }
    };

    return StateMachine;

  })();

}).call(this);
