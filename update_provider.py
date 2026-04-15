import re

with open('../mobile_app/lib/features/orders/presentation/providers/order_details_provider.dart', 'r') as f:
    content = f.read()

impl_code = """
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

if "submitOrderReview" not in content:
    content = content.rstrip()
    if content.endswith('}'):
        content = content[:-1] + impl_code + "}\n"

with open('../mobile_app/lib/features/orders/presentation/providers/order_details_provider.dart', 'w') as f:
    f.write(content)
