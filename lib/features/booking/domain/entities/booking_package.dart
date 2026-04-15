class BookingPackage {
  final String id;
  final String nameAr;
  final String nameEn;
  final String price;
  final String monthlySalary;
  final String descriptionAr;
  final String descriptionEn;
  final int serviceId;
  final bool isTaxIncluded;
  final int maxWorkers;
  final List<Map<String, dynamic>> nationalities;
  final int durationValue;
  final String durationUnit;
  final String totalAmount;
  final String taxAmount;
  final String shiftType;
  final int visitCount;

  const BookingPackage({
    required this.id,
    required this.nameAr,
    required this.nameEn,
    required this.price,
    required this.monthlySalary,
    this.descriptionAr = '',
    this.descriptionEn = '',
    this.serviceId = 0,
    this.isTaxIncluded = true,
    this.maxWorkers = 1,
    this.nationalities = const [],
    this.durationValue = 1,
    this.durationUnit = 'day',
    this.totalAmount = '0',
    this.taxAmount = '0',
    this.shiftType = 'morning',
    this.visitCount = 1,
  });
}
