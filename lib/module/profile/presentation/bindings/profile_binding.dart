import 'package:get/get.dart';
import '../../data/datasources/profile_remote_data_source.dart';
import '../../data/repositories/profile_repository_impl.dart';
import '../../domain/repositories/profile_repository.dart';
import '../../domain/usecases/profile_usecases.dart';
import '../controllers/profile_controller.dart';

class ProfileBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<ProfileRemoteDataSource>(() => ProfileRemoteDataSourceImpl());
    Get.lazyPut<ProfileRepository>(() => ProfileRepositoryImpl(remoteDataSource: Get.find<ProfileRemoteDataSource>()));

    Get.lazyPut<UploadProfileImageUseCase>(() => UploadProfileImageUseCase(Get.find<ProfileRepository>()));
    Get.lazyPut<LogoutUseCase>(() => LogoutUseCase(Get.find<ProfileRepository>()));
    Get.lazyPut<DeleteAccountUseCase>(() => DeleteAccountUseCase(Get.find<ProfileRepository>()));

    Get.lazyPut<ProfileController>(() => ProfileController(
          Get.find<UploadProfileImageUseCase>(),
          Get.find<LogoutUseCase>(),
          Get.find<DeleteAccountUseCase>(),
        ));
  }
}
