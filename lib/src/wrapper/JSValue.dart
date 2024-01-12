import 'dart:ffi';

import 'package:ffi/ffi.dart';
import 'package:nc/src/binding.dart';
import 'package:nc/src/wrapper/JSBase.dart';
import 'package:nc/src/wrapper/JSContext.dart';
import 'package:nc/src/wrapper/JSException.dart';
import 'package:nc/src/wrapper/JSObject.dart';
import 'package:nc/src/wrapper/JSString.dart';

class JSValue {
  JSValue(this.context, this._ref);
  final JSContext context;
  late JSValueRef _ref;
  JSValueRef get ref => _ref;

  JSObject get object {
    final JSException exception = JSException.create(context);

    try {
      final JSObjectRef objectRef =
          JSValueToObject(context.ref, _ref, exception.ref);
      if (exception.shouldThrow) throw exception.error;
      return JSObject(context, objectRef);
    } finally {
      exception.free();
    }
  }

  JSValue.makeUndefined(this.context)
      : _ref = JSValueMakeUndefined(context.ref);
  JSValue.makeNull(this.context) : _ref = JSValueMakeNull(context.ref);
  JSValue.makeBoolean(this.context, bool boolean)
      : _ref = JSValueMakeBoolean(context.ref, boolean);
  JSValue.makeNumber(this.context, double number)
      : _ref = JSValueMakeNumber(context.ref, number);
  JSValue.makeString(this.context, String string) {
    final jstring = JSString.fromString(string);
    try {
      _ref = JSValueMakeString(context.ref, jstring.ref);
    } finally {
      jstring.free();
    }
  }
  void unprotect() {
    JSValueUnprotect(context.ref, _ref);
  }

  bool get isError {
    const key = '__flujs_internal_isError__';
    return _typeCheckInJS(key, '''
var t = typeof v;
if (t === 'object') { return v instanceof Promise; }
return false;
''', ['v']);
  }

  bool _typeCheckInJS(String key, String jsFunc, List<String> params) {
    final JSObject func;
    if (context.globalObject.hasProperty(key)) {
      func = context.globalObject.getProperty(key).object;
    } else {
      func =
          JSObject.makeFunction(context, body: jsFunc, parameterNames: params);
      context.globalObject.setProperty(key, func.value);
    }
    final JSValue ret = func.callAsFunction(arguments: [this]);
    return ret.isBoolean && ret.boolean;
  }

  bool get isBoolean {
    return type == JSType.kJSTypeBoolean;
  }

  bool get boolean {
    return JSValueToBoolean(context.ref, _ref);
  }

  JSType get type {
    int typeCode = JSValueGetType(context.ref, _ref);
    return JSType.values[typeCode];
  }

  String? get string {
    JSString jsString = stringCopy;
    try {
      return jsString.string;
    } finally {
      jsString.free();
    }
  }

  JSString get stringCopy {
    final JSException exception = JSException.create(context);

    try {
      final JSStringRef stringRef =
          JSValueToStringCopy(context.ref, _ref, exception.ref);
      if (exception.shouldThrow) throw exception.error;
      return JSString(stringRef);
    } finally {
      exception.free();
    }
  }
}

extension JSValueIterable on Iterable<JSValue> {
  Pointer<JSValueRef> get ref {
    final Pointer<JSValueRef> ret = calloc.call(length);
    for (int i = 0; i < length; i++) {
      ret[i] = elementAt(i).ref;
    }
    return ret;
  }
}
