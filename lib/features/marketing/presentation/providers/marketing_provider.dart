import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/network/dio_client.dart';
import '../../domain/entities/banner_entity.dart';
import '../../domain/repositories/marketing_repository.dart';
import '../../data/datasources/marketing_remote_data_source.dart';
import '../../data/repositories/marketing_repository_impl.dart';
import '../../../auth/presentation/providers/auth_provider.dart';

// Remote Data Source Provider
final marketingRemoteDataSourceProvider = Provider<MarketingRemoteDataSource>((ref) {
  final dioClient = ref.watch(dioClientProvider);
  return MarketingRemoteDataSourceImpl(dioClient);
});

// Repository Provider
final marketingRepositoryProvider = Provider<MarketingRepository>((ref) {
  final remoteDataSource = ref.watch(marketingRemoteDataSourceProvider);
  return MarketingRepositoryImpl(remoteDataSource: remoteDataSource);
});

// FutureProvider for Home Banners specifically
final homeBannersProvider = FutureProvider.autoDispose<List<BannerEntity>>((ref) async {
  final repository = ref.watch(marketingRepositoryProvider);
  // Filtering by 'home' to match Django backend location choices
  return repository.getBanners(location: 'home');
});

// FutureProvider for All Banners (Offers)
final allBannersProvider = FutureProvider.autoDispose<List<BannerEntity>>((ref) async {
  final repository = ref.watch(marketingRepositoryProvider);
  return repository.getBanners();
});
