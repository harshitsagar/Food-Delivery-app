import 'package:get/get.dart';
import 'package:quick_eats_app/core/services/database_service.dart';
import 'package:quick_eats_app/core/services/shared_pref_service.dart';

class DetailsController extends GetxController {
  var quantity = 1.obs;
  var total = 0.0.obs;
  var userId = ''.obs;

  late String price;

  void init(String priceValue) {
    price = priceValue;
    total.value = double.parse(priceValue);
    getUserId();
  }

  Future<void> getUserId() async {
    String? id = await SharedPreferenceHelper.getUserId();
    if (id != null) {
      userId.value = id;
    }
  }

  void increment() {
    quantity.value++;
    total.value += double.parse(price);
  }

  void decrement() {
    if (quantity.value > 1) {
      quantity.value--;
      total.value -= double.parse(price);
    }
  }

  Future<void> addToCart(String name, String image) async {
    if (userId.value.isEmpty) {
      Get.snackbar("Error", "User not logged in");
      return;
    }

    Map<String, dynamic> addFoodtoCart = {
      "Name": name,
      "Quantity": quantity.value.toString(),
      "Total": total.value.toStringAsFixed(2),
      "Image": image,
    };

    await DatabaseMethods().addFoodToCart(addFoodtoCart, userId.value);
    Get.snackbar("Success", "Food Added to Cart!", snackPosition: SnackPosition.BOTTOM);
  }
}
