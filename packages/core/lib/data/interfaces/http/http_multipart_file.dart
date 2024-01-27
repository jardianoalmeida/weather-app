import 'dart:io';

///HTTP multipart file.

class HttpMultipartFile {
  final String field;
  final File file;

  /// Create a [HttpMultipartFile]
  const HttpMultipartFile({
    required this.field,
    required this.file,
  });
}
