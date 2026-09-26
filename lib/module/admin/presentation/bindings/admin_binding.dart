import 'package:get/get.dart';
import '../../data/datasources/admin_remote_data_source.dart';
import '../../data/repositories/admin_repository_impl.dart';
import '../../domain/repositories/admin_repository.dart';
import '../../domain/usecases/admin_usecases.dart';
import '../controllers/admin_controller.dart';

class AdminBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<AdminRemoteDataSource>(() => AdminRemoteDataSourceImpl());
    Get.lazyPut<AdminRepository>(() => AdminRepositoryImpl(remoteDataSource: Get.find<AdminRemoteDataSource>()));
    Get.lazyPut<AdminLoginUseCase>(() => AdminLoginUseCase(Get.find<AdminRepository>()));
    Get.lazyPut<AddFoodItemUseCase>(() => AddFoodItemUseCase(Get.find<AdminRepository>()));
    Get.lazyPut<UploadFoodImageUseCase>(() => UploadFoodImageUseCase(Get.find<AdminRepository>()));

    Get.lazyPut<AdminController>(() => AdminController(
          Get.find<AdminLoginUseCase>(),
          Get.find<AddFoodItemUseCase>(),
          Get.find<UploadFoodImageUseCase>(),
        ));
  }
}
