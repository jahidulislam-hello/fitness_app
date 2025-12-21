import 'dart:convert';
import 'package:gym_cheloper/services/api_constants.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class WeightTrackingApiService {
  // Get token from SharedPreferences
  Future<String?> _getToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('token');
  }

  // Get Progress Bar Data API
  Future<Map<String, dynamic>> getProgressBar() async {
    try {
      final token = await _getToken();
      if (token == null) {
        throw Exception('No authentication token found');
      }

      final url = Uri.parse("${ApiConstants.baseUrl}${ApiConstants.getProgressBar}");

      print('🌐 Fetching progress bar data from: $url');

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
        throw Exception('Failed to get progress bar data: ${response.body}');
      }
    } catch (e) {
      print('💥 Exception in getProgressBar: $e');
      throw Exception('Error getting progress bar data: $e');
    }
  }

  // Add Progress Bar Data API
  Future<Map<String, dynamic>> addProgressBar({
    required String weight,
    required String bodyFat,
    required String waist,
    required String neck,
    required String arm,
    required String calves,
    required String thigh,
    required String date,
  }) async {
    try {
      final token = await _getToken();
      if (token == null) {
        throw Exception('No authentication token found');
      }

      final url = Uri.parse("${ApiConstants.baseUrl}${ApiConstants.addProgressBar}");

      final body = {
        "weight": weight,
        "bodyFat": bodyFat,
        "waist": waist,
        "neck": neck,
        "arm": arm,
        "calves": calves,
        "thigh": thigh,
        "date": date,
      };

      print('🌐 Adding progress bar data to: $url');
      print('📤 Request Body: $body');

      final response = await http.post(
        url,
        headers: {
          "Authorization": "Bearer $token",
          "Accept": "application/json",
          "Content-Type": "application/json",
        },
        body: jsonEncode(body),
      );

      print('📡 Response Status: ${response.statusCode}');
      print('📦 Response Body: ${response.body}');

      if (response.statusCode == 200 || response.statusCode == 201) {
        final jsonResponse = jsonDecode(response.body);
        print('✅ Successfully added progress bar data');
        return jsonResponse;
      } else {
        print('❌ API Error: ${response.statusCode} - ${response.body}');
        throw Exception('Failed to add progress bar data: ${response.body}');
      }
    } catch (e) {
      print('💥 Exception in addProgressBar: $e');
      throw Exception('Error adding progress bar data: $e');
    }
  }
}
