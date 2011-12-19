(function() {
  var capitalize, dasherize, extend, flatten, words, _callAction;
  var __slice = Array.prototype.slice;

  exports.starts = function(string, literal, start) {
    return literal === string.substr(start, literal.length);
  };

  exports.ends = function(string, literal, back) {
    var len;
    len = literal.length;
    return literal === string.substr(string.length - len - (back || 0), len);
  };

  exports.compact = function(array) {
    var item, _i, _len, _results;
    _results = [];
    for (_i = 0, _len = array.length; _i < _len; _i++) {
      item = array[_i];
      if (item) _results.push(item);
    }
    return _results;
  };

  exports.count = function(string, substr) {
    var num, pos;
    num = pos = 0;
    if (!substr.length) return 1 / 0;
    while (pos = 1 + string.indexOf(substr, pos)) {
      num++;
    }
    return num;
  };

  exports.merge = function(options, overrides) {
    return extend(extend({}, options), overrides);
  };

  extend = exports.extend = function(object, properties) {
    var key, val;
    for (key in properties) {
      val = properties[key];
      object[key] = val;
    }
    return object;
  };

  exports.flatten = flatten = function(array) {
    var element, flattened, _i, _len;
    flattened = [];
    for (_i = 0, _len = array.length; _i < _len; _i++) {
      element = array[_i];
      if (element instanceof Array) {
        flattened = flattened.concat(flatten(element));
      } else {
        flattened.push(element);
      }
    }
    return flattened;
  };

  exports.del = function(obj, key) {
    var val;
    val = obj[key];
    delete obj[key];
    return val;
  };

  exports.last = function(array, back) {
    return array[array.length - (back || 0) - 1];
  };

  /*
  * @method capitalize()
  * @returns String
  * @short Capitalizes the first character in the string.
  * @example
  *
  *   'hello'.capitalize()              -> 'Hello'
  *   'why hello there...'.capitalize() -> 'Why hello there...'
  */

  capitalize = exports.capitalize = function(str) {
    return str.substr(0, 1).toUpperCase() + str.substr(1).toLowerCase();
  };

  /*
   * @method dasherize()
   * @returns String
   * @short Converts underscores and camel casing to hypens.
   * @example
   *
   *   'a_farewell_to_arms'.dasherize() -> 'a-farewell-to-arms'
   *   'capsLock'.dasherize()           -> 'caps-lock'
   *
  */

  dasherize = exports.dasherize = function(string) {
    return string.replace(/([a-z])([A-Z])/g, '$1-$2').replace(/_/g, '-').toLowerCase();
  };

  /*
   * @method underscore()
   * @returns String
   * @short Converts hyphens and camel casing to underscores.
   * @example
   *
   *   'a-farewell-to-arms'.underscore() -> 'a_farewell_to_arms'
   *   'capsLock'.underscore()           -> 'caps_lock'
   *
  */

  exports.underscore = function(string) {
    return string.replace(/([a-z])([A-Z])/g, '$1_$2').replace(/-/g, '_').toLowerCase();
  };

  /*
   * @method camelize([first] = true)
   * @returns String
   * @short Converts underscores and hyphens to camel case. If [first] is true the first letter will also be capitalized.
   * @example
   *
   *   'caps_lock'.camelize()              -> 'CapsLock'
   *   'moz-border-radius'.camelize()      -> 'MozBorderRadius'
   *   'moz-border-radius'.camelize(false) -> 'mozBorderRadius'
   *
  */

  exports.camelize = function(string, first) {
    var i, part, parts, text;
    parts = dasherize(string).split('-');
    text = (function() {
      var _len, _results;
      _results = [];
      for (i = 0, _len = parts.length; i < _len; i++) {
        part = parts[i];
        if (first === false && i === 0) {
          _results.push(part.toLowerCase());
        } else {
          _results.push(part.substr(0, 1).toUpperCase() + part.substr(1).toLowerCase());
        }
      }
      return _results;
    })();
    return text.join('');
  };

  /*
   * @method words([fn])
   * @returns Array
   * @short Runs callback [fn] against each word in the string. Returns an array of words.
   * @extra A "word" here is defined as any sequence of non-whitespace characters.
   * @example
   *
   *   'broken wear'.words() -> ['broken','wear']
   *   'broken wear'.words(function(w) {
   *     // Called twice: "broken", "wear"
   *   });
  */

  words = exports.words = function(string, fn) {
    var parts;
    parts = string.trim().split(/\s+/);
    if (fn != null) {
      return parts.map(fn);
    } else {
      return parts;
    }
  };

  /*
   * @method titleize()
   * @returns String
   * @short Capitalizes all first letters.
   * @example
   *
   *   'what a title'.titleize() -> 'What A Title'
   *   'no way'.titleize()       -> 'No Way'
  */

  exports.titleize = function(string) {
    return words(string, function(s) {
      return capitalize(s);
    }).join(' ');
  };

  _callAction = function() {
    var action, anAction, args, thisArg, _i, _len, _ref, _results;
    action = arguments[0], thisArg = arguments[1], args = 3 <= arguments.length ? __slice.call(arguments, 2) : [];
    if (Array.isArray(action)) {
      _results = [];
      for (_i = 0, _len = action.length; _i < _len; _i++) {
        anAction = action[_i];
        _results.push(_callAction.apply(null, [anAction, thisArg].concat(__slice.call(args))));
      }
      return _results;
    } else {
      switch (typeof action) {
        case 'string':
          debugger;
          if (thisArg[action] != null) {
            return (_ref = thisArg[action]).call.apply(_ref, [thisArg].concat(__slice.call(args)));
          } else {
            return "No such method " + action;
          }
          break;
        case 'function':
          return action.call.apply(action, [thisArg].concat(__slice.call(args)));
        default:
          return "Unknow type " + action;
      }
    }
  };

  exports._callAction = _callAction;

}).call(this);
