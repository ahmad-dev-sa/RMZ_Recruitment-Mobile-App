import 'dart:io';
import 'package:dio/dio.dart';
import '../../../../core/network/api_client.dart';
import '../../domain/entities/order_entity.dart';
import '../../domain/entities/order_details_entity.dart';
import '../../domain/repositories/booking_repository.dart';
import '../models/order_model.dart';
import '../models/order_details_model.dart';

class BookingRepositoryImpl implements BookingRepository {
  final ApiClient apiClient;

  BookingRepositoryImpl({required this.apiClient});

  @override
  Future<OrderEntity> createRecruitmentOrder(Map<String, dynamic> orderData) async {
    try {
      final response = await apiClient.dio.post('orders/', data: orderData);
      
      // Handle Django Rest Framework response structure
      Map<String, dynamic> responseData;
      if (response.data is Map && response.data.containsKey('data')) {
        responseData = response.data['data'];
      } else {
        responseData = response.data;
      }

      return OrderModel.fromJson(responseData);
    } on DioException catch (e) {
      throw Exception('Failed to create order: ${e.response?.data ?? e.message}');
    } catch (e) {
      throw Exception('Failed to create order');
    }
  }

  @override
  Future<List<OrderEntity>> getOrders({String? category}) async {
    try {
      final queryParams = <String, dynamic>{};
      if (category != null && category.isNotEmpty && category != 'all') {
        if (int.tryParse(category) != null) {
          queryParams['category_id'] = category;
        } else {
          queryParams['order_type'] = category;
        }
      }
      
      final response = await apiClient.dio.get('orders/', queryParameters: queryParams);
      
      List<dynamic> results = [];
      if (response.data is Map) {
        if (response.data.containsKey('data')) {
          final innerData = response.data['data'];
          if (innerData is List) results = innerData;
          else if (innerData is Map && innerData.containsKey('results')) results = innerData['results'];
        } else if (response.data.containsKey('results')) {
          results = response.data['results'];
        }
      } else if (response.data is List) {
        results = response.data;
      }
      
      return results.map((json) => OrderModel.fromJson(json)).toList();
    } on DioException catch (e) {
      throw Exception('Failed to fetch orders: ${e.response?.data ?? e.message}');
    } catch (e) {
      throw Exception('Failed to fetch orders: $e');
    }
  }

  @override
  Future<OrderDetailsEntity> getOrderDetails(String orderId) async {
    try {
      final response = await apiClient.dio.get('orders/$orderId/');
      if (response.statusCode == 200) {
        return OrderDetailsModel.fromJson(response.data);
      } else {
        throw Exception('Failed to load order details');
      }
    } on DioException catch (e) {
      throw Exception('Failed to load order details: \${e.message}');
    } catch (e) {
      throw Exception('Failed to load order details: $e');
    }
  }

  @override
  Future<void> updateVisaInfo(String orderId, String visaNumber, String expiryDate) async {
    try {
      final response = await apiClient.dio.patch(
        'orders/$orderId/update-visa/',
        data: {
          'visa_number': visaNumber,
          'visa_expiry_date': expiryDate,
        },
      );
      if (response.statusCode != 200 && response.statusCode != 201) {
        throw Exception('Failed to update visa info');
      }
    } on DioException catch (e) {
      throw Exception('Failed to update visa info: \${e.response?.data ?? e.message}');
    } catch (e) {
      throw Exception('Failed to update visa info: $e');
    }
  }

  @override
  Future<void> uploadOrderDocument(String orderId, File file, [String? title]) async {
    try {
      String fileName = file.path.split('/').last;
      FormData formData = FormData.fromMap({
        "order": orderId,
        "document_type": "other",
        if (title != null && title.isNotEmpty) "description": title,
        "file": await MultipartFile.fromFile(file.path, filename: fileName),
      });

      final response = await apiClient.dio.post(
        'orders/documents/',
        data: formData,
      );
      if (response.statusCode != 200 && response.statusCode != 201) {
        throw Exception('Failed to upload document');
      }
    } on DioException catch (e) {
      throw Exception('Failed to upload document: \${e.response?.data ?? e.message}');
    } catch (e) {
      throw Exception('Failed to upload document: $e');
    }
  }

