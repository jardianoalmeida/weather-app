import 'http_method.dart';

/// HTTP request options
class HttpOptions {
  /// Http path
  final String path;

  /// Http method
  final HttpMethod method;

  /// Http url
  final String? url;

  /// Http url
  final Map<String, dynamic>? data;

  /// Http data
  final Map<String, String>? headers;

  /// Http headers
  final Map<String, dynamic>? query;

  /// Http query
  final Duration? timeout;

  /// Http timeout
  final String? apiVersion;

  ///
  /// Creates a new [HttpOptions]
  ///
  HttpOptions({
    required this.path,
    required this.method,
    this.url,
    this.data,
    this.headers,
    this.query,
    this.timeout,
    this.apiVersion,
  });

  /// Returns a callable class that can be used as follows: `httpOptions.copyWith(...)`.
  HttpOptions copyWith({
    String? path,
    HttpMethod? method,
    String? url,
    Map<String, dynamic>? data,
    Map<String, String>? headers,
    Map<String, dynamic>? query,
    Duration? timeout,
    String? apiVersion,
  }) {
    return HttpOptions(
      path: path ?? this.path,
      method: method ?? this.method,
      url: url ?? this.url,
      data: data ?? this.data,
      headers: headers ?? this.headers,
      query: query ?? this.query,
      timeout: timeout ?? this.timeout,
      apiVersion: apiVersion ?? this.apiVersion,
    );
  }
}
