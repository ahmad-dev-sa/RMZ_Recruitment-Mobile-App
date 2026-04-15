import '../../domain/entities/order_entity.dart';

class OrderModel extends OrderEntity {
  const OrderModel({
    required super.id,
    required super.orderNumber,
    required super.status,
    required super.totalPrice,
    required super.packageName,
    required super.createdAt,
    required super.orderType,
    super.paymentMethod,
    super.paymentStatus,
  });

  factory OrderModel.fromJson(Map<String, dynamic> json) {
    return OrderModel(
      id: json['id']?.toString() ?? '',
      orderNumber: json['order_number']?.toString() ?? json['id']?.toString() ?? '',
      status: json['status'] ?? 'جاري العمل',
      totalPrice: json['final_amount']?.toString() ?? json['total_amount']?.toString() ?? json['total_price']?.toString() ?? '',
      packageName: json['package_name'] ?? json['service_name'] ?? 'باقة استقدام',
      createdAt: json['created_at'] ?? '',
      orderType: json['order_type'] ?? 'recruitment',
      paymentMethod: json['payment_method'],
      paymentStatus: json['payment_status'],
    );
  }
}