  @override
  Future<void> deleteOrderDocument(String documentId) async {
    try {
      final response = await apiClient.dio.delete('orders/documents/$documentId/');
      if (response.statusCode != 200 && response.statusCode != 204) {
        throw Exception('Failed to delete document');
      }
    } on DioException catch (e) {
      throw Exception('Failed to delete document: \${e.response?.data ?? e.message}');
    } catch (e) {
      throw Exception('Failed to delete document: $e');
    }
  }

  @override
  Future<void> uploadContract(String orderId, File file) async {
    try {
      String fileName = file.path.split('/').last;
      FormData formData = FormData.fromMap({
        "file": await MultipartFile.fromFile(file.path, filename: fileName),
      });

      final response = await apiClient.dio.post(
        'orders/$orderId/upload-contract/',
        data: formData,
      );
      if (response.statusCode != 200 && response.statusCode != 201) {
        throw Exception('Failed to upload contract');
      }
    } on DioException catch (e) {
      throw Exception('Failed to upload contract: \${e.response?.data ?? e.message}');
    } catch (e) {
      throw Exception('Failed to upload contract: $e');
    }
  }

  @override
  Future<void> renewContract(String orderId) async {
    try {
      final response = await apiClient.dio.post('orders/$orderId/contract/renew/');
      if (response.statusCode != 200 && response.statusCode != 201) throw Exception('Failed to renew contract');
    } on DioException catch (e) {
      throw Exception('Failed to renew contract: \${e.response?.data ?? e.message}');
    } catch (e) {
      throw Exception('Failed to renew contract: $e');
    }
  }

  @override
  Future<void> cancelContract(String orderId) async {
    try {
      final response = await apiClient.dio.post('orders/$orderId/contract/cancel/');
      if (response.statusCode != 200 && response.statusCode != 201) throw Exception('Failed to cancel contract');
    } on DioException catch (e) {
      throw Exception('Failed to cancel contract: \${e.response?.data ?? e.message}');
    } catch (e) {
      throw Exception('Failed to cancel contract: $e');
    }
  }

  @override
  Future<void> refundContract(String orderId) async {
    try {
      final response = await apiClient.dio.post('orders/$orderId/contract/refund/');
      if (response.statusCode != 200 && response.statusCode != 201) throw Exception('Failed to request refund');
    } on DioException catch (e) {
      throw Exception('Failed to request refund: \${e.response?.data ?? e.message}');
    } catch (e) {
      throw Exception('Failed to request refund: $e');
    }
  }

  @override
  Future<void> hireCandidate(String orderId, String candidateId) async {
    try {
      final response = await apiClient.dio.post(
        'orders/$orderId/hire-candidate/',
        data: {
          'candidate_id': candidateId,
        },
      );
      if (response.statusCode != 200 && response.statusCode != 201) {
        throw Exception('Failed to hire candidate');
      }
    } on DioException catch (e) {
      throw Exception('Failed to hire candidate: \${e.response?.data ?? e.message}');
    } catch (e) {
      throw Exception('Failed to hire candidate: $e');
    }
  }
  @override
  Future<void> submitCustomerRequest(String orderId, String type, {String? details, String? requestedDate}) async {
    try {
      final Map<String, dynamic> data = {
        'request_type': type,
      };
      if (details != null && details.isNotEmpty) {
        data['details'] = details;
      }
      if (requestedDate != null && requestedDate.isNotEmpty) {
        data['requested_date'] = requestedDate;
      }

      final response = await apiClient.dio.post(
        'orders/$orderId/requests/',
        data: data,
      );
      
      if (response.statusCode != 200 && response.statusCode != 201) {
        throw Exception('Failed to submit request');
      }
    } on DioException catch (e) {
      final errorMsg = e.response?.data is Map 
        ? (e.response?.data['message'] ?? e.response?.data['detail'] ?? e.message)
        : e.message;
      throw Exception(errorMsg);
    } catch (e) {
      throw Exception('Failed to submit request: $e');
    }
  }

  @override
  Future<void> submitOrderReview({
    required String orderId,
    required int serviceRating,
    required int workerRating,
    String? comment,
  }) async {
    try {
      final response = await apiClient.dio.post(
        'orders/$orderId/submit-review/',
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
}
