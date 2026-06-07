class Urls {
  static const String _baseUrl = "https://backend.batteryqk.com/api";
  static String userCreate = "$_baseUrl/users";
  static String userLogin = "$_baseUrl/users/login";

  //----------------------user get -------------------------//
  static String getAllUser = "$_baseUrl/users/self";
  static String getBooking = "$_baseUrl/bookings/user";
  static String showAllListing = "$_baseUrl/listings?limit=1000";
  static String booking = "$_baseUrl/bookings";
  static String usersNotification = "$_baseUrl/notifications/self";
  static String reviews = "$_baseUrl//reviews";
  static String sentReview = "$_baseUrl/reviews";
}
