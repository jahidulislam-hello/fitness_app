import 'dart:convert';
import 'package:gym_cheloper/services/api_constants.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class TermsPrivacyAboutService {
  // Get token from SharedPreferences
  Future<String?> _getToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('token');
  }

  /// Get Terms, Privacy Policy, and About Us content
  Future<Map<String, dynamic>> getContent() async {
    try {
      final token = await _getToken();
      if (token == null) {
        throw Exception('No authentication token found');
      }

      final url = Uri.parse(
        "${ApiConstants.baseUrl}${ApiConstants.getTermsPrivacyAbout}"
      );

      print('🌐 Fetching Terms/Privacy/About from: $url');

      final response = await http.get(
        url,
        headers: {
          "Authorization": "Bearer $token",
          "Accept": "application/json",
        },
      );

      print('📡 Response Status: ${response.statusCode}');
      print('📦 Response Body: ${response.body}');

      if (response.statusCode == 200 || response.statusCode == 201) {
        final jsonResponse = jsonDecode(response.body);
        print('✅ Successfully parsed JSON response');
        return jsonResponse;
      } else {
        print('❌ API Error: ${response.statusCode} - ${response.body}');
        throw Exception('Failed to get content: ${response.body}');
      }
    } catch (e) {
      print('💥 Exception in getContent: $e');
      throw Exception('Error getting content: $e');
    }
  }
}
