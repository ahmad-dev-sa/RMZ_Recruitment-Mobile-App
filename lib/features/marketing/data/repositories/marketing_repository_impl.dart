import '../../domain/entities/banner_entity.dart';
import '../../domain/repositories/marketing_repository.dart';
import '../datasources/marketing_remote_data_source.dart';

class MarketingRepositoryImpl implements MarketingRepository {
  final MarketingRemoteDataSource remoteDataSource;

  MarketingRepositoryImpl({required this.remoteDataSource});

  @override
  Future<List<BannerEntity>> getBanners({String? location}) async {
    try {
      final bannerModels = await remoteDataSource.getBanners(location: location);
      return bannerModels;
    } catch (e) {
      // Typically, errors from the data source are re-thrown or mapped to domain failures
      rethrow;
    }
  }
}
