import '../entities/order_entity.dart';
import '../entities/order_details_entity.dart';
import 'dart:io';

abstract class BookingRepository {
  Future<OrderEntity> createRecruitmentOrder(Map<String, dynamic> orderData);
  Future<List<OrderEntity>> getOrders({String? category});
  
  // Order Details
  Future<OrderDetailsEntity> getOrderDetails(String orderId);
  Future<void> updateVisaInfo(String orderId, String visaNumber, String expiryDate);
  Future<void> uploadOrderDocument(String orderId, File file, [String? title]);
  Future<void> deleteOrderDocument(String documentId);
  Future<void> uploadContract(String orderId, File file);
  Future<void> renewContract(String orderId);
  Future<void> cancelContract(String orderId);
  Future<void> refundContract(String orderId);
  Future<void> hireCandidate(String orderId, String candidateId);

  Future<void> submitCustomerRequest(String orderId, String type, {String? details, String? requestedDate});
  
  Future<void> submitOrderReview({
    required String orderId,
    required int serviceRating,
    required int workerRating,
    String? comment,
  });
}
