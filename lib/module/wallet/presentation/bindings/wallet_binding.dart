import 'package:get/get.dart';
import '../../data/datasources/wallet_remote_data_source.dart';
import '../../data/repositories/wallet_repository_impl.dart';
import '../../domain/repositories/wallet_repository.dart';
import '../../domain/usecases/wallet_usecases.dart';
import '../controllers/wallet_controller.dart';

class WalletBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<WalletRemoteDataSource>(() => WalletRemoteDataSourceImpl());
    Get.lazyPut<WalletRepository>(() => WalletRepositoryImpl(remoteDataSource: Get.find<WalletRemoteDataSource>()));
    Get.lazyPut<AddMoneyToWalletUseCase>(() => AddMoneyToWalletUseCase(Get.find<WalletRepository>()));

    Get.lazyPut<WalletController>(() => WalletController(Get.find<AddMoneyToWalletUseCase>()));
  }
}
