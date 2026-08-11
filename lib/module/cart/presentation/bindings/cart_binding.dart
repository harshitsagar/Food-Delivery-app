import 'package:get/get.dart';
import '../../data/datasources/cart_remote_data_source.dart';
import '../../data/repositories/cart_repository_impl.dart';
import '../../domain/repositories/cart_repository.dart';
import '../../domain/usecases/cart_usecases.dart';
import '../../domain/usecases/get_order_usecase.dart';
import '../controllers/cart_controller.dart';
import '../controllers/order_tracking_controller.dart';

class CartBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<CartRemoteDataSource>(() => CartRemoteDataSourceImpl());
    Get.lazyPut<CartRepository>(() => CartRepositoryImpl(remoteDataSource: Get.find<CartRemoteDataSource>()));

    Get.lazyPut<GetCartItemsUseCase>(() => GetCartItemsUseCase(Get.find<CartRepository>()));
    Get.lazyPut<PlaceOrderUseCase>(() => PlaceOrderUseCase(Get.find<CartRepository>()));
    Get.lazyPut<ClearCartUseCase>(() => ClearCartUseCase(Get.find<CartRepository>()));
    Get.lazyPut<UpdateWalletUseCase>(() => UpdateWalletUseCase(Get.find<CartRepository>()));
    Get.lazyPut<GetOrderUseCase>(() => GetOrderUseCase(Get.find<CartRepository>()));

    Get.lazyPut<CartController>(() => CartController(
          Get.find<GetCartItemsUseCase>(),
          Get.find<PlaceOrderUseCase>(),
          Get.find<ClearCartUseCase>(),
          Get.find<UpdateWalletUseCase>(),
        ));

    Get.lazyPut<OrderTrackingController>(() => OrderTrackingController(
          Get.find<GetOrderUseCase>(),
        ));
  }
}
