import '../../domain/entities/address_entity.dart';

class AddressModel extends AddressEntity {
  const AddressModel({
    required super.id,
    required super.fullName,
    required super.addressName,
    required super.phone,
    required super.city,
    required super.region,
    required super.street,
    required super.postalCode,
    super.details,
    required super.isPrimary,
  });

  factory AddressModel.fromJson(Map<String, dynamic> json) {
    return AddressModel(
      id: json['id']?.toString() ?? '',
      fullName: json['full_name'] ?? '',
      addressName: json['address_name'] ?? 'المنزل',
      phone: json['phone'] ?? '',
      city: json['city'] ?? '',
      region: json['district'] ?? json['region'] ?? '',
      street: json['street'] ?? '',
      postalCode: json['postal_code']?.toString() ?? '',
      details: json['notes'] ?? json['details'],
      isPrimary: json['is_default'] ?? json['is_primary'] ?? false,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'full_name': fullName,
      'address_name': addressName,
      'phone': phone,
      'city': city,
      'district': region,
      'region': region,
      'street': street,
      'postal_code': postalCode,
      'details': details,
      'notes': details,
      'is_default': isPrimary,
      'is_primary': isPrimary,
    };
  }
}
