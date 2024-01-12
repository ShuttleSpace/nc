import 'dart:ffi';
import 'dart:typed_data';

import 'package:ffi/ffi.dart';
import 'package:nc/src/binding.dart';

class JSString {
  JSString(this._ref);
  late JSStringRef _ref;
  JSStringRef get ref => _ref;
  JSString.fromString(String? string) {
    if (string == null) {
      _ref = nullptr;
    } else {
      final cString = string.toNativeUtf8();
      try {
        _ref = JSStringCreateWithUTF8CString(cString);
      } finally {
        malloc.free(cString);
      }
    }
  }
  void free() {
    if (_ref != nullptr) {
      JSStringRelease(_ref);
    }
  }

  String? get string {
    if (_ref == nullptr) return null;
    var cString = JSStringGetCharactersPtr(_ref);
    if (cString == nullptr) {
      return null;
    }
    int cStringLength = JSStringGetLength(_ref);
    return String.fromCharCodes(Uint16List.view(
        cString.cast<Uint16>().asTypedList(cStringLength).buffer,
        0,
        cStringLength));
  }
}

extension JSStringIterable on Iterable<JSString> {
  Pointer<JSStringRef> get ref {
    final Pointer<JSStringRef> ret = malloc.call(length);
    for (int i = 0; i < length; i++) {
      ret[i] = elementAt(i).ref;
    }
    return ret;
  }

  void free() {
    for (JSString string in this) {
      string.free();
    }
  }
}
