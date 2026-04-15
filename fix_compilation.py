import re

# 1. Fix order_review_card.dart (ConsumerConsumerState to ConsumerState)
with open('../mobile_app/lib/features/orders/presentation/widgets/details/order_review_card.dart', 'r') as f:
    review_card = f.read()
    
if "ConsumerConsumerState" in review_card:
    review_card = review_card.replace("ConsumerConsumerState", "ConsumerState")
    
with open('../mobile_app/lib/features/orders/presentation/widgets/details/order_review_card.dart', 'w') as f:
    f.write(review_card)


# 2. Fix booking_repository_impl.dart
with open('../mobile_app/lib/features/booking/data/repositories/booking_repository_impl.dart', 'r') as f:
    repo_impl = f.read()

bad_post = "final response = await dioClient.post(\n        '${ApiConstants.orders}$orderId/add_review/',"
good_post = "final response = await apiClient.dio.post(\n        'orders/$orderId/add_review/',"

repo_impl = repo_impl.replace(bad_post, good_post)

with open('../mobile_app/lib/features/booking/data/repositories/booking_repository_impl.dart', 'w') as f:
    f.write(repo_impl)


# 3. Fix order_details_provider.dart
with open('../mobile_app/lib/features/orders/presentation/providers/order_details_provider.dart', 'r') as f:
    provider = f.read()
    
# Remove the wrongly appended submitOrderReview at the bottom if anything
wrong_block = """
  Future<void> submitOrderReview(String orderId, int serviceRating, int workerRating, String? comment) async {
    try {
      await _repository.submitOrderReview(
        orderId: orderId,
        serviceRating: serviceRating,
        workerRating: workerRating,
        comment: comment,
      );
      // Optional: invalidate if the API updates the local data with the new review!
      ref.invalidate(orderDetailsProvider(orderId));
    } catch (e) {
      rethrow;
    }
  }
"""

if wrong_block in provider:
    provider = provider.replace(wrong_block, "")

# Ensure the correct one is inside OrderDetailsNotifier
correct_block = """
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
"""

if "submitOrderReview" not in provider:
    provider = provider.replace("}\n\nfinal orderDetailsActionProvider", correct_block + "\nfinal orderDetailsActionProvider")

with open('../mobile_app/lib/features/orders/presentation/providers/order_details_provider.dart', 'w') as f:
    f.write(provider)
