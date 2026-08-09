import 'package:get/get.dart';
import 'package:quick_eats_app/module/food_details/presentation/controllers/details_controller.dart';

class DetailsBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<DetailsController>(() => DetailsController());
  }
}
