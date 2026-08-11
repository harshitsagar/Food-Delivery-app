import '../../domain/entities/cart_item_entity.dart';

class CartItemModel extends CartItemEntity {
  CartItemModel({
    required super.id,
    required super.name,
    required super.quantity,
    required super.total,
    required super.image,
  });

  factory CartItemModel.fromFirestore(Map<String, dynamic> json, String id) {
    return CartItemModel(
      id: id,
      name: json['Name'] ?? '',
      quantity: json['Quantity'] ?? '1',
      total: json['Total']?.toString() ?? '0',
      image: json['Image'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'Name': name,
      'Quantity': quantity,
      'Total': total,
      'Image': image,
    };
  }
}
