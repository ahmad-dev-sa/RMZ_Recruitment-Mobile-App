class BannerEntity {
  final int id;
  final String? titleAr;
  final String? titleEn;
  final String? textAr;
  final String? textEn;
  final String textColor;
  final String textColorDark;
  final String imageUrl;
  final String? imageDarkUrl;
  final String? url;
  final String location;
  final bool isActive;

  const BannerEntity({
    required this.id,
    this.titleAr,
    this.titleEn,
    this.textAr,
    this.textEn,
    required this.textColor,
    required this.textColorDark,
    required this.imageUrl,
    this.imageDarkUrl,
    this.url,
    required this.location,
    required this.isActive,
  });
}
