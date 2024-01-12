import 'dart:ffi';

import 'package:nc/src/binding.dart';
import 'package:nc/src/wrapper/JSObject.dart';

class JSContext {
  JSContext(this._ref);
  final JSContextRef _ref;
  JSContextRef get ref => _ref;

  JSObject get globalObject {
    return JSObject(this, JSContextGetGlobalObject(_ref));
  }

  void free() {
    if (_ref != nullptr) {
      return JSGlobalContextRelease(_ref);
    }
  }
}

class JSGlobalContext extends JSContext {
  JSGlobalContext(JSGlobalContextRef ref) : super(ref);
  factory JSGlobalContext.create() {
    return JSGlobalContext(JSGlobalContextCreate(nullptr));
  }
}
