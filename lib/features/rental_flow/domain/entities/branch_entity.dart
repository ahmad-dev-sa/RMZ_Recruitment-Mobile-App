class BranchEntity {
  final int id;
  final String nameAr;
  final String nameEn;
  final String? addressAr;
  final String? addressEn;

  BranchEntity({
    required this.id,
    required this.nameAr,
    required this.nameEn,
    this.addressAr,
    this.addressEn,
  });

  factory BranchEntity.fromJson(Map<String, dynamic> json) {
    return BranchEntity(
      id: json['id'] as int? ?? 0,
      nameAr: json['name_ar'] as String? ?? 'الفرع الرئيسي',
      nameEn: json['name_en'] as String? ?? 'Main Branch',
      addressAr: json['address_ar'] as String?,
      addressEn: json['address_en'] as String?,
    );
  }
}
