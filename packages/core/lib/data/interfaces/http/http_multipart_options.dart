import '../interfaces.dart';

/// HTTP request options
class HttpMultipartOptions {
  final List<HttpMultipartFile> files;
  final Map<String, String>? fields;

  /// Create a [HttpMultipartOptions]
  const HttpMultipartOptions({
    required this.files,
    this.fields,
  });
}
