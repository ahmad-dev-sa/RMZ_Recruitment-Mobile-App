class LocalizedString {
  final String ar;
  final String en;
  const LocalizedString(this.ar, this.en);

  String get(bool isAr) => isAr ? ar : en;
}

class DHPackageModel {
  final String id;
  final LocalizedString title;
  final LocalizedString description;
  final double originalPrice;
  final double discountedPrice;
  final double discountPercentage;
  final bool isMorning;

  const DHPackageModel({
    required this.id,
    required this.title,
    required this.description,
    required this.originalPrice,
    required this.discountedPrice,
    required this.discountPercentage,
    required this.isMorning,
  });
}

// Global Mock List for Daily/Hourly Packages based on user screenshots
final List<DHPackageModel> mockDHPackages = [
  for (int i = 0; i < 10; i++) ...[
    DHPackageModel(
      id: "pkg_m_$i",
      title: const LocalizedString("عرض الزيارة يوم الثلاثاء", "Tuesday Visit Offer"),
      description: const LocalizedString("عاملات من شرق اسيا مدة الزيارة 4 ساعات", "Workers from East Asia, visit duration 4 hours"),
      originalPrice: 147.2,
      discountedPrice: 99.0,
      discountPercentage: 20.0,
      isMorning: true,
    ),
    DHPackageModel(
      id: "pkg_e_$i",
      title: const LocalizedString("عرض الزيارة يوم الثلاثاء", "Tuesday Visit Offer"),
      description: const LocalizedString("عاملات من شرق اسيا مدة الزيارة 4 ساعات", "Workers from East Asia, visit duration 4 hours"),
      originalPrice: 160.0,
      discountedPrice: 120.0,
      discountPercentage: 25.0,
      isMorning: false,
    )
  ]
];
