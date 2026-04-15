class AddressEntity {
  final String id;
  final String fullName;
  final String addressName;
  final String phone;
  final String city;
  final String region;
  final String street;
  final String postalCode;
  final String? details;
  final bool isPrimary;

  const AddressEntity({
    required this.id,
    required this.fullName,
    required this.addressName,
    required this.phone,
    required this.city,
    required this.region,
    required this.street,
    required this.postalCode,
    this.details,
    required this.isPrimary,
  });

  String get fullAddressFormatted {
    return '$city حي $region طريق $street\n$postalCode';
  }
}
