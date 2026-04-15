class OrderEntity {
  final String id;
  final String orderNumber;
  final String status;
  final String totalPrice;
  final String packageName;
  final String createdAt;
  final String? paymentMethod;
  final String? paymentStatus;
  final String orderType;

  const OrderEntity({
    required this.id,
    required this.orderNumber,
    required this.status,
    required this.totalPrice,
    required this.packageName,
    required this.createdAt,
    required this.orderType,
    this.paymentMethod,
    this.paymentStatus,
  });
}
