/// Lokum VPN App Configuration
class AppConfig {
  // API Configuration
  // For local Mac testing with remote backend server
  static const String apiBaseUrl = String.fromEnvironment(
    'API_BASE_URL',
    defaultValue: 'http://172.31.2.242:8000',  // Remote server backend
  );
  
  static const String apiVersion = '/api/v1';
  
  // App Information
  static const String appName = 'Lokum VPN';
  static const String appVersion = '1.0.0';
  
  // VPN Settings
  static const bool enableAdBlock = true;
  static const bool enableMalwareProtection = true;
  
  // Timeouts
  static const Duration connectionTimeout = Duration(seconds: 30);
  static const Duration receiveTimeout = Duration(seconds: 30);
  
  // Storage Keys
  static const String tokenKey = 'auth_token';
  static const String userKey = 'user_data';
  static const String selectedServerKey = 'selected_server';
  static const String vpnConfigKey = 'vpn_config';
  
  // API Endpoints
  static String get authEndpoint => '$apiBaseUrl$apiVersion/auth';
  static String get serversEndpoint => '$apiBaseUrl$apiVersion/servers';
  static String get configEndpoint => '$apiBaseUrl$apiVersion/config';
  static String get statsEndpoint => '$apiBaseUrl$apiVersion/stats';
  static String get protectionEndpoint => '$apiBaseUrl$apiVersion/protection';
}





