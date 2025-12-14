class AppConfig {
  static const String appName = 'My Flutter App';
  static const String version = '1.0.0';
  String get baseApiUrl => 'http://10.0.2.2:5000/api';
  String get baseModuleApiUrl => 'https://module.example.com/api';
  String get baseWebSocketUrl => 'wss://ws.example.com';
  // Add more configuration constants as needed
}