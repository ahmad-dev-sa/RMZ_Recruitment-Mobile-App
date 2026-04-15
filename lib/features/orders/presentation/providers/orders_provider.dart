import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/network/api_client.dart';
import '../../../booking/domain/entities/order_entity.dart';
import '../../../booking/domain/repositories/booking_repository.dart';
import '../../../booking/data/repositories/booking_repository_impl.dart';

final apiClientProvider = Provider<ApiClient>((ref) => ApiClient());

final bookingRepositoryProvider = Provider<BookingRepository>((ref) {
  final apiClient = ref.watch(apiClientProvider);
  return BookingRepositoryImpl(apiClient: apiClient);
});

// Holds the currently selected filter: 'all', 'recruitment', 'resident', 'hourly'
final ordersFilterProvider = StateProvider<String>((ref) => 'all');

// Fetches list of orders based on the current filter
final ordersProvider = FutureProvider.autoDispose<List<OrderEntity>>((ref) async {
  final filter = ref.watch(ordersFilterProvider);
  final repository = ref.watch(bookingRepositoryProvider);
  
  return repository.getOrders(category: filter);
});
