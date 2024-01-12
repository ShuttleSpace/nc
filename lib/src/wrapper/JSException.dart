import 'dart:ffi';

import 'package:ffi/ffi.dart';
import 'package:nc/src/binding.dart';
import 'package:nc/src/wrapper/JSContext.dart';
import 'package:nc/src/wrapper/JSObject.dart';
import 'package:nc/src/wrapper/JSValue.dart';

class JSException {
  JSException(this._context, this._ref);
  final JSContext _context;
  final Pointer<JSValueRef> _ref;
  Pointer<JSValueRef> get ref => _ref;
  factory JSException.create(JSContext context, [JSValue? error]) {
    final Pointer<JSValueRef> ref = calloc.call(1);
    ref.value = error?.ref ?? nullptr;
    return JSException(context, ref);
  }

  void invoke(JSObject error) {
    _ref.value = error.value.ref;
  }

  bool get shouldThrow => _ref[0] != nullptr;

  void free() {
    if (_ref != nullptr) {
      calloc.free(_ref);
    }
  }

  JSError get error {
    assert(shouldThrow);
    final JSValue exceptionValue = JSValue(_context, _ref[0]);
    final JSObject jsObject = exceptionValue.object;
    if (exceptionValue.isError) {
      final JSValue message = jsObject.getProperty('message');
      final JSValue stack = jsObject.getProperty('stack');
      final JSValue name = jsObject.getProperty('name');
      final String? stackString = stack.string;
      return JSError(name.string, message.string ?? '',
          stackString != null ? StackTrace.fromString(stackString) : null);
    } else {
      return JSError(null, jsObject.value.string ?? '');
    }
  }
}

class JSError extends Error {
  final String? name;
  final String message;
  JSError(this.name, this.message, [this.stackTrace]);
  @override
  final StackTrace? stackTrace;
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is JSError &&
          runtimeType == other.runtimeType &&
          name == other.name &&
          message == other.message &&
          stackTrace == other.stackTrace;

  @override
  int get hashCode => name.hashCode ^ message.hashCode ^ stackTrace.hashCode;

  @override
  String toString() {
    return '${name ?? 'JSError'}: $message\n$stackTrace';
  }
}
