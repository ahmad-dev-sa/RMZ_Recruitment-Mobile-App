import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/network/dio_client.dart';
import '../../../auth/presentation/providers/auth_provider.dart';
import '../../domain/entities/category_entity.dart';
import '../../domain/entities/service_entity.dart';
import '../../domain/repositories/service_repository.dart';
import '../../data/datasources/service_remote_data_source.dart';
import '../../data/repositories/service_repository_impl.dart';

// --- Data Layer Providers ---
final serviceRemoteDataSourceProvider = Provider<ServiceRemoteDataSource>((ref) {
  final dioClient = ref.watch(dioClientProvider);
  return ServiceRemoteDataSourceImpl(dioClient);
});

final serviceRepositoryProvider = Provider<ServiceRepository>((ref) {
  final remoteDataSource = ref.watch(serviceRemoteDataSourceProvider);
  return ServiceRepositoryImpl(remoteDataSource: remoteDataSource);
});

// --- State Providers ---

// FutureProvider for Categories
final categoriesProvider = FutureProvider<List<CategoryEntity>>((ref) async {
  final repository = ref.watch(serviceRepositoryProvider);
  return await repository.getCategories();
});

// StateProvider to track the currently selected Category ID on the Home screen
final selectedCategoryIdProvider = StateProvider<int?>((ref) => null);

// FutureProvider Family for Services (filtered by category if provided)
final servicesProvider = FutureProvider.family<List<ServiceEntity>, int?>((ref, categoryId) async {
  final repository = ref.watch(serviceRepositoryProvider);
  return await repository.getServices(categoryId: categoryId);
});
