import 'dart:convert';
import 'package:http/http.dart' as http;

class ApiService {
  static const String baseUrl = "http://40.90.224.241:5000";

  // Send OTP
  static Future<http.Response> sendOtp(String countryCode, String mobileNumber) async {
    final url = Uri.parse('$baseUrl/login/otpCreate');
    final response = await http.post(
      url,
      headers: {"Content-Type": "application/json"},
      body: jsonEncode({
        "countryCode": int.parse(countryCode),
        "mobileNumber": int.parse(mobileNumber),
      }),
    );
    return response;
  }

  // Verify OTP
  static Future<http.Response> verifyOtp(String countryCode, String mobileNumber, String otp) async {
    final url = Uri.parse('$baseUrl/login/otpValidate');
    final response = await http.post(
      url,
      headers: {"Content-Type": "application/json"},
      body: jsonEncode({
        "countryCode": int.parse(countryCode),
        "mobileNumber": int.parse(mobileNumber),
        "otp": int.parse(otp),
      }),
    );
    return response;
  }

  // Check if user is logged in
  static Future<http.Response> isLoggedIn() async {
    final url = Uri.parse('$baseUrl/isLoggedIn');
    return await http.get(url);
  }

  // Logout user
  static Future<http.Response> logout(String csrfToken) async {
    final url = Uri.parse('$baseUrl/logout');
    return await http.get(
      url,
      headers: {"X-Csrf-Token": csrfToken},
    );
  }

  // Update User (Set Username)
  static Future<http.Response> updateUser(String countryCode, String userName, String csrfToken) async {
    final url = Uri.parse('$baseUrl/update');
    return await http.post(
      url,
      headers: {
        "Content-Type": "application/json",
        "X-Csrf-Token": csrfToken,
      },
      body: jsonEncode({
        "countryCode": int.parse(countryCode),
        "userName": userName,
      }),
    );
  }

  // Fetch FAQs
  static Future<http.Response> fetchFaqs() async {
    final url = Uri.parse('$baseUrl/faq');
    return await http.get(url);
  }

  // Fetch Products (Filtered)
  static Future<http.Response> fetchProducts(Map<String, dynamic> filterData) async {
    final url = Uri.parse('$baseUrl/filter');
    return await http.post(
      url,
      headers: {"Content-Type": "application/json"},
      body: jsonEncode(filterData),
    );
  }

  // Like a Product
  static Future<http.Response> likeProduct(String listingId, bool isFav, String csrfToken) async {
    final url = Uri.parse('$baseUrl/favs');
    return await http.post(
      url,
      headers: {
        "Content-Type": "application/json",
        "X-Csrf-Token": csrfToken,
      },
      body: jsonEncode({
        "listingId": listingId,
        "isFav": isFav,
      }),
    );
  }

  // Fetch Brands
  static Future<http.Response> fetchBrands() async {
    final url = Uri.parse('$baseUrl/makeWithImages');
    return await http.get(url);
  }

  // Fetch Filters
  static Future<http.Response> fetchFilters() async {
    final url = Uri.parse('$baseUrl/showSearchFilters');
    return await http.get(url);
  }
}
