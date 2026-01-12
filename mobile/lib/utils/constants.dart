/// App constants
class AppConstants {
  // Connection timeouts
  static const Duration connectionTimeout = Duration(seconds: 30);
  static const Duration receiveTimeout = Duration(seconds: 30);
  
  // Polling intervals
  static const Duration statusPollInterval = Duration(seconds: 5);
  static const Duration statsRefreshInterval = Duration(seconds: 30);
  
  // UI Constants
  static const double defaultPadding = 16.0;
  static const double cardBorderRadius = 12.0;
  static const double buttonBorderRadius = 12.0;
  
  // Colors
  static const int primaryColorValue = 0xFF6C63FF;
  static const int backgroundColorValue = 0xFF0A0E27;
  static const int cardColorValue = 0xFF1A1F3A;
  
  // Messages
  static const String connectionSuccess = 'Connected successfully';
  static const String connectionFailed = 'Failed to connect';
  static const String disconnectionSuccess = 'Disconnected successfully';
  static const String disconnectionFailed = 'Failed to disconnect';
}





