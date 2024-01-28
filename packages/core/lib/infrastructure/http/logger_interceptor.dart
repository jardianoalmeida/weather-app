// import 'dart:async';

// import '../../core.dart';

// ///
// /// Provide a way to log HTTP requests, responses and errors.
// ///
// class LoggerInterceptor extends HttpInterceptor {
//   /// Intercept and log responses.
//   @override
//   FutureOr<HttpResponse> onResponse(
//     HttpOptions request,
//     HttpResponse response,
//   ) {
//     Log.v(
//       [
//         '${request.method.name.toUpperCase()} ${request.url}',
//         if (request.query != null) 'Query: ${prettyJson(request.query)}',
//         'Response: Status ${_handleStatus(response.status)}',
//         if (response.data != null) 'Body: ${prettyJson(response.data)}',
//       ].join('\n'),
//     );

//     return super.onResponse(request, response);
//   }

//   /// Intercept and log request errors.
//   @override
//   void onError(HttpOptions request, IHttpException exception) {
//     Log.e(
//       [
//         '${request.method.name.toUpperCase()} ${request.url}',
//         if (request.query != null) 'Query: ${prettyJson(request.query)}',
//         if (exception.status != null)
//           'Error: Status ${_handleStatus(exception.status!)}',
//         if (exception.message.isNotEmpty) 'Message: ${exception.message}',
//         if (exception.data != null) 'Data: ${prettyJson(exception.data)}',
//       ].join('\n'),
//     );

//     super.onError(request, exception);
//   }

//   /// Intercept and log the HTTP request being sent.
//   @override
//   FutureOr<HttpOptions> onRequest(HttpOptions request, IHttpClient client) {
//     Log.v(
//       [
//         'Request: ${request.method.name.toUpperCase()} ${request.url}',
//         if (request.query != null) 'Query: ${prettyJson(request.query)}',
//         if (request.headers != null) 'Headers: ${prettyJson(request.headers)}',
//         if (request.data != null) 'Body: ${prettyJson(request.data)}',
//       ].join('\n'),
//     );

//     return super.onRequest(request, client);
//   }

//   String _handleStatus(HttpStatus status) {
//     return '${status.code} ${status.name.toUpperCase()}';
//   }
// }
