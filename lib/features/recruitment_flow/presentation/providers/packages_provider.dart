import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/network/api_client.dart';
import '../../../booking/data/models/booking_package_model.dart';
import '../../../booking/domain/entities/booking_package.dart';

final apiClientProvider = Provider<ApiClient>((ref) => ApiClient());

final servicePackagesProvider = FutureProvider.family<List<BookingPackage>, int>((ref, serviceId) async {
  final apiClient = ref.read(apiClientProvider);
  
  try {
    final response = await apiClient.dio.get('packages/', queryParameters: {
      'service': serviceId,
    });
    
    final data = response.data;
    List<dynamic> results = [];
    if (data is Map) {
      if (data.containsKey('data')) {
        final innerData = data['data'];
        if (innerData is List) {
          results = innerData;
        } else if (innerData is Map && innerData.containsKey('results')) {
          results = innerData['results'] as List<dynamic>;
        }
      } else if (data.containsKey('results')) {
        results = data['results'] as List<dynamic>;
      }
    } else if (data is List) {
      results = data;
    }
    
    return results.map((json) => BookingPackageModel.fromJson(json)).toList();
  } catch (e) {
    throw Exception('Failed to fetch packages: $e');
  }
});

final categoryPackagesProvider = FutureProvider.family<List<BookingPackage>, int>((ref, categoryId) async {
  final apiClient = ref.read(apiClientProvider);
  
  try {
    final response = await apiClient.dio.get('services/', queryParameters: {
      'category': categoryId,
    });
    
    final data = response.data;
    List<dynamic> services = [];
    if (data is Map) {
      if (data.containsKey('data')) {
        final innerData = data['data'];
        if (innerData is List) {
          services = innerData;
        } else if (innerData is Map && innerData.containsKey('results')) {
          services = innerData['results'] as List<dynamic>;
        }
      } else if (data.containsKey('results')) {
        services = data['results'] as List<dynamic>;
      }
    } else if (data is List) {
      services = data;
    }
    
    List<BookingPackage> packages = [];
    for (var serviceJson in services) {
      if (serviceJson['packages'] is List) {
        for (var packageJson in serviceJson['packages']) {
          // ensure child package knows its parent service ID
          packageJson['service_id'] = serviceJson['id'];
          packages.add(BookingPackageModel.fromJson(packageJson));
        }
      }
    }
    
    return packages;
  } catch (e) {
    throw Exception('Failed to fetch category packages: $e');
  }
});
