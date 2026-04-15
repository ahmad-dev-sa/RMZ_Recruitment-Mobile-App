import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/network/api_client.dart';
import '../../domain/entities/branch_entity.dart';

final branchesProvider = FutureProvider<List<BranchEntity>>((ref) async {
  final apiClient = ApiClient();
  try {
    final response = await apiClient.dio.get('core/branches/');
    
    final data = response.data;
    List<dynamic> results = [];
    if (data is Map) {
      if (data.containsKey('results')) {
        results = data['results'] as List<dynamic>;
      } else if (data.containsKey('data')) {
        final innerData = data['data'];
        if (innerData is List) {
          results = innerData;
        } else if (innerData is Map && innerData.containsKey('results')) {
          results = innerData['results'] as List<dynamic>;
        }
      }
    } else if (data is List) {
      results = data;
    }
    
    return results.map((json) => BranchEntity.fromJson(json)).toList();
  } catch (e) {
    throw Exception('Failed to fetch branches: $e');
  }
});
