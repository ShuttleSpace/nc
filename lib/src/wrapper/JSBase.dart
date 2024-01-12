import 'dart:ffi';
import 'dart:typed_data';

import 'package:ffi/ffi.dart';
import 'package:nc/src/binding.dart';

enum JSPropertyAttributes {
  kJSPropertyAttributeNone,
  kJSPropertyAttributeReadOnly,
  kJSPropertyAttributeDontEnum,
  kJSPropertyAttributeDontDelete
}

enum JSType {
  kJSTypeUndefined(0),
  kJSTypeNull(1),
  kJSTypeBoolean(2),
  kJSTypeNumber(3),
  kJSTypeString(4),
  kJSTypeObject(5),
  kJSTypeSymbol(6);

  const JSType(this.value);
  final int value;
}
