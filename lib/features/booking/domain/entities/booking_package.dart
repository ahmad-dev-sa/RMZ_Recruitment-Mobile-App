class BookingPackage {
  final String id;
  final String nameAr;
  final String nameEn;
  final String price;
  final String monthlySalary;
  final bool isTaxIncluded;

  const BookingPackage({
    required this.id,
    required this.nameAr,
    required this.nameEn,
    required this.price,
    required this.monthlySalary,
    this.isTaxIncluded = true,
  });
}
