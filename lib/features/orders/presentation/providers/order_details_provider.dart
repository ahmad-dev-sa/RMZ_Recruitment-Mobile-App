import 'dart:io';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../booking/domain/entities/order_details_entity.dart';
import 'orders_provider.dart';

// Auto-fetches order details using the repository when watched
final orderDetailsProvider = FutureProvider.autoDispose.family<OrderDetailsEntity, String>((ref, orderId) async {
  final repository = ref.watch(bookingRepositoryProvider);
  return repository.getOrderDetails(orderId);
});

// Provides actions to update visa or upload doc without exposing whole state logic
class OrderDetailsNotifier extends StateNotifier<AsyncValue<void>> {
  final Ref _ref;

  OrderDetailsNotifier(this._ref) : super(const AsyncData(null));

  Future<void> updateVisaInfo(String orderId, String visaNumber, String expiryDate) async {
    state = const AsyncLoading();
    try {
      final repository = _ref.read(bookingRepositoryProvider);
      await repository.updateVisaInfo(orderId, visaNumber, expiryDate);
      state = const AsyncData(null);
      // Invalidate the provider so it re-fetches the updated data
      _ref.invalidate(orderDetailsProvider(orderId));
    } catch (e, st) {
      state = AsyncError(e, st);
    }
  }

  Future<void> uploadDocument(String orderId, File file, [String? title]) async {
    state = const AsyncLoading();
    try {
      final repository = _ref.read(bookingRepositoryProvider);
      await repository.uploadOrderDocument(orderId, file, title);
      state = const AsyncData(null);
      // Invalidate the provider so it re-fetches the updated doc list
      _ref.invalidate(orderDetailsProvider(orderId));
    } catch (e, st) {
      state = AsyncError(e, st);
    }
  }

  Future<void> deleteDocument(String orderId, String documentId) async {
    state = const AsyncLoading();
    try {
      final repository = _ref.read(bookingRepositoryProvider);
      await repository.deleteOrderDocument(documentId);
      state = const AsyncData(null);
      // Invalidate the provider so it re-fetches the updated doc list
      _ref.invalidate(orderDetailsProvider(orderId));
    } catch (e, st) {
      state = AsyncError(e, st);
    }
  }

  Future<void> uploadContract(String orderId, File file) async {
    state = const AsyncLoading();
    try {
      final repository = _ref.read(bookingRepositoryProvider);
      await repository.uploadContract(orderId, file);
      state = const AsyncData(null);
      _ref.invalidate(orderDetailsProvider(orderId));
    } catch (e, st) {
      state = AsyncError(e, st);
    }
  }

  Future<void> renewContract(String orderId) async {
    state = const AsyncLoading();
    try {
      final repository = _ref.read(bookingRepositoryProvider);
      await repository.renewContract(orderId);
      state = const AsyncData(null);
      _ref.invalidate(orderDetailsProvider(orderId));
    } catch (e, st) {
      state = AsyncError(e, st);
    }
  }

  Future<void> cancelContract(String orderId) async {
    state = const AsyncLoading();
    try {
      final repository = _ref.read(bookingRepositoryProvider);
      await repository.cancelContract(orderId);
      state = const AsyncData(null);
      _ref.invalidate(orderDetailsProvider(orderId));
    } catch (e, st) {
      state = AsyncError(e, st);
    }
  }

  Future<void> refundContract(String orderId) async {
    state = const AsyncLoading();
    try {
      final repository = _ref.read(bookingRepositoryProvider);
      await repository.refundContract(orderId);
      state = const AsyncData(null);
      _ref.invalidate(orderDetailsProvider(orderId));
    } catch (e, st) {
      state = AsyncError(e, st);
    }
  }

  Future<void> hireCandidate(String orderId, String candidateId) async {
    state = const AsyncLoading();
    try {
      final repository = _ref.read(bookingRepositoryProvider);
      await repository.hireCandidate(orderId, candidateId);
      state = const AsyncData(null);
      // Invalidate the provider so it re-fetches the updated data
      _ref.invalidate(orderDetailsProvider(orderId));
    } catch (e, st) {
      state = AsyncError(e, st);
    }
  }

  Future<void> submitCustomerRequest(String orderId, String type, {String? details, String? requestedDate}) async {
    state = const AsyncLoading();
    try {
      final repository = _ref.read(bookingRepositoryProvider);
      await repository.submitCustomerRequest(orderId, type, details: details, requestedDate: requestedDate);
      state = const AsyncData(null);
      _ref.invalidate(orderDetailsProvider(orderId));
    } catch (e, st) {
      state = AsyncError(e, st);
    }
  }

  Future<void> submitOrderReview(String orderId, int serviceRating, int workerRating, String? comment) async {
    state = const AsyncLoading();
    try {
      final repository = _ref.read(bookingRepositoryProvider);
      await repository.submitOrderReview(
        orderId: orderId,
        serviceRating: serviceRating,
        workerRating: workerRating,
        comment: comment,
      );
      state = const AsyncData(null);
      _ref.invalidate(orderDetailsProvider(orderId));
    } catch (e, st) {
      state = AsyncError(e, st);
    }
  }
}

final orderDetailsActionProvider = StateNotifierProvider<OrderDetailsNotifier, AsyncValue<void>>((ref) {
  return OrderDetailsNotifier(ref);
});