import '../../domain/entities/user_entity.dart';

class UserModel extends UserEntity {
  const UserModel({
    required super.id,
    required super.email,
    super.firstName,
    super.lastName,
    super.phoneNumber,
    super.idNumber,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    String? fName = json['first_name'] as String?;
    String? lName = json['last_name'] as String?;

    if (fName == null && json['full_name'] != null) {
      final nameParts = (json['full_name'] as String).split(' ');
      fName = nameParts.first;
      if (nameParts.length > 1) {
        lName = nameParts.sublist(1).join(' ');
      }
    }

    return UserModel(
      id: json['id'] as int? ?? 0,
      email: json['email'] as String? ?? '',
      firstName: fName,
      lastName: lName,
      phoneNumber: (json['phone_number'] ?? json['mobile']) as String?,
      idNumber: json['id_number'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'email': email,
      'first_name': firstName,
      'last_name': lastName,
      'phone_number': phoneNumber,
      'id_number': idNumber,
    };
  }
}
