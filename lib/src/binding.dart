import 'dart:ffi';

import 'package:ffi/ffi.dart';
import 'package:nc/src/wrapper/JSBase.dart';
import 'package:nc/src/wrapper/JSContext.dart';
import 'package:nc/src/wrapper/JSException.dart';
import 'package:nc/src/wrapper/JSObject.dart';
import 'package:nc/src/wrapper/JSValue.dart';

typedef LookupFunc = Pointer<T> Function<T extends NativeType>(
    String symbolName);

final class JSContext_ extends Opaque {}

typedef JSContextRef = Pointer<JSContext_>;
typedef JSGlobalContextRef = JSContextRef;

typedef JSChar = UnsignedChar;

final class JSString_ extends Opaque {}

typedef JSStringRef = Pointer<JSString_>;

final class JSClass_ extends Opaque {}

typedef JSClassRef = Pointer<JSClass_>;

final class JSValue_ extends Opaque {}

typedef JSObjectRef = Pointer<JSValue_>;

typedef JSValueRef = Pointer<JSValue_>;

typedef JSObjectCallAsFunctionCallback_ = JSValueRef Function(
    JSContextRef ctx,
    JSObjectRef function,
    JSObjectRef thisObject,
    Size argumentCount,
    Pointer<JSValueRef> arguments,
    Pointer<JSValueRef> exception);
typedef JSObjectCallAsFunctionCallback = JSValue Function(
    JSContext ctx,
    JSObject function,
    JSObject thisObject,
    int argumentCount,
    List<JSValue> arguments,
    JSException exception);

final kLookup =
    DynamicLibrary.open('JavaScriptCore.framework/JavaScriptCore').lookup;

final JSGlobalContextRef Function(JSClassRef globalObjectClass)
    JSGlobalContextCreate =
    kLookup<NativeFunction<JSGlobalContextRef Function(JSClassRef)>>(
            'JSGlobalContextCreate')
        .asFunction();

final void Function(JSGlobalContextRef ctx) JSGlobalContextRelease =
    kLookup<NativeFunction<Void Function(JSGlobalContextRef)>>(
            'JSGlobalContextRelease')
        .asFunction();

final JSObjectRef Function(
    JSContextRef ctx,
    JSStringRef name,
    Pointer<NativeFunction<JSObjectCallAsFunctionCallback_>>
        callAsFunction) JSObjectMakeFunctionWithCallback = kLookup<
            NativeFunction<
                JSObjectRef Function(JSContextRef, JSStringRef,
                    Pointer<NativeFunction<JSObjectCallAsFunctionCallback_>>)>>(
        'JSObjectMakeFunctionWithCallback')
    .asFunction();

final JSValueRef Function(
    JSContextRef ctx,
    JSObjectRef object,
    JSObjectRef thisObject,
    int argumentCount,
    Pointer<JSValueRef> arguments,
    Pointer<JSValueRef> exception) JSObjectCallAsFunction = kLookup<
        NativeFunction<
            JSValueRef Function(
                JSContextRef,
                JSObjectRef,
                JSObjectRef,
                Size,
                Pointer<JSValueRef>,
                Pointer<JSValueRef>)>>('JSObjectCallAsFunction')
    .asFunction();

final JSValueRef Function(JSContextRef ctx, JSStringRef string)
    JSValueMakeString =
    kLookup<NativeFunction<JSValueRef Function(JSContextRef, JSStringRef)>>(
            'JSValueMakeString')
        .asFunction();

final JSValueRef Function(JSContextRef ctx, double number) JSValueMakeNumber =
    kLookup<NativeFunction<JSValueRef Function(JSContextRef, Double)>>(
            'JSValueMakeNumber')
        .asFunction();

final JSValueRef Function(JSContextRef ctx, bool boolean) JSValueMakeBoolean =
    kLookup<NativeFunction<JSValueRef Function(JSContextRef, Bool)>>(
            'JSValueMakeBoolean')
        .asFunction();

final JSValueRef Function(JSContextRef ctx) JSValueMakeNull =
    kLookup<NativeFunction<JSValueRef Function(JSContextRef)>>(
            'JSValueMakeNull')
        .asFunction();

final JSValueRef Function(JSContextRef ctx) JSValueMakeUndefined =
    kLookup<NativeFunction<JSValueRef Function(JSContextRef)>>(
            'JSValueMakeUndefined')
        .asFunction();

