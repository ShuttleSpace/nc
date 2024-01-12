import 'dart:ffi';

import 'package:nc/src/binding.dart';
import 'package:nc/src/wrapper/JSBase.dart';
import 'package:nc/src/wrapper/JSContext.dart';
import 'package:nc/src/wrapper/JSException.dart';
import 'package:nc/src/wrapper/JSString.dart';
import 'package:nc/src/wrapper/JSValue.dart';

class JSObject {
  JSObject(this.context, this._ref);
  late JSObjectRef _ref;
  final JSContext context;
  JSObjectRef get ref => _ref;
  NativeCallable<JSObjectCallAsFunctionCallback_>? _callAsFunctionCallbackNC;

  JSObject.makeFunctionWithCallback(this.context,
      {String? name, JSObjectCallAsFunctionCallback? callAsFunction}) {
    _callAsFunctionCallbackNC = NativeCallable.isolateLocal((JSContextRef ctx1,
        JSObjectRef function,
        JSObjectRef thiz,
        int argc,
        Pointer<JSValueRef> argv,
        Pointer<JSValueRef> exception) {
      final ctxw = JSContext(ctx1);
      final jsfunc = JSObject(ctxw, function);
      final jsthiz = JSObject(ctxw, thiz);
      final argvlist = <JSValue>[];

      for (int i = 0; i < argc; i++) {
        argvlist[i] = JSValue(ctxw, argv[i]);
      }
      final jsexc = JSException(ctxw, exception);
      try {
        print(
            '[JSObject.makeFunctionWithCallback] NativeCallable.isolateLocal.');
        return callAsFunction
                ?.call(ctxw, jsfunc, jsthiz, argc, argvlist, jsexc)
                .ref ??
            nullptr;
      } finally {
        jsfunc.value.unprotect();
        jsthiz.value.unprotect();
        for (var e in argvlist) {
          e.unprotect();
        }
        jsexc.free();
      }
    });
    final JSString? jsname = name != null ? JSString.fromString(name) : null;
    try {
      _ref = JSObjectMakeFunctionWithCallback(context.ref,
          jsname?.ref ?? nullptr, _callAsFunctionCallbackNC!.nativeFunction);
    } finally {
      jsname?.free();
    }
  }

  factory JSObject.makeFunctionWithCallbackRaw(JSContext ctx,
      {String? name,
      Pointer<NativeFunction<JSObjectCallAsFunctionCallback_>>?
          callAsFunction}) {
    final JSString? jsname = name != null ? JSString.fromString(name) : null;
    return JSObject(
        ctx,
        JSObjectMakeFunctionWithCallback(
            ctx.ref, jsname?.ref ?? nullptr, callAsFunction ?? nullptr));
  }

  factory JSObject.makeFunction(
    JSContext context, {
    String? name,
    List<String>? parameterNames,
    required String body,
    String? sourceURL,
    int startingLineNumber = 0,
  }) {
    final JSException exception = JSException.create(context);
    final JSString? jsname = name != null ? JSString.fromString(name) : null;
    final List<JSString>? jsParameterNames =
        parameterNames?.map((e) => JSString.fromString(e)).toList();
    final JSString jsbody = JSString.fromString(body);
    final JSString? jssourceURL =
        sourceURL != null ? JSString.fromString(sourceURL) : null;

    try {
      final JSObject object = JSObject(
          context,
          JSObjectMakeFunction(
              context.ref,
              jsname?.ref ?? nullptr,
              jsParameterNames?.length ?? 0,
              jsParameterNames?.ref ?? nullptr,
              jsbody.ref,
              jssourceURL?.ref ?? nullptr,
              startingLineNumber,
              exception.ref));
      if (exception.shouldThrow) throw exception.error;
      return object;
    } finally {
      exception.free();
      jsname?.free();
      jssourceURL?.free();
      jsParameterNames?.free();
      jsbody.free();
    }
  }

  JSValue callAsFunction({JSObject? thisObject, List<JSValue>? arguments}) {
    final JSException exception = JSException.create(context);
    try {
      final JSValueRef valueRef = JSObjectCallAsFunction(
          context.ref,
          _ref,
          thisObject?.ref ?? nullptr,
          arguments?.length ?? 0,
          arguments?.ref ?? nullptr,
          exception.ref);
      if (exception.shouldThrow) throw exception.error;
      return JSValue(context, valueRef);
    } finally {
      exception.free();
    }
  }

  JSValue getProperty(String propertyName) {
    final JSException exception = JSException.create(context);
    final JSString jspropName = JSString.fromString(propertyName);
    try {
      final JSValue value = JSValue(
          context,
          JSObjectGetProperty(
              context.ref, _ref, jspropName.ref, exception.ref));
      if (exception.shouldThrow) throw exception.error;
      return value;
    } finally {
      exception.free();
      jspropName.free();
    }
  }

  bool hasProperty(String propertyName) {
    final JSString jspropName = JSString.fromString(propertyName);
    try {
      return JSObjectHasProperty(context.ref, _ref, jspropName.ref);
    } finally {
      jspropName.free();
    }
  }

  void setProperty(String propertyName, JSValue? value,
      {JSPropertyAttributes attributes =
          JSPropertyAttributes.kJSPropertyAttributeNone}) {
    final JSException exception = JSException.create(context);
    final JSString jspropName = JSString.fromString(propertyName);
    try {
      JSObjectSetProperty(
          context.ref,
          _ref,
          jspropName.ref,
          value?.ref ?? nullptr,
          JSPropertyAttributes.values.indexOf(attributes),
          exception.ref);
      if (exception.shouldThrow) throw exception.error;
    } finally {
      exception.free();
    }
  }

  JSValue get value => JSValue(context, _ref);

  void free() {
    _callAsFunctionCallbackNC?.close();
  }
}
