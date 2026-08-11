import 'package:get/get.dart';
import '../../data/datasources/auth_remote_data_source.dart';
import '../../data/repositories/auth_repository_impl.dart';
import '../../domain/repositories/auth_repository.dart';
import '../../domain/usecases/login_usecase.dart';
import '../../domain/usecases/signup_usecase.dart';
import '../../domain/usecases/google_login_usecase.dart';
import '../../domain/usecases/reset_password_usecase.dart';
import '../../domain/usecases/save_user_usecase.dart';
import '../../domain/usecases/get_user_usecase.dart';
import '../controllers/login_controller.dart';
import '../controllers/signup_controller.dart';
import '../controllers/forgot_controller.dart';

class AuthBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<AuthRemoteDataSource>(() => AuthRemoteDataSourceImpl());
    Get.lazyPut<AuthRepository>(() => AuthRepositoryImpl(remoteDataSource: Get.find<AuthRemoteDataSource>()));

    Get.lazyPut<LoginUseCase>(() => LoginUseCase(Get.find<AuthRepository>()));
    Get.lazyPut<SignUpUseCase>(() => SignUpUseCase(Get.find<AuthRepository>()));
    Get.lazyPut<GoogleLoginUseCase>(() => GoogleLoginUseCase(Get.find<AuthRepository>()));
    Get.lazyPut<ResetPasswordUseCase>(() => ResetPasswordUseCase(Get.find<AuthRepository>()));
    Get.lazyPut<SaveUserUseCase>(() => SaveUserUseCase(Get.find<AuthRepository>()));
    Get.lazyPut<GetUserUseCase>(() => GetUserUseCase(Get.find<AuthRepository>()));

    Get.lazyPut<LoginController>(() => LoginController(
          Get.find<LoginUseCase>(),
          Get.find<GoogleLoginUseCase>(),
          Get.find<SaveUserUseCase>(),
          Get.find<GetUserUseCase>(),
        ));
    Get.lazyPut<SignupController>(() => SignupController(
          Get.find<SignUpUseCase>(),
          Get.find<GoogleLoginUseCase>(),
          Get.find<SaveUserUseCase>(),
        ));
    Get.lazyPut<ForgotController>(() => ForgotController(
          Get.find<ResetPasswordUseCase>(),
        ));
  }
}
