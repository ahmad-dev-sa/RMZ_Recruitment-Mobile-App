import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/network/api_client.dart';
import '../../../booking/domain/entities/order_details_entity.dart';
import '../../../booking/data/models/order_details_model.dart';

final rentalCandidatesProvider = FutureProvider<List<CandidateEntity>>((ref) async {
  final apiClient = ApiClient();
  try {
    final response = await apiClient.dio.get('workers/', queryParameters: {
      'worker_type': 'resident',
    });
    
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
    
    return results.map((json) => CandidateModel.fromJson(json)).toList();
  } catch (e) {
    throw Exception('Failed to fetch rental candidates: $e');
  }
});
