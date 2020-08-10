@JS()
library js_interop_util;

import 'dart:js_util';

import 'package:js/js.dart';
import 'package:react/react_client/js_backed_map.dart' show JsMap;

@JS('Object.keys')
external List<String> objectKeys(Object object);

@JS('Object.defineProperty')
external void defineProperty(dynamic object, String propertyName, JsMap descriptor);

String getJsFunctionName(Function object) => getProperty(object, 'name') ?? getProperty(object, '\$static_name');
