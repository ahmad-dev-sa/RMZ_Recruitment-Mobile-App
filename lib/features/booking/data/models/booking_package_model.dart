import '../../domain/entities/booking_package.dart';

class BookingPackageModel extends BookingPackage {
  const BookingPackageModel({
    required super.id,
    required super.nameAr,
    required super.nameEn,
    required super.price,
    required super.monthlySalary,
    super.descriptionAr = '',
    super.descriptionEn = '',
    super.serviceId = 0,
    super.maxWorkers = 1,
    super.nationalities = const [],
    super.durationValue = 1,
    super.durationUnit = 'day',
    super.totalAmount = '0',
    super.taxAmount = '0',
    super.shiftType = 'morning',
    super.visitCount = 1,
  });

  factory BookingPackageModel.fromJson(Map<String, dynamic> json) {
    return BookingPackageModel(
      id: json['id'].toString(),
      nameAr: json['name_ar'] ?? json['name'] ?? '',
      nameEn: json['name_en'] ?? json['name'] ?? '',
      descriptionAr: json['description_ar'] ?? '',
      descriptionEn: json['description_en'] ?? '',
      price: json['final_price']?.toString() ?? json['total_amount']?.toString() ?? json['price']?.toString() ?? '0',
      monthlySalary: json['worker_salary']?.toString() ?? json['monthly_salary']?.toString() ?? '0',
      serviceId: json['service_id'] ?? json['service'] ?? 0,
      maxWorkers: json['max_workers'] ?? 1,
      nationalities: (json['nationalities'] as List<dynamic>?)
          ?.map((e) => e as Map<String, dynamic>)
          .toList() ?? [],
      durationValue: json['duration_value'] ?? 1,
      durationUnit: json['duration_unit'] ?? 'day',
      totalAmount: json['total_amount']?.toString() ?? '0',
      taxAmount: json['tax_amount']?.toString() ?? '0',
      shiftType: json['shift_type'] ?? 'morning',
      visitCount: json['visit_count'] ?? 1,
    );
  }
}
