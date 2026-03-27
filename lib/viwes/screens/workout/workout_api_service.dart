import 'dart:convert';
import 'package:get/get.dart';
import 'package:gym_cheloper/routes/routes_name.dart';
import 'package:gym_cheloper/services/api_constants.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class WorkoutApiService {
  // Get token from SharedPreferences
  Future<String?> _getToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('token');
  }

  // Handle 401 Unauthorized - redirect to login
  void _handleUnauthorized() {
    // Clear token
    SharedPreferences.getInstance().then((prefs) {
      prefs.remove('token');
      prefs.remove('userId');
    });
    // Navigate to login screen
    Get.offAllNamed(RouteNames.signInScreen);
  }

  // Get Workout Log API
  Future<Map<String, dynamic>> getWorkoutLog() async {
    try {
      final token = await _getToken();
      if (token == null) {
        throw Exception('No authentication token found');
      }

      final url = Uri.parse("${ApiConstants.baseUrl}${ApiConstants.getWorkoutLog}");

      print('🌐 Fetching workout log from: $url');

      final response = await http.get(
        url,
        headers: {
          "Authorization": "Bearer $token",
          "Accept": "application/json",
        },
      );

      print('📡 Response Status: ${response.statusCode}');
      print('📦 Response Body: ${response.body}');

      if (response.statusCode == 401) {
        print('⚠️ Token expired, redirecting to login');
        _handleUnauthorized();
        throw Exception('Token has expired');
      }

      if (response.statusCode == 200) {
        final jsonResponse = jsonDecode(response.body);
        print('✅ Successfully parsed JSON response');
        return jsonResponse;
      } else {
        print('❌ API Error: ${response.statusCode} - ${response.body}');
        throw Exception('Failed to get workout log: ${response.body}');
      }
    } catch (e) {
      print('💥 Exception in getWorkoutLog: $e');
      throw Exception('Error getting workout log: $e');
    }
  }

  // Finish Exercise API
  Future<Map<String, dynamic>> finishExercise({required String workoutId}) async {
    try {
      final token = await _getToken();
      if (token == null) {
        throw Exception('No authentication token found');
      }

      final url = Uri.parse("${ApiConstants.baseUrl}${ApiConstants.finishExercise}");

      print('🌐 Finishing exercise at: $url');

      final response = await http.post(
        url,
        headers: {
          "Authorization": "Bearer $token",
          "Accept": "application/json",
          "Content-Type": "application/json",
        },
        body: jsonEncode({
          "id": workoutId,
        }),
      );

      print('📡 Response Status: ${response.statusCode}');
      print('📦 Response Body: ${response.body}');

      if (response.statusCode == 200 || response.statusCode == 201) {
        final jsonResponse = jsonDecode(response.body);
        print('✅ Successfully finished exercise');
        return jsonResponse;
      } else {
        print('❌ API Error: ${response.statusCode} - ${response.body}');
        throw Exception('Failed to finish exercise: ${response.body}');
      }
    } catch (e) {
      print('💥 Exception in finishExercise: $e');
      throw Exception('Error finishing exercise: $e');
    }
  }
}
