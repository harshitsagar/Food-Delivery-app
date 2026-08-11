import 'package:get/get.dart';
import '../../../../module/cart/data/datasources/cart_remote_data_source.dart';
import '../../../../module/cart/data/repositories/cart_repository_impl.dart';
import '../../../../module/cart/domain/repositories/cart_repository.dart';
import '../../../../module/cart/domain/usecases/cart_usecases.dart';
import '../controllers/details_controller.dart';

class DetailsBinding extends Bindings {
  @override
  void dependencies() {
    if (!Get.isRegistered<CartRepository>()) {
      Get.lazyPut<CartRemoteDataSource>(() => CartRemoteDataSourceImpl());
      Get.lazyPut<CartRepository>(() => CartRepositoryImpl(remoteDataSource: Get.find<CartRemoteDataSource>()));
    }
    
    Get.lazyPut<AddToCartUseCase>(() => AddToCartUseCase(Get.find<CartRepository>()));

    Get.lazyPut<DetailsController>(() => DetailsController(Get.find<AddToCartUseCase>()));
  }
}
