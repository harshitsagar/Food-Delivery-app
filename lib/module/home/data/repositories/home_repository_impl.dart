import 'package:cloud_firestore/cloud_firestore.dart';
import '../../domain/repositories/home_repository.dart';
import '../datasources/home_remote_data_source.dart';

class HomeRepositoryImpl implements HomeRepository {
  final HomeRemoteDataSource remoteDataSource;

  HomeRepositoryImpl({required this.remoteDataSource});

  @override
  Future<Stream<QuerySnapshot>> getFoodItems(String category) {
    return remoteDataSource.getFoodItems(category);
  }
}
