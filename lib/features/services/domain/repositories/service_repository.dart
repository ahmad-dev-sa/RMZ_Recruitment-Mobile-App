import '../entities/category_entity.dart';
import '../entities/service_entity.dart';

abstract class ServiceRepository {
  Future<List<CategoryEntity>> getCategories();
  Future<List<ServiceEntity>> getServices({int? categoryId});
}
