/// Failure result from location detector
class LocationFailure {
  /// Message describing the failure
  final String? message;

  LocationFailure({this.message});

  /// Creates new instance of [LocationFailure] that occurs on the server
  factory LocationFailure.server({String? message}) => LocationFailure(message: message);

  /// Creates new instance of [LocationFailure] that occurs when app asks for certain permissions
  /// such as camera permission
  factory LocationFailure.permissions({String? message}) => LocationFailure(message: message);

  /// Creates new instance of [LocationFailure] that are unexpected for the application
  factory LocationFailure.unexpected() => LocationFailure();
}
