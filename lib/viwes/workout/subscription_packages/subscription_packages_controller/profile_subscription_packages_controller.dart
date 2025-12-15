
import 'package:get/get.dart';


// Controller
class ProfileSubscriptionController extends GetxController {
  RxInt selectedIndex = 0.obs;

  void selectPlan(int index) {
    selectedIndex.value = index;
  }
}