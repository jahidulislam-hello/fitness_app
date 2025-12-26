import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:gym_cheloper/services/api_constants.dart';
import 'package:gym_cheloper/viwes/workout/meal_plan/meal_plan_controller/meal_plan_controller.dart';
import 'package:gym_cheloper/viwes/workout/meal_plan/meal_plan_screen/food_popup.dart';
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
      print('🔎 Searching for: $query');

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

      print('📡 Search response status: ${response.statusCode}');

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        if (data['common'] != null) {
          searchResults.value = (data['common'] as List)
              .map((item) => SearchFoodItem.fromJson(item))
              .toList();
          print('✅ Found ${searchResults.length} search results');
        } else {
          print('⚠️ No results found in response');
        }
      } else {
        print('❌ Search API error: ${response.statusCode}');
      }
    } catch (e) {
      print('❌ Error searching food: $e');
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
  Future<void> selectSearchFood(SearchFoodItem item, BuildContext context) async {
    try {
      print('🔍 selectSearchFood called for: ${item.foodName}');

      // Use loading state instead of dialog
      isLoading.value = true;

      final url = Uri.parse(
        "https://trackapi.nutritionix.com/v2/natural/nutrients"
      );

      print('🌐 Fetching nutrition details from Nutritionix...');

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

      print('📡 Nutritionix response status: ${response.statusCode}');

      isLoading.value = false; // Stop loading

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        print('📦 Response data: ${data.toString().substring(0, 200)}...');

        if (data['foods'] != null && (data['foods'] as List).isNotEmpty) {
          final foodData = data['foods'][0];

          print('✅ Showing FoodPopup for: ${item.foodName}');
          print('   Calories: ${foodData['nf_calories']}');
          print('   Protein: ${foodData['nf_protein']}');
          print('   Carbs: ${foodData['nf_total_carbohydrate']}');
          print('   Fat: ${foodData['nf_total_fat']}');

          // Show dialog to add this food to a meal time
          _showAddFoodDialog(
            context: context,
            foodName: item.foodName,
            calories: foodData['nf_calories']?.toDouble() ?? 0.0,
            protein: foodData['nf_protein']?.toDouble() ?? 0.0,
            carbs: foodData['nf_total_carbohydrate']?.toDouble() ?? 0.0,
            fat: foodData['nf_total_fat']?.toDouble() ?? 0.0,
            serving: foodData['serving_unit'] ?? 'serving',
            quantity: foodData['serving_qty']?.toString() ?? '1',
          );
        } else {
          print('⚠️ No food data in response');
        }
      } else {
        print('❌ API error: ${response.statusCode} - ${response.body}');
      }
    } catch (e) {
      isLoading.value = false; // Stop loading on error
      print('❌ Error getting nutrition details: $e');
      print('Stack trace: ${StackTrace.current}');
    }
  }

  /// Show FoodPopup to add food
  void _showAddFoodDialog({
    required BuildContext context,
    required String foodName,
    required double calories,
    required double protein,
    required double carbs,
    required double fat,
    required String serving,
    required String quantity,
  }) {
    print('🎯 _showAddFoodDialog called');
    print('   Food: $foodName');
    print('   Quantity: $quantity, Serving: $serving');

    try {
      showModalBottomSheet(
        context: context,
        isScrollControlled: true,
        backgroundColor: Colors.transparent,
        builder: (BuildContext context) {
          return FoodPopup(
            foodName: foodName,
            baseCalories: calories,
            baseProtein: protein,
            baseCarbs: carbs,
            baseFat: fat,
            initialServing: serving,
            initialQuantity: quantity,
            onAddFood: ({
              required String foodName,
              required String quantity,
              required String serving,
              required String timeName,
              required Map<String, dynamic> nutritionValue,
            }) async {
              Navigator.of(context).pop(); // Close FoodPopup

              // Show loading
              isLoading.value = true;

              try {
                // Call API to add food
                await addFoodToAPI(
                  foodName: foodName,
                  quantity: quantity,
                  serving: serving,
                  timeName: timeName,
                  date: selectedDate,
                  foodType: 'food',
                  nutritionValue: nutritionValue,
                );

                isLoading.value = false;
                Navigator.of(context).pop(); // Close AddMealPopup

                // Refresh parent controller
                try {
                  final parentController = Get.find<MealTrackingController>();
                  await parentController.loadMealsFromAPI();
                } catch (e) {
                  print('Parent controller not found: $e');
                }

                print('✅ Food added successfully!');
              } catch (e) {
                isLoading.value = false;
                print('❌ Error adding food: $e');
              }
            },
          );
        },
      );
      print('✅ FoodPopup bottom sheet shown');
    } catch (e, stackTrace) {
      print('❌ Error showing FoodPopup: $e');
      print('Stack trace: $stackTrace');
    }
  }

  /// Add food to API
  Future<void> addFoodToAPI({
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

      print('🌐 Adding food to: $url');
      print('📦 Request body: {');
      print('  foodName: $foodName,');
      print('  quantity: $quantity,');
      print('  serving: $serving,');
      print('  timeName: $timeName,');
      print('  date: $date,');
      print('  foodType: $foodType,');
      print('  nutritionValue: $nutritionValue');
      print('}');

      final response = await http.post(
        url,
        headers: {
          "Authorization": "Bearer $token",
          "Content-Type": "application/json",
          "Accept": "application/json",
        },
        body: jsonEncode({
          "foodName": foodName,
          "quantity": quantity,
          "serving": serving,
          "timeName": timeName,
          "date": date,
          "foodType": foodType,
          "nutritionValue": {
            "protein": nutritionValue['protein'],
            "fat": nutritionValue['fat'],
            "carbs": nutritionValue['carbs'],
            "calories": nutritionValue['calories'],
          },
        }),
      );

      print('📡 Response Status: ${response.statusCode}');
      print('📦 Response Body: ${response.body}');

      if (response.statusCode == 200 || response.statusCode == 201) {
        final data = jsonDecode(response.body);
        if (data['success'] == true) {
          print('✅ Food added successfully');
        } else {
          throw Exception(data['message'] ?? 'Failed to add food');
        }
      } else {
        throw Exception('Server error: ${response.statusCode}');
      }
    } catch (e) {
      print('❌ Error in addFoodToAPI: $e');
      rethrow;
    }
  }

  /// Select food from My Food/Recipe/Favourite lists
  void selectFood(FoodItem item, BuildContext context) {
    _showAddFoodDialog(
      context: context,
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
