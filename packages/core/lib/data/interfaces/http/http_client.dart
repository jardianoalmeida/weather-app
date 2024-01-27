import 'dart:async';

import '../../data.dart';

///
/// Http client
///
abstract class IHttpClient {
  ///
  /// Http Get
  ///
  Future<HttpResponse> get(
    String url, {
    Map<String, String>? headers,
    Map<String, dynamic>? query,
    Duration? timeout,
    String? apiVersion,
  });

  ///
  /// Http Post
  ///
  Future<HttpResponse> post(
    String url, {
    Map<String, String>? headers,
    Map<String, dynamic>? body,
    Duration? timeout,
    String? apiVersion,
  });

  ///
  /// Http Put
  ///
  Future<HttpResponse> put(
    String url, {
    Map<String, String>? headers,
    Map<String, dynamic>? body,
    Duration? timeout,
    String? apiVersion,
  });

  ///
  /// Http Path
  ///
  Future<HttpResponse> patch(
    String url, {
    Map<String, String>? headers,
    Map<String, dynamic>? body,
    Duration? timeout,
    String? apiVersion,
  });

  ///
  /// Http Delete
  ///
  Future<HttpResponse> delete(
    String url, {
    Map<String, String>? headers,
    Map<String, dynamic>? body,
    Duration? timeout,
    String? apiVersion,
  });

  ///
  /// Adds a custom interceptor to handle requests, responses and errors.
  ///
  /// If there's more than one interceptor, they'll be executed sequentially.
  ///
  void addInterceptors(List<HttpInterceptor> interceptors);
}
