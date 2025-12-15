import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:gym_cheloper/services/api_constants.dart';
import 'package:gym_cheloper/viwes/workout/meal_plan/meal_plan_controller/meal_plan_controller.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class AddMealController extends GetxController {
  // Tab Selection
  var selectedTabIndex = 0.obs;
  final List<String> tabs = ['My Food', 'My Recipe', 'Favourite', 'Search Food'];

  // Search
  var searchController = TextEditingController();
  var searchQuery = ''.obs;
  Timer? _debounceTimer;

  // Loading States
  var isLoading = false.obs;
  var isSearching = false.obs;

  // Data Lists
  var myFoodList = <FoodItem>[].obs;
  var myRecipeList = <FoodItem>[].obs;
  var favouriteList = <FoodItem>[].obs;
  var searchResults = <SearchFoodItem>[].obs;

  // Selected date from parent controller
  String selectedDate = '';

  @override
  void onInit() {
    super.onInit();
    // Note: loadTabData() is called from the UI after selectedDate is set

    // Listen to search query changes
    searchController.addListener(_onSearchChanged);
  }

  @override
  void onClose() {
    searchController.dispose();
    _debounceTimer?.cancel();
    super.onClose();
  }

  void _onSearchChanged() {
    searchQuery.value = searchController.text;

    // Only search if on Search Food tab
    if (selectedTabIndex.value == 3 && searchQuery.value.isNotEmpty) {
      // Cancel previous timer
      _debounceTimer?.cancel();

      // Start new timer (500ms delay)
      _debounceTimer = Timer(Duration(milliseconds: 500), () {
        searchFoodFromNutritionix(searchQuery.value);
      });
    } else if (searchQuery.value.isEmpty) {
      searchResults.clear();
    }
  }

  void changeTab(int index) {
    selectedTabIndex.value = index;
    searchController.clear();
    searchResults.clear();
    loadTabData();
  }

  Future<void> loadTabData() async {
    print('🔄 loadTabData called for tab index: ${selectedTabIndex.value}');
    print('📅 Selected Date: $selectedDate');

    switch (selectedTabIndex.value) {
      case 0: // My Food
        await loadMyFood();
        break;
      case 1: // My Recipe
        await loadMyRecipe();
        break;
      case 2: // Favourite
        await loadFavourites();
        break;
      case 3: // Search Food
        // No initial load needed for search
        print('🔍 Search Food tab - no initial load');
        break;
    }
  }

  // Get token from SharedPreferences
  Future<String?> _getToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('token');
  }

  /// Load My Food from API
  Future<void> loadMyFood() async {
    try {
      isLoading.value = true;
      final token = await _getToken();

      if (token == null) {
        throw Exception('No authentication token found');
      }

      final url = Uri.parse(
        "${ApiConstants.baseUrl}${ApiConstants.getAllMeals}?foodType=food&date=$selectedDate"
      );

      print('🌐 Loading My Food from: $url');

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
        final data = jsonDecode(response.body);
        if (data['success'] == true && data['data'] != null) {
          print('✅ Parsing My Food data...');
          myFoodList.value = _parseMealData(data['data']);
          print('📊 My Food List Count: ${myFoodList.length}');
        }
      }
    } catch (e) {
      print('Error loading my food: $e');
      Get.snackbar(
        'Error',
        'Failed to load my food',
        snackPosition: SnackPosition.BOTTOM,
      );
    } finally {
      isLoading.value = false;
    }
  }

  /// Load My Recipe from API
  Future<void> loadMyRecipe() async {
    try {
      isLoading.value = true;
      final token = await _getToken();

      if (token == null) {
        throw Exception('No authentication token found');
      }

      final url = Uri.parse(
        "${ApiConstants.baseUrl}${ApiConstants.getAllMeals}?foodType=recipe&date=$selectedDate"
      );

      print('🌐 Loading My Recipe from: $url');

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
        final data = jsonDecode(response.body);
        if (data['success'] == true && data['data'] != null) {
          print('✅ Parsing My Recipe data...');
          myRecipeList.value = _parseMealData(data['data']);
          print('📊 My Recipe List Count: ${myRecipeList.length}');
        }
      }
    } catch (e) {
      print('Error loading my recipe: $e');
      Get.snackbar(
        'Error',
        'Failed to load my recipe',
        snackPosition: SnackPosition.BOTTOM,
      );
    } finally {
      isLoading.value = false;
    }
  }

  /// Load Favourites from API
  Future<void> loadFavourites() async {
    try {
      isLoading.value = true;
      final token = await _getToken();

      if (token == null) {
        throw Exception('No authentication token found');
      }

      final url = Uri.parse(
        "${ApiConstants.baseUrl}/meals/get-all-favourite-food"
      );

      print('🌐 Loading Favourites from: $url');

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
        final data = jsonDecode(response.body);
        if (data['success'] == true && data['data'] != null) {
          print('✅ Parsing Favourite data...');
          favouriteList.value = _parseFavouriteData(data['data']);
          print('📊 Favourite List Count: ${favouriteList.length}');
        }
      }
    } catch (e) {
      print('Error loading favourites: $e');
      Get.snackbar(
        'Error',
        'Failed to load favourites',
        snackPosition: SnackPosition.BOTTOM,
      );
    } finally {
      isLoading.value = false;
    }
  }

  /// Parse meal data (My Food, My Recipe)
  List<FoodItem> _parseMealData(List<dynamic> data) {
    List<FoodItem> items = [];

    print('🔍 Parsing meal data. Total items: ${data.length}');

    for (var i = 0; i < data.length; i++) {
      var item = data[i];
      print('📦 Item $i: ${item.runtimeType}');
      print('📦 Item $i keys: ${item is Map ? item.keys.toList() : "Not a map"}');

      if (item is Map && item.containsKey('meals')) {
        final meals = item['meals'] as List<dynamic>?;
        print('✅ Found meals array with ${meals?.length ?? 0} items');

        if (meals != null) {
          for (var mealIndex = 0; mealIndex < meals.length; mealIndex++) {
            var meal = meals[mealIndex];
            print('  🍽️ Meal $mealIndex: ${meal['timeName']}');

            final foods = meal['foods'] as List<dynamic>?;
            print('  🍽️ Foods count: ${foods?.length ?? 0}');

            if (foods != null) {
              for (var food in foods) {
                print('    🥘 Food: ${food['foodName']}');
                items.add(FoodItem.fromJson(food));
              }
            }
          }
        }
      } else {
        print('⚠️ Item $i does not have meals key or is not a Map');
      }
    }

    print('✅ Total parsed food items: ${items.length}');
    return items;
  }

  /// Parse favourite data
  List<FoodItem> _parseFavouriteData(List<dynamic> data) {
    print('🔍 Parsing favourite data. Total items: ${data.length}');

    List<FoodItem> items = [];
    for (var i = 0; i < data.length; i++) {
      var item = data[i];
      print('📦 Favourite Item $i: ${item is Map ? item['foodName'] : "Invalid"}');
      try {
        items.add(FoodItem.fromJson(item));
      } catch (e) {
        print('⚠️ Error parsing favourite item $i: $e');
      }
    }

    print('✅ Total parsed favourite items: ${items.length}');
    return items;
  }

  /// Search Food from Nutritionix API
  Future<void> searchFoodFromNutritionix(String query) async {
    if (query.isEmpty) {
      searchResults.clear();
      return;
    }

    try {
      isSearching.value = true;

      final url = Uri.parse(
        "https://trackapi.nutritionix.com/v2/search/instant?query=$query"
      );

      final response = await http.get(
        url,
        headers: {
          "x-app-id": "8ad96951",
          "x-app-key": "f04813f79bf461d565d4a33ca5a86e9a",
          "Accept": "application/json",
        },
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        if (data['common'] != null) {
          searchResults.value = (data['common'] as List)
              .map((item) => SearchFoodItem.fromJson(item))
              .toList();
        }
      }
    } catch (e) {
      print('Error searching food: $e');
      Get.snackbar(
        'Error',
        'Failed to search food',
        snackPosition: SnackPosition.BOTTOM,
      );
    } finally {
      isSearching.value = false;
    }
  }

  /// Get detailed nutrition info from Nutritionix
  Future<void> selectSearchFood(SearchFoodItem item) async {
    try {
      Get.dialog(
        Center(
          child: CircularProgressIndicator(
            color: Color(0xffF93533),
          ),
        ),
        barrierDismissible: false,
      );

      final url = Uri.parse(
        "https://trackapi.nutritionix.com/v2/natural/nutrients"
      );

      final response = await http.post(
        url,
        headers: {
          "x-app-id": "8ad96951",
          "x-app-key": "f04813f79bf461d565d4a33ca5a86e9a",
          "Content-Type": "application/json",
          "Accept": "application/json",
        },
        body: jsonEncode({"query": item.foodName}),
      );

      Get.back(); // Close loading dialog

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        if (data['foods'] != null && (data['foods'] as List).isNotEmpty) {
          final foodData = data['foods'][0];

          // Show dialog to add this food to a meal time
          _showAddFoodDialog(
            foodName: item.foodName,
            calories: foodData['nf_calories']?.toDouble() ?? 0.0,
            protein: foodData['nf_protein']?.toDouble() ?? 0.0,
            carbs: foodData['nf_total_carbohydrate']?.toDouble() ?? 0.0,
            fat: foodData['nf_total_fat']?.toDouble() ?? 0.0,
            serving: foodData['serving_unit'] ?? 'serving',
            quantity: foodData['serving_qty']?.toString() ?? '1',
          );
        }
      }
    } catch (e) {
      Get.back(); // Close loading dialog if still open
      print('Error getting nutrition details: $e');
      Get.snackbar(
        'Error',
        'Failed to get nutrition details',
        snackPosition: SnackPosition.BOTTOM,
      );
    }
  }

  /// Show dialog to add food to meal time
  void _showAddFoodDialog({
    required String foodName,
    required double calories,
    required double protein,
    required double carbs,
    required double fat,
    required String serving,
    required String quantity,
  }) {
    String selectedMealTime = 'breakfast';
    final mealTimes = ['breakfast', 'lunch', 'dinner', 'snack'];

    Get.dialog(
      Dialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        child: Padding(
          padding: EdgeInsets.all(20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Add $foodName',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 16),
              Text(
                'Nutrition Info:',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                ),
              ),
              SizedBox(height: 8),
              Text('Calories: ${calories.toStringAsFixed(0)} kcal'),
              Text('Protein: ${protein.toStringAsFixed(1)}g'),
              Text('Carbs: ${carbs.toStringAsFixed(1)}g'),
              Text('Fat: ${fat.toStringAsFixed(1)}g'),
              SizedBox(height: 16),
              Text(
                'Select Meal Time:',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                ),
              ),
              SizedBox(height: 8),
              StatefulBuilder(
                builder: (context, setState) {
                  return DropdownButtonFormField<String>(
                    value: selectedMealTime,
                    decoration: InputDecoration(
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                      contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                    ),
                    items: mealTimes.map((time) {
                      return DropdownMenuItem(
                        value: time,
                        child: Text(time[0].toUpperCase() + time.substring(1)),
                      );
                    }).toList(),
                    onChanged: (value) {
                      if (value != null) {
                        setState(() {
                          selectedMealTime = value;
                        });
                      }
                    },
                  );
                },
              ),
              SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  TextButton(
                    onPressed: () => Get.back(),
                    child: Text('Cancel'),
                  ),
                  SizedBox(width: 8),
                  ElevatedButton(
                    onPressed: () async {
                      Get.back(); // Close meal time selection dialog

                      // Add the food using the parent controller
                      try {
                        final parentController = Get.find<MealTrackingController>();
                        await parentController.addNewMealToAPI(
                          foodName: foodName,
                          quantity: quantity,
                          serving: serving,
                          timeName: selectedMealTime,
                          nutritionValue: {
                            'calories': calories,
                            'protein': protein,
                            'carbs': carbs,
                            'fat': fat,
                          },
                        );

                        Get.back(); // Close add meal popup after successful add
                      } catch (e) {
                        print('Error adding food: $e');
                      }
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Color(0xffF93533),
                    ),
                    child: Text(
                      'Add',
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  /// Select food from My Food/Recipe/Favourite lists
  void selectFood(FoodItem item) {
    _showAddFoodDialog(
      foodName: item.foodName,
      calories: item.nutritionValue['calories']?.toDouble() ?? 0.0,
      protein: item.nutritionValue['protein']?.toDouble() ?? 0.0,
      carbs: item.nutritionValue['carbs']?.toDouble() ?? 0.0,
      fat: item.nutritionValue['fat']?.toDouble() ?? 0.0,
      serving: item.serving,
      quantity: item.quantity,
    );
  }
}

// ==================== MODELS ====================

class FoodItem {
  final String id;
  final String foodName;
  final String quantity;
  final String serving;
  final Map<String, dynamic> nutritionValue;
  final bool isFavourite;

  FoodItem({
    required this.id,
    required this.foodName,
    required this.quantity,
    required this.serving,
    required this.nutritionValue,
    this.isFavourite = false,
  });

  factory FoodItem.fromJson(Map<String, dynamic> json) {
    return FoodItem(
      id: json['_id'] ?? '',
      foodName: json['foodName'] ?? '',
      quantity: json['quantity'] ?? '1',
      serving: json['serving'] ?? 'serving',
      nutritionValue: json['nutritionValue'] ?? {},
      isFavourite: json['isFavourite'] ?? false,
    );
  }
}

class SearchFoodItem {
  final String foodName;
  final String? photoUrl;
  final double calories;
  final String servingUnit;
  final double servingQty;

  SearchFoodItem({
    required this.foodName,
    this.photoUrl,
    required this.calories,
    required this.servingUnit,
    required this.servingQty,
  });

  factory SearchFoodItem.fromJson(Map<String, dynamic> json) {
    return SearchFoodItem(
      foodName: json['food_name'] ?? '',
      photoUrl: json['photo']?['thumb'],
      calories: json['nf_calories']?.toDouble() ?? 0.0,
      servingUnit: json['serving_unit'] ?? 'serving',
      servingQty: json['serving_qty']?.toDouble() ?? 1.0,
    );
  }
}
