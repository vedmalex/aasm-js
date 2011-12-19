(function() {
  var Event, StateTransition, flatten, merge, _callAction, _ref;
  var __slice = Array.prototype.slice;

  StateTransition = require('./state_transition');

  _ref = require('./helpers'), merge = _ref.merge, flatten = _ref.flatten, _callAction = _ref._callAction;

  module.exports = Event = (function() {

    /* конструктор события
    принимает в качестве параметра 
    name
    options
    > after
    > before
    > success
    > error
    callback
    */

    function Event(name, options, callback) {
      if (options == null) options = {};
      if (typeof options === 'function') {
        callback = options;
        options = {};
      }
      this.name = name;
      this._transitions = [];
      this.update(options, callback);
    }

    /* запустить событие
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
    */

    Event.prototype.fire = function() {
      var aasmCurrentState, args, flattered, nextState, obj, toState, transition, transitions, _i, _len;
      obj = arguments[0], toState = arguments[1], args = 3 <= arguments.length ? __slice.call(arguments, 2) : [];
      aasmCurrentState = typeof obj.aasmCurrentState === 'function' ? obj.aasmCurrentState() : obj.aasmCurrentState;
      transitions = this._transitions.filter(function(t) {
        return t.from === aasmCurrentState;
      });
      if (transitions.length === 0) {
        throw {
          name: "InvalidTransition",
          message: "Event '" + this.name + "' cannot transition from '" + aasmCurrentState + "'"
        };
      }
      nextState = null;
      for (_i = 0, _len = transitions.length; _i < _len; _i++) {
        transition = transitions[_i];
        flattered = flatten([transition.to]);
        if (toState && flattered.indexOf(toState) < 0) continue;
        if (transition.perform.apply(transition, [obj].concat(__slice.call(args)))) {
          nextState = toState != null ? toState : flattered[0];
          transition.execute.apply(transition, [obj].concat(__slice.call(args)));
          break;
        }
      }
      return nextState;
    };

    Event.prototype.isTransitionsFromState = function(state) {
      return this._transitions.some(function(t) {
        return t.from === state;
      });
    };

    Event.prototype.transitionsFromState = function(state) {
      return this._transitions.filter(function(t) {
        return t.from === state;
      });
    };

    Event.prototype.callAction = function(action, record) {
      var anAction, _i, _len, _results;
      action = this.options[action];
      if (Array.isArray(action)) {
        _results = [];
        for (_i = 0, _len = action.length; _i < _len; _i++) {
          anAction = action[_i];
          _results.push(_callAction(anAction, record));
        }
        return _results;
      } else {
        return _callAction(action, record);
      }
    };

    Event.prototype.equals = function(event) {
      return this.name === event.name;
    };

    Event.prototype.update = function(options, block) {
      if (options == null) options = {};
      if (options.success) this.success = options.success;
      if (options.error) this.error = options.error;
      if (block) _callAction(block, this);
      this.options = options;
      return this;
    };

    Event.prototype.executeSuccessCallback = function(obj, success) {
      var callback;
      if (success == null) success = null;
      callback = success != null ? success : this.success;
      return _callAction(callback, obj);
    };

    Event.prototype.executeErrorCallback = function(obj, error, errorCallback) {
      var callback;
      if (errorCallback == null) errorCallback = null;
      callback = errorCallback || this.error;
      if (!callback) throw error;
      if (!obj[callback]) {
        throw {
          name: "NoMethodError",
          message: "No such method " + callback
        };
      }
      return _callAction(callback, obj, error);
    };

    Event.prototype.transitions = function(transOpts) {
      var from, _i, _len, _ref2, _results;
      if (transOpts != null) {
        if (Array.isArray(transOpts.from)) {
          _ref2 = transOpts.from;
          _results = [];
          for (_i = 0, _len = _ref2.length; _i < _len; _i++) {
            from = _ref2[_i];
            _results.push(this._transitions.push(new StateTransition(merge(transOpts, {
              from: from
            }))));
          }
          return _results;
        } else {
          return this._transitions.push(new StateTransition(transOpts));
        }
      } else {
        return this._transitions;
      }
    };

    return Event;

  })();

}).call(this);
