(function() {
  var State, capitalize, compact, count, del, ends, extend, flatten, last, merge, starts, _ref;
  var __slice = Array.prototype.slice;

  _ref = require('./helpers'), starts = _ref.starts, ends = _ref.ends, compact = _ref.compact, count = _ref.count, merge = _ref.merge, extend = _ref.extend, flatten = _ref.flatten, del = _ref.del, last = _ref.last, capitalize = _ref.capitalize;

  module.exports = State = (function() {

    function State(name, options) {
      if (options == null) options = {};
      this.name = name;
      this.onError = del(options, 'onError');
      this.update(options);
    }

    State.prototype.handleError = function(record, error) {
      if (!(error === "halt_aasm_chain")) {
        if (this.onError != null) {
          switch (typeof this.onError) {
            case 'string':
              return record[this.onError].call(record, error);
            case 'function':
              return this.onError.call(this.onError, record, error);
          }
        } else {
          throw error;
        }
      }
    };

    State.prototype.equals = function(state) {
      return this["this"].name === state;
    };

    State.prototype.callAction = function() {
      var action, anAction, args, record, _i, _len, _results;
      action = arguments[0], record = arguments[1], args = 3 <= arguments.length ? __slice.call(arguments, 2) : [];
      action = this.options[action];
      try {
        if (Array.isArray(action)) {
          _results = [];
          for (_i = 0, _len = action.length; _i < _len; _i++) {
            anAction = action[_i];
            _results.push(this._callAction(anAction, record));
          }
          return _results;
        } else {
          return this._callAction(action, record);
        }
      } catch (error) {
        return this.handleError(record, error);
      }
    };

    State.prototype.forSelect = function() {
      return [this.displayName, this.name];
    };

    State.prototype.update = function(options) {
      if (options == null) options = {};
      if (options.display) {
        this.displayName = del(options, 'display');
      } else {
        this.displayName = capitalize(this.name.replace(/_/g, ' '));
      }
      this.options = options;
      return this;
    };

    State.prototype._callAction = function() {
      var action, args, record, _ref2;
      action = arguments[0], record = arguments[1], args = 3 <= arguments.length ? __slice.call(arguments, 2) : [];
      switch (typeof action) {
        case 'string':
          return (_ref2 = record[action]).call.apply(_ref2, [record].concat(__slice.call(args)));
        case 'function':
          return action.call.apply(action, [action, record].concat(__slice.call(args)));
      }
    };

    return State;

  })();

}).call(this);
