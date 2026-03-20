import '../../domain/entities/banner_entity.dart';

class BannerModel extends BannerEntity {
  const BannerModel({
    required super.id,
    super.titleAr,
    super.titleEn,
    super.textAr,
    super.textEn,
    required super.textColor,
    required super.textColorDark,
    required super.imageUrl,
    super.imageDarkUrl,
    super.url,
    required super.location,
    required super.isActive,
  });

  factory BannerModel.fromJson(Map<String, dynamic> json) {
    // Django REST Framework ModelSerializer with image_url custom field
    // Sometimes 'image_url' might be nested or we might just use 'image' string if present
    String finalImageUrl = '';
    if (json['image_url'] != null) {
      finalImageUrl = json['image_url'];
    } else if (json['image'] != null) {
      finalImageUrl = json['image'];
    }

    return BannerModel(
      id: json['id'] ?? 0,
      titleAr: json['title_ar'],
      titleEn: json['title_en'],
      textAr: json['text_ar'],
      textEn: json['text_en'],
      textColor: json['text_color'] ?? '#FFFFFF',
      textColorDark: json['text_color_dark'] ?? '#FFFFFF',
      imageUrl: finalImageUrl,
      imageDarkUrl: json['image_dark'],
      url: json['url'],
      location: json['location'] ?? 'all',
      isActive: json['is_active'] ?? true,
    );
  }
}
