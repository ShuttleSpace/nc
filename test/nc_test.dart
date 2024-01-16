import 'dart:ffi';
import 'dart:math';
import 'dart:typed_data';

import 'package:ffi/ffi.dart';
import 'package:nc/src/binding.dart';
import 'package:nc/src/wrapper/JSContext.dart';
import 'package:nc/src/wrapper/JSException.dart';
import 'package:nc/src/wrapper/JSObject.dart';
import 'package:nc/src/wrapper/JSValue.dart';
import 'package:test/test.dart';

void main() {
  group('A group of tests', () {
    setUp(() {
      // Additional setup goes here.
    });

    test('invoke with NativeCallable wrapper', () {
      final gctx = JSGlobalContext.create();
      final consoleLogJSV = JSObject.makeFunctionWithCallback(gctx,
          name: 'console.log', callAsFunction: _console_log);
      final ret = consoleLogJSV.callAsFunction(arguments: [
        JSValue.makeString(gctx, 'test...'),
        JSValue.makeBoolean(gctx, false),
        JSValue.makeNumber(gctx, 100),
        JSValue.makeNull(gctx),
        JSValue.makeUndefined(gctx)
      ]);
      expect(ret.string, '1');
      // consoleLogJSV.free();
      // gctx.free();
    });

/*     test('invoke with NativeCallable wrapper', () {
      final gctx = JSGlobalContext.create();
      final consoleLogJSV = JSObject.makeFunctionWithCallback(
        gctx,
        name: 'console.log',
        callAsFunction:
            (ctx, function, thisObject, argumentCount, arguments, exception) {
          // do something.....
          return JSValue.makeUndefined(ctx);
        },
      );
      final ret = consoleLogJSV.callAsFunction(arguments: [
        JSValue.makeString(gctx, 'test...'),
        JSValue.makeBoolean(gctx, false),
        JSValue.makeNumber(gctx, 100),
        JSValue.makeNull(gctx),
        JSValue.makeUndefined(gctx)
      ]);
      expect(ret.string, '1');
      consoleLogJSV.free();
      gctx.free();
    }); */
/*     test('invoke with ffi', () {
      final gctx = JSGlobalContext.create();
      final Pointer<NativeFunction<JSObjectCallAsFunctionCallback_>> cb =
          Pointer.fromFunction(_console_log_raw);

      final consoleLogJSV = JSObject.makeFunctionWithCallbackRaw(gctx,
          name: 'console.log', callAsFunction: cb);
      final ret = consoleLogJSV.callAsFunction(arguments: [
        JSValue.makeString(gctx, 'test...'),
        JSValue.makeBoolean(gctx, false),
        JSValue.makeNumber(gctx, 100),
        JSValue.makeNull(gctx),
        JSValue.makeUndefined(gctx)
      ]);
      expect(ret.string, '1');
      consoleLogJSV.free();
      gctx.free();
    }); */

/*     test('invoke with NativeCallable global variable', () {
      final gctx = JSGlobalContext.create();
      final NativeCallable<JSObjectCallAsFunctionCallback_> nativeCallable =
          NativeCallable<JSObjectCallAsFunctionCallback_>.isolateLocal(
              _console_log_raw);
      final cb = nativeCallable.nativeFunction;
      final consoleLogJSV = JSObject.makeFunctionWithCallbackRaw(gctx,
          name: 'console.log', callAsFunction: cb);
      final ret = consoleLogJSV.callAsFunction(arguments: [
        JSValue.makeString(gctx, 'test...'),
        JSValue.makeBoolean(gctx, false),
        JSValue.makeNumber(gctx, 100),
        JSValue.makeNull(gctx),
        JSValue.makeUndefined(gctx)
      ]);
      expect(ret.string, '1');
      consoleLogJSV.free();
      gctx.free();
    }); */
  });
}

JSValue _console_log(JSContext ctx, JSObject func, JSObject thiz, int argc,
    List<JSValue> argv, JSException ex) {
  print('【dart】_console_log: ${func.getProperty('name').string}, argc: $argc');
  argv.forEach((e) => print('${e.string}'));
  return JSValue.makeNumber(ctx, 1);
}

JSValueRef _console_log_raw(
    JSContextRef ctx,
    JSObjectRef func,
    JSObjectRef thiz,
    int argc,
    Pointer<JSValueRef> argv,
    Pointer<JSValueRef> ex) {
  StringBuffer sb = StringBuffer();
  for (int i = 0; i < argc; i++) {
    final jsv = argv[i];
    final jsstr = JSValueToStringCopy(ctx, jsv, nullptr);
    var cString = JSStringGetCharactersPtr(jsstr);
    if (cString == nullptr) {
      continue;
    }
    int cStringLength = JSStringGetLength(jsstr);
    final s = String.fromCharCodes(Uint16List.view(
        cString.cast<Uint16>().asTypedList(cStringLength).buffer,
        0,
        cStringLength));
    sb.write("$s \t");
  }
  print('【dart】_console_log_raw: ${sb.toString()}');
  return JSValueMakeNumber(ctx, 1);
}
