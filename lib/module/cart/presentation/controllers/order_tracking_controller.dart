import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';
import '../../domain/usecases/get_order_usecase.dart';

class OrderTrackingController extends GetxController {
  final GetOrderUseCase getOrderUseCase;
  OrderTrackingController(this.getOrderUseCase);

  Rx<Stream<DocumentSnapshot>?> orderStream = Rx<Stream<DocumentSnapshot>?>(null);

  void loadOrder(String orderId) async {
    orderStream.value = await getOrderUseCase.execute(orderId);
  }
}
