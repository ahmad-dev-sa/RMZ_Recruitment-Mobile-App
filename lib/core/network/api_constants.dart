class ApiConstants {
  // TODO: Replace with your actual Django backend URL
  // Use http://10.0.2.2:8000 for Android Emulator pointing to localhost
  // Use http://127.0.0.1:8000 for iOS Simulator pointing to localhost
  // For production, use your actual domain e.g., https://api.rmz-recruitment.com
  static const String baseUrl = 'https://rmz-test.anafannan.cloud/api/v1/';

  // Auth Endpoints
  static const String register = 'auth/register/';
  static const String login = 'auth/login/';
  static const String refresh = 'auth/refresh/';
  static const String me = 'auth/me/';

  // Marketing Endpoints
  static const String banners = 'marketing/banners/';
  
  // Notifications Endpoints
  static const String notifications = 'notifications/';
  static const String markAsRead = 'notifications/mark_as_read/';
  
  // Services Endpoints
  static const String categories = 'categories/';
  static const String services = 'services/';
}
