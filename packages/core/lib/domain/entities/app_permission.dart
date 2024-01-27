/// App permissions
enum AppPermission {
  /// Request user location
  location,

  /// Request user location when app in use
  locationWhenInUse,

  /// Request access to user location anytime
  locationAlways,

  /// Request access to user camera
  camera,

  /// Android: Nothing
  /// iOS: Allows user to accept that app collects data about end users and shares it
  /// with other companies for purposes of tracking across apps and websites.
  appTrackingTransparency,

  /// Request to file storage
  storage,
}
