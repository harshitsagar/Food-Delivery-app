import '../../domain/entities/user_entity.dart';

class UserModel extends UserEntity {
  UserModel({
    required super.id,
    required super.name,
    required super.email,
    required super.wallet,
    required super.loginType,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['Id'] ?? '',
      name: json['Name'] ?? '',
      email: json['Email'] ?? '',
      wallet: json['Wallet'] ?? '0',
      loginType: json['login'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'Id': id,
      'Name': name,
      'Email': email,
      'Wallet': wallet,
      'login': loginType,
    };
  }
}
