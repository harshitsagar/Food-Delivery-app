import 'package:get/get.dart';
import 'package:quick_eats_app/core/services/shared_pref_service.dart';
import '../../../cart/domain/entities/cart_item_entity.dart';
import '../../../cart/domain/usecases/cart_usecases.dart';

class DetailsController extends GetxController {
  final AddToCartUseCase addToCartUseCase;

  DetailsController(this.addToCartUseCase);

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

    final cartItem = CartItemEntity(
      id: '', // Firestore will generate ID if we use add()
      name: name,
      quantity: quantity.value.toString(),
      total: total.value.toStringAsFixed(2),
      image: image,
    );

    await addToCartUseCase.execute(cartItem, userId.value);
    Get.snackbar("Success", "Food Added to Cart!", snackPosition: SnackPosition.BOTTOM);
  }
}
