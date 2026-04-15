import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/network/api_client.dart';

final apiClientProvider = Provider<ApiClient>((ref) => ApiClient());

final siteSettingsProvider = FutureProvider<Map<String, dynamic>>((ref) async {
  final apiClient = ref.read(apiClientProvider);
  try {
    final response = await apiClient.dio.get('core/site-settings/');
    
    final responseData = response.data;
    if (responseData is Map<String, dynamic> && responseData.containsKey('data')) {
      return responseData['data'] as Map<String, dynamic>;
    } else if (responseData is Map<String, dynamic>) {
      return responseData;
    }
    
    return {};
  } catch (e) {
    throw Exception('Failed to fetch site settings: $e');
  }
});
