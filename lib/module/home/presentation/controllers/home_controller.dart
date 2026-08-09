import 'package:get/get.dart';
import 'package:quick_eats_app/core/services/database_service.dart';
import 'package:quick_eats_app/core/services/shared_pref_service.dart';

class HomeController extends GetxController {
  var selectedCategory = 'Pizza'.obs;
  var userName = 'User'.obs;
  
  Rx<Stream?> foodItemStream = Rx<Stream?>(null);

  @override
  void onInit() {
    super.onInit();
    getUserInfo();
    loadFoodItems('Pizza');
  }

  Future<void> getUserInfo() async {
    String? name = await SharedPreferenceHelper.getUserName();
    if (name != null) {
      userName.value = name;
    }
  }

  Future<void> loadFoodItems(String category) async {
    selectedCategory.value = category;
    foodItemStream.value = await DatabaseMethods().getFoodItem(category);
  }

  bool isSelected(String category) {
    return selectedCategory.value == category;
  }
}