final JSStringRef Function(Pointer<Utf8> string) JSStringCreateWithUTF8CString =
    kLookup<NativeFunction<JSStringRef Function(Pointer<Utf8>)>>(
            'JSStringCreateWithUTF8CString')
        .asFunction();

final void Function(JSStringRef string) JSStringRelease =
    kLookup<NativeFunction<Void Function(JSStringRef)>>('JSStringRelease')
        .asFunction();

final JSObjectRef Function(
        JSContextRef ctx, JSValueRef value, Pointer<JSValueRef> exception)
    JSValueToObject = kLookup<
            NativeFunction<
                JSObjectRef Function(JSContextRef, JSValueRef,
                    Pointer<JSValueRef>)>>('JSValueToObject')
        .asFunction();

final void Function(JSContextRef ctx, JSValueRef value) JSValueUnprotect =
    kLookup<NativeFunction<Void Function(JSContextRef, JSValueRef)>>(
            'JSValueUnprotect')
        .asFunction();

final JSObjectRef Function(JSContextRef ctx) JSContextGetGlobalObject =
    kLookup<NativeFunction<JSObjectRef Function(JSContextRef)>>(
            'JSContextGetGlobalObject')
        .asFunction();

final JSValueRef Function(
    JSContextRef ctx,
    JSObjectRef object,
    JSStringRef propertyName,
    Pointer<JSValueRef> exception) JSObjectGetProperty = kLookup<
        NativeFunction<
            JSValueRef Function(JSContextRef, JSObjectRef, JSStringRef,
                Pointer<JSValueRef>)>>('JSObjectGetProperty')
    .asFunction();

final void Function(
    JSContextRef ctx,
    JSObjectRef object,
    JSStringRef propertyName,
    JSValueRef value,
    int attributes,
    Pointer<JSValueRef> exception) JSObjectSetProperty = kLookup<
        NativeFunction<
            Void Function(JSContextRef, JSObjectRef, JSStringRef, JSValueRef,
                Uint32, Pointer<JSValueRef>)>>('JSObjectSetProperty')
    .asFunction();

final bool Function(JSContextRef ctx, JSObjectRef object,
    JSStringRef propertyName) JSObjectHasProperty = kLookup<
        NativeFunction<
            Bool Function(
                JSContextRef, JSObjectRef, JSStringRef)>>('JSObjectHasProperty')
    .asFunction();

final JSObjectRef Function(
    JSContextRef ctx,
    JSStringRef name,
    int parameterCount,
    Pointer<JSStringRef> parameterNames,
    JSStringRef body,
    JSStringRef sourceURL,
    int startingLineNumber,
    Pointer<JSValueRef> exception) JSObjectMakeFunction = kLookup<
        NativeFunction<
            JSObjectRef Function(
                JSContextRef,
                JSStringRef,
                Uint32,
                Pointer<JSStringRef>,
                JSStringRef,
                JSStringRef,
                Int32,
                Pointer<JSValueRef>)>>('JSObjectMakeFunction')
    .asFunction();

final int /*JSType*/ Function(JSContextRef ctx, JSValueRef value)
    JSValueGetType =
    kLookup<NativeFunction<Uint32 Function(JSContextRef, JSValueRef)>>(
            'JSValueGetType')
        .asFunction();

final bool Function(JSContextRef ctx, JSValueRef value) JSValueToBoolean =
    kLookup<NativeFunction<Bool Function(JSContextRef, JSValueRef)>>(
            'JSValueToBoolean')
        .asFunction();

final JSStringRef Function(
        JSContextRef ctx, JSValueRef value, Pointer<JSValueRef> exception)
    JSValueToStringCopy = kLookup<
            NativeFunction<
                JSStringRef Function(JSContextRef, JSValueRef,
                    Pointer<JSValueRef>)>>('JSValueToStringCopy')
        .asFunction();

final Pointer<JSChar> Function(JSStringRef string) JSStringGetCharactersPtr =
    kLookup<NativeFunction<Pointer<JSChar> Function(JSStringRef)>>(
            'JSStringGetCharactersPtr')
        .asFunction();

final int Function(JSStringRef string) JSStringGetLength =
    kLookup<NativeFunction<Int32 Function(JSStringRef)>>('JSStringGetLength')
        .asFunction();
