import re

with open('../mobile_app/lib/features/booking/data/repositories/booking_repository_impl.dart', 'r') as f:
    content = f.read()

# I am adding the implementation of submitOrderReview to the BookingRepositoryImpl class
impl_code = """
  @override
  Future<void> submitOrderReview({
    required String orderId,
    required int serviceRating,
    required int workerRating,
    String? comment,
  }) async {
    try {
      final response = await dioClient.post(
        '${ApiConstants.orders}$orderId/add_review/',
        data: {
          'rating': serviceRating,
          'worker_rating': workerRating,
          'comment': comment,
        },
      );
      
      if (response.data['success'] != true && response.statusCode != 200 && response.statusCode != 201) {
        throw Exception(response.data['error'] ?? 'حدث خطأ غير متوقع');
      }
    } on DioException catch (e) {
      if (e.response?.data != null && e.response?.data is Map) {
        throw Exception(e.response?.data['error'] ?? 'فشل الاتصال بالخادم. الرجاء المحاولة مرة أخرى.');
      }
      throw Exception('فشل في تقييم الطلب. يرجى التحقق من اتصالك بالإنترنت.');
    } catch (e) {
      throw Exception('حدث خطأ غير متوقع: $e');
    }
  }
"""

# append before the last closing brace of the file
if "submitOrderReview" not in content:
    content = content.rstrip()
    if content.endswith('}'):
        content = content[:-1] + impl_code + "}\n"

with open('../mobile_app/lib/features/booking/data/repositories/booking_repository_impl.dart', 'w') as f:
    f.write(content)
