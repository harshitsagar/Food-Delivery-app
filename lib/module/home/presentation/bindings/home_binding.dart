import 'package:get/get.dart';
import '../../data/datasources/home_remote_data_source.dart';
import '../../data/repositories/home_repository_impl.dart';
import '../../domain/repositories/home_repository.dart';
import '../../domain/usecases/get_food_items_usecase.dart';
import '../controllers/home_controller.dart';

class HomeBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<HomeRemoteDataSource>(() => HomeRemoteDataSourceImpl());
    Get.lazyPut<HomeRepository>(() => HomeRepositoryImpl(remoteDataSource: Get.find<HomeRemoteDataSource>()));
    Get.lazyPut<GetFoodItemsUseCase>(() => GetFoodItemsUseCase(Get.find<HomeRepository>()));
    Get.lazyPut<HomeController>(() => HomeController(Get.find<GetFoodItemsUseCase>()));
  }
}
