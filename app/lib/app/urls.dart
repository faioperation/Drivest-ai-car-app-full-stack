class Urls{
  //static const String _baseUrl = "https://admin-dashboard.drivestai.com";
  static const String _baseUrl = "https://backend.drivestai.com";
  //static const String _aibaseUrl = "https://backend.drivestai.com";

  static const String signUpUrl = '${_baseUrl}/register';
  static const String signInUrl = '${_baseUrl}/login';
  static const String deleteAccountUrl = '${_baseUrl}/user/delete-account';
  static const String invoiceUrl = '${_baseUrl}/user/invoices';
  static const String signInWithGoogleUrl = '${_baseUrl}/google-login';
  static const String carsUrl = '${_baseUrl}/user/cars?initial=true';
  static const String forgotPassUrl = '${_baseUrl}/forgot-password';
  static const String verifyOtpUrl = '${_baseUrl}/verify-otp';
  static const String resetPassUrl = '${_baseUrl}/reset-password';
  static const String changePassUrl = '${_baseUrl}/user/change-password';
  static const String userProfileUrl = '${_baseUrl}/user/profile';
  static const String editProfileUrl = '${_baseUrl}/user/edit-profile';
  static const String topBrandsUrl = '${_baseUrl}/user/brands';
  static const String notificationUrl = '${_baseUrl}/user/notifications';
  static const String notificationReadUrl = '${_baseUrl}/user/notification-read';
  static const String notificationAllReadUrl = '${_baseUrl}/user/notifications-all-read';
  static const String carAnalyzeUrl = '${_baseUrl}/ai/analyze';
  static const String ticketUrl = '${_baseUrl}/user/create-ticket';
  static const String aiSuggestUrl = '${_baseUrl}/ai/suggest';
  static const String compareUrl = '${_baseUrl}/ai/compare';
  static const String showFavouriteUrl = '${_baseUrl}/user/favorites';
  static const String createStripeSessionUrl = '${_baseUrl}/subscription/create';
  static const String createWebHookUrlUrl = '${_baseUrl}/subscription/stripe/webhook';
  static const String addFavouriteUrl = '${_baseUrl}/user/favorites/toggle';
  static String deleteFavouriteUrl(carId) => "$_baseUrl/user/favorites/$carId";
  static String carDetailsUrl(carId) => "$_baseUrl/user/cars-details/$carId";
}