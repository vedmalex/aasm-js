(function() {
  var State, capitalize, compact, count, del, ends, extend, flatten, last, merge, starts, _callAction, _ref;
  var __slice = Array.prototype.slice;

  _ref = require('./helpers'), starts = _ref.starts, ends = _ref.ends, compact = _ref.compact, count = _ref.count, merge = _ref.merge, extend = _ref.extend, flatten = _ref.flatten, del = _ref.del, last = _ref.last, capitalize = _ref.capitalize, _callAction = _ref._callAction;

  module.exports = State = (function() {

    function State(name, options) {
      if (options == null) options = {};
      this.name = name;
      this.onError = del(options, 'onError');
      this.update(options);
    }

    State.prototype.handleError = function(record, error) {
      if (!(error === "halt_aasm_chain")) {
        if (this.onError == null) throw error;
        return _callAction(this.onError, record, error);
      }
    };

    State.prototype.equals = function(state) {
      return this["this"].name === state;
    };

    State.prototype.callAction = function() {
      var action, args, record;
      action = arguments[0], record = arguments[1], args = 3 <= arguments.length ? __slice.call(arguments, 2) : [];
      try {
        return _callAction.apply(null, [this.options[action], record].concat(__slice.call(args)));
      } catch (error) {
        return this.handleError(record, error);
      }
    };

    State.prototype.forSelect = function() {
      return [this.displayName, this.name];
    };

    State.prototype.update = function(options) {
      if (options == null) options = {};
      this.displayName = options.display ? del(options, 'display') : capitalize(this.name.replace(/_/g, ' '));
      this.options = options;
      return this;
    };

    return State;

  })();

}).call(this);
