import '../../domain/entities/food_item_entity.dart';

class FoodItemModel extends FoodItemEntity {
  FoodItemModel({
    required super.id,
    required super.name,
    required super.detail,
    required super.image,
    required super.price,
  });

  factory FoodItemModel.fromFirestore(Map<String, dynamic> json, String id) {
    return FoodItemModel(
      id: id,
      name: json['Name'] ?? '',
      detail: json['Detail'] ?? '',
      image: json['Image'] ?? '',
      price: json['Price']?.toString() ?? '0',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'Name': name,
      'Detail': detail,
      'Image': image,
      'Price': price,
    };
  }
}
