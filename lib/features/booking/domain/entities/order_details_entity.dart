import 'order_entity.dart';

class OrderDetailsEntity extends OrderEntity {
  final String subTotal;
  final String recruitmentPrice;
  final String serviceFee;
  final String? discount;
  final String taxAmount;
  final String? visaNumber;
  final String? visaExpiryDate;
  final String? visaStatus;
  final List<CandidateEntity> candidates;
  final CandidateEntity? selectedCandidate;
  final List<OrderDocumentEntity> documents;
  final ContractEntity? contract;
  final DailyBookingEntity? dailyBooking;
  final List<CustomerRequestEntity> customerRequests;
  final OrderReviewEntity? review;

  const OrderDetailsEntity({
    required super.id,
    required super.orderNumber,
    required super.status,
    required super.totalPrice,
    required super.packageName,
    required super.createdAt,
    required super.orderType,
    required this.subTotal,
    required this.recruitmentPrice,
    required this.serviceFee,
    this.discount,
    required this.taxAmount,
    this.visaNumber,
    this.visaExpiryDate,
    this.visaStatus,
    required this.candidates,
    this.selectedCandidate,
    required this.documents,
    this.contract,
    this.dailyBooking,
    this.customerRequests = const [],
    this.review,
  });
}


class OrderReviewEntity {
  final int rating;
  final int? workerRating;
  final String? comment;
  
  const OrderReviewEntity({
    required this.rating,
    this.workerRating,
    this.comment,
  });
}

class CustomerRequestEntity {
  final int id;
  final String requestType;
  final String status;
  final String? details;
  final String? adminResponse;
  
  const CustomerRequestEntity({
    required this.id,
    required this.requestType,
    required this.status,
    this.details,
    this.adminResponse,
  });
}

class DailyBookingEntity {
  final String dateStr;
  final String startTime;
  final String endTime;
  final String shiftPeriod;
  final int hours;
  final String city;
  final String address;
  final String status;
  final String? actualStartTime;
  final String? actualEndTime;
  final CandidateEntity? assignedWorker;

  const DailyBookingEntity({
    required this.dateStr,
    required this.startTime,
    required this.endTime,
    required this.shiftPeriod,
    required this.hours,
    required this.city,
    required this.address,
    required this.status,
    this.actualStartTime,
    this.actualEndTime,
    this.assignedWorker,
  });
}

class CandidateEntity {
  final String id;
  final String name;
  final String? imageUrl;
  final String? professionAr;
  final String? professionEn;
  final String? nationalityAr;
  final String? nationalityEn;
  final WorkerDetailsEntity? workerDetails;

  const CandidateEntity({
    required this.id,
    required this.name,
    this.imageUrl,
    this.professionAr,
    this.professionEn,
    this.nationalityAr,
    this.nationalityEn,
    this.workerDetails,
  });

  String getLocalizedProfession(bool isAr) => isAr ? (professionAr ?? professionEn ?? '') : (professionEn ?? professionAr ?? '');
  String getLocalizedNationality(bool isAr) => isAr ? (nationalityAr ?? nationalityEn ?? '') : (nationalityEn ?? nationalityAr ?? '');
}

class OrderDocumentEntity {
  final String id;
  final String title;
  final String fileUrl;
  final String uploadedAt;

  const OrderDocumentEntity({
    required this.id,
    required this.title,
    required this.fileUrl,
    required this.uploadedAt,
  });
}

class ContractEntity {
  final String id;
  final String status;
  final String? printPdf;
  final String? signedPdf;
  final String? htmlContent;
  final String? startDate;
  final String? endDate;

  const ContractEntity({
    required this.id,
    required this.status,
    this.printPdf,
    this.signedPdf,
    this.htmlContent,
    this.startDate,
    this.endDate,
  });
}

class WorkerDetailsEntity {
  final WorkerCVDetailsEntity? cv;
  final String? age;
  final String? religion;
  final String? maritalStatus;
  final int? childrenCount;
  final String? height;
  final String? weight;

  const WorkerDetailsEntity({
    this.cv,
    this.age,
    this.religion,
    this.maritalStatus,
    this.childrenCount,
    this.height,
    this.weight,
  });
}

class WorkerCVDetailsEntity {
  final List<ExperienceEntity> experiences;
  final List<LanguageEntity> languages;
  final List<SkillEntity> skills;
  final List<VideoEntity> videos;

  const WorkerCVDetailsEntity({
    this.experiences = const [],
    this.languages = const [],
    this.skills = const [],
    this.videos = const [],
  });
}

class ExperienceEntity {
  final String duration;
  final String? titleAr;
  final String? titleEn;
  final String? countryAr;
  final String? countryEn;

  const ExperienceEntity({
    required this.duration,
    this.titleAr,
    this.titleEn,
    this.countryAr,
    this.countryEn,
  });

  String getLocalizedTitle(bool isAr) => isAr ? (titleAr ?? titleEn ?? '') : (titleEn ?? titleAr ?? '');
  String getLocalizedCountry(bool isAr) => isAr ? (countryAr ?? countryEn ?? '') : (countryEn ?? countryAr ?? '');
}

class LanguageEntity {
  final String nameAr;
  final String nameEn;
  final String level;

  const LanguageEntity({required this.nameAr, required this.nameEn, required this.level});

  String getLocalizedName(bool isAr) => isAr ? nameAr : nameEn;
}

class SkillEntity {
  final String nameAr;
  final String nameEn;
  final String? iconUrl;

  const SkillEntity({required this.nameAr, required this.nameEn, this.iconUrl});

  String getLocalizedName(bool isAr) => isAr ? nameAr : nameEn;
}

class VideoEntity {
  final String id;
  final String title;
  final String url;

  const VideoEntity({required this.id, required this.title, required this.url});
}
