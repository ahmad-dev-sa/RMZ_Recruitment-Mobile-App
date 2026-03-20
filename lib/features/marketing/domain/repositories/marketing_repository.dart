import '../entities/banner_entity.dart';

abstract class MarketingRepository {
  /// Fetches a list of active banners from the backend.
  /// 
  /// Optionally, you can pass a [location] filter (e.g., 'home', 'offers').
  Future<List<BannerEntity>> getBanners({String? location});
}
