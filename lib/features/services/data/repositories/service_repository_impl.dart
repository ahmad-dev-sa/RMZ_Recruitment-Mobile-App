import '../../domain/entities/category_entity.dart';
import '../../domain/entities/service_entity.dart';
import '../../domain/repositories/service_repository.dart';
import '../datasources/service_remote_data_source.dart';

class ServiceRepositoryImpl implements ServiceRepository {
  final ServiceRemoteDataSource remoteDataSource;

  ServiceRepositoryImpl({required this.remoteDataSource});

  @override
  Future<List<CategoryEntity>> getCategories() async {
    return await remoteDataSource.getCategories();
  }

  @override
  Future<List<ServiceEntity>> getServices({int? categoryId}) async {
    return await remoteDataSource.getServices(categoryId: categoryId);
  }
}
