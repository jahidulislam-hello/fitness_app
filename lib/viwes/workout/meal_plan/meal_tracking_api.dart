import 'dart:convert';
import 'package:gym_cheloper/services/api_constants.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class MealApiService {
  // Get token from SharedPreferences
  Future<String?> _getToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('token'); // Adjust key name as per your app
  }

  // Add Food API
  Future<Map<String, dynamic>> addFood({
    required String foodName,
    required String quantity,
    required String serving,
    required String timeName,
    required String date,
    required String foodType,
    required Map<String, dynamic> nutritionValue,
  }) async {
    try {
      final token = await _getToken();
      if (token == null) {
        throw Exception('No authentication token found');
      }

      final url = Uri.parse("${ApiConstants.baseUrl}${ApiConstants.addFood}");

      final body = {
        "foodName": foodName,
        "quantity": quantity,
        "serving": serving,
        "timeName": timeName,
        "date": date,
        "foodType": foodType,
        "nutritionValue": nutritionValue,
      };

      final response = await http.post(
        url,
        headers: {
          "Authorization": "Bearer $token",
          "Accept": "application/json",
          "Content-Type": "application/json",
        },
        body: jsonEncode(body),
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        return jsonDecode(response.body);
      } else {
        throw Exception('Failed to add food: ${response.body}');
      }
    } catch (e) {
      throw Exception('Error adding food: $e');
    }
  }

  // Get All Meals API
  Future<Map<String, dynamic>> getAllMeals({
    String foodType = "",
    required String date,
  }) async {
    try {
      final token = await _getToken();
      if (token == null) {
        throw Exception('No authentication token found');
      }

      final url = Uri.parse(
          "${ApiConstants.baseUrl}${ApiConstants.getAllMeals}?foodType=$foodType&date=$date"
      );

      print('🌐 Fetching meals from: $url');

      final response = await http.get(
        url,
        headers: {
          "Authorization": "Bearer $token",
          "Accept": "application/json",
        },
      );

      print('📡 Response Status: ${response.statusCode}');
      print('📦 Response Body: ${response.body}');

      if (response.statusCode == 200) {
        final jsonResponse = jsonDecode(response.body);
        print('✅ Successfully parsed JSON response');
        return jsonResponse;
      } else {
        print('❌ API Error: ${response.statusCode} - ${response.body}');
        throw Exception('Failed to get meals: ${response.body}');
      }
    } catch (e) {
      print('💥 Exception in getAllMeals: $e');
      throw Exception('Error getting meals: $e');
    }
  }
}