(function() {
  var StateTransition, _callAction;
  var __slice = Array.prototype.slice;

  _callAction = require('./helpers')._callAction;

  module.exports = StateTransition = (function() {

    function StateTransition(opts) {
      this.from = opts.from, this.to = opts.to, this.guard = opts.guard, this.onTransition = opts.onTransition, this.onError = opts.onError;
      this.opts = opts;
    }

    StateTransition.prototype.handleError = function(record, error) {
      if (this.onError == null) throw error;
      return _callAction(this.onError, record);
    };

    StateTransition.prototype.perform = function() {
      var args, obj;
      obj = arguments[0], args = 2 <= arguments.length ? __slice.call(arguments, 1) : [];
      try {
        return _callAction.apply(null, [this.guard, obj].concat(__slice.call(args)));
      } catch (error) {
        this.handleError(error);
        return false;
      }
    };

    StateTransition.prototype.execute = function() {
      var args, obj;
      obj = arguments[0], args = 2 <= arguments.length ? __slice.call(arguments, 1) : [];
      try {
        return _callAction.apply(null, [this.onTransition, obj].concat(__slice.call(args)));
      } catch (error) {
        return this.handleError(obj, error);
      }
    };

    StateTransition.prototype.equals = function(obj) {
      return this.from === obj.from && this.to === obj.to;
    };

    StateTransition.prototype.isFrom = function(value) {
      return this.from === value;
    };

    StateTransition.prototype.isTo = function(value) {
      return this.to === value;
    };

    return StateTransition;

  })();

}).call(this);
