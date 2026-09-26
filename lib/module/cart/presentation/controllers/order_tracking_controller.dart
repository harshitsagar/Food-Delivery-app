import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';
import 'package:quick_eats_app/core/services/shared_pref_service.dart';
import '../../domain/usecases/get_order_usecase.dart';

class OrderTrackingController extends GetxController {
  final GetOrderUseCase getOrderUseCase;
  OrderTrackingController(this.getOrderUseCase);

  Rx<Stream<DocumentSnapshot>?> orderStream = Rx<Stream<DocumentSnapshot>?>(null);
  var isNotFound = false.obs;

  void loadOrder(String orderId) async {
    isNotFound.value = false;
    if (orderId.isNotEmpty) {
      orderStream.value = await getOrderUseCase.execute(orderId);
    } else {
      await loadLatestOrder();
    }
  }

  Future<void> loadLatestOrder() async {
    try {
      String? userId = await SharedPreferenceHelper.getUserId();
      if (userId != null && userId.isNotEmpty) {
        var querySnapshot = await FirebaseFirestore.instance
            .collection('orders')
            .where('userId', isEqualTo: userId)
            .orderBy('orderDate', descending: true)
            .limit(1)
            .get();

        if (querySnapshot.docs.isNotEmpty) {
          String latestOrderId = querySnapshot.docs.first.id;
          orderStream.value = await getOrderUseCase.execute(latestOrderId);
          return;
        }
      }
      isNotFound.value = true;
    } catch (e) {
      print("Error loading latest order: $e");
      isNotFound.value = true;
    }
  }
}
