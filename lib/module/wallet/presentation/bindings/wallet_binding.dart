import 'package:get/get.dart';
import 'package:quick_eats_app/module/wallet/presentation/controllers/wallet_controller.dart';

class WalletBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<WalletController>(() => WalletController());
  }
}
