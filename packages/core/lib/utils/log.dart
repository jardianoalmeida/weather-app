import 'dart:convert';

///
/// JSON encoder to pretty print logs
///
const JsonEncoder _encoder = JsonEncoder.withIndent('  ');

///
/// Attempts to convert an [Object] to a pretty JSON format
///
Object? prettyJson(Object? data) {
  try {
    return _encoder.convert(data);
  } catch (_) {
    return data;
  }
}
