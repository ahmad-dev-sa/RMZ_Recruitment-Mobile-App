import '../../domain/entities/order_details_entity.dart';
import 'order_model.dart';

class OrderDetailsModel extends OrderDetailsEntity {
  const OrderDetailsModel({
    required super.id,
    required super.orderNumber,
    required super.status,
    required super.totalPrice,
    required super.packageName,
    required super.createdAt,
    required super.orderType,
    required super.subTotal,
    required super.recruitmentPrice,
    required super.serviceFee,
    super.discount,
    required super.taxAmount,
    super.visaNumber,
    super.visaExpiryDate,
    super.visaStatus,
    required super.candidates,
    super.selectedCandidate,
    required super.documents,
    super.contract,
    super.dailyBooking,
    super.customerRequests = const [],
    super.review,
  });

  factory OrderDetailsModel.fromJson(Map<String, dynamic> json) {
    // Parse base fields similar to OrderModel
    return OrderDetailsModel(
      id: json['id']?.toString() ?? '',
      orderNumber: json['order_number']?.toString() ?? json['id']?.toString() ?? '',
      status: json['status'] ?? 'جاري العمل',
      totalPrice: json['final_amount']?.toString() ?? json['total_amount']?.toString() ?? json['total_price']?.toString() ?? '0',
      packageName: json['package_name'] ?? json['service_name'] ?? 'باقة استقدام',
      createdAt: json['created_at'] ?? '',
      orderType: json['order_type'] ?? 'recruitment',
      
      // Parse detailed fields
      subTotal: json['sub_total']?.toString() ?? json['base_amount']?.toString() ?? json['price']?.toString() ?? '0',
      recruitmentPrice: json['recruitment_price']?.toString() ?? json['package_price']?.toString() ?? json['price']?.toString() ?? json['amount']?.toString() ?? '0',
      serviceFee: json['service_fee']?.toString() ?? json['margin']?.toString() ?? json['admin_fee']?.toString() ?? json['fee']?.toString() ?? '0',
      discount: json['discount_amount']?.toString() ?? json['discount']?.toString(), // Handle null naturally
      
      taxAmount: json['tax_amount']?.toString() ?? '0',
      visaNumber: json['visa_number']?.toString(),
      visaExpiryDate: json['visa_expiry_date']?.toString(),
      visaStatus: json['visa_status']?.toString(),
      
      candidates: (json['candidates'] as List<dynamic>?)
              ?.map((e) => CandidateModel.fromJson(e as Map<String, dynamic>))
              .toList() ??
          const [],
      selectedCandidate: json['selected_candidate'] != null 
          ? CandidateModel.fromJson(json['selected_candidate'] as Map<String, dynamic>) 
          : null,
      documents: (json['documents'] as List<dynamic>?)
              ?.map((e) => OrderDocumentModel.fromJson(e as Map<String, dynamic>))
              .toList() ??
          const [],
      contract: json['contract'] != null
          ? ContractModel.fromJson(json['contract'] as Map<String, dynamic>)
          : null,
      dailyBooking: json['daily_booking'] != null
          ? DailyBookingModel.fromJson(json['daily_booking'] as Map<String, dynamic>)
          : null,
      customerRequests: (json['customer_requests'] as List<dynamic>?)
              ?.map((e) => CustomerRequestModel.fromJson(e as Map<String, dynamic>))
              .toList() ??
          const [],
      review: json['review'] != null ? OrderReviewModel.fromJson(json['review']) : null,
    );
  }
}


class OrderReviewModel extends OrderReviewEntity {
  const OrderReviewModel({
    required super.rating,
    super.workerRating,
    super.comment,
  });

  factory OrderReviewModel.fromJson(Map<String, dynamic> json) {
    return OrderReviewModel(
      rating: json['rating'] ?? 0,
      workerRating: json['worker_rating'],
      comment: json['comment'],
    );
  }
}

class CustomerRequestModel extends CustomerRequestEntity {
  const CustomerRequestModel({
    required super.id,
    required super.requestType,
    required super.status,
    super.details,
    super.adminResponse,
  });

  factory CustomerRequestModel.fromJson(Map<String, dynamic> json) {
    return CustomerRequestModel(
      id: json['id'] ?? 0,
      requestType: json['request_type'] ?? '',
      status: json['status'] ?? 'pending',
      details: json['details']?.toString(),
      adminResponse: json['admin_response']?.toString(),
    );
  }
}

class DailyBookingModel extends DailyBookingEntity {
  DailyBookingModel({
    required super.dateStr,
    required super.startTime,
    required super.endTime,
    required super.shiftPeriod,
    required super.hours,
    required super.city,
    required super.address,
    required super.status,
    super.actualStartTime,
    super.actualEndTime,
    super.assignedWorker,
  });

  factory DailyBookingModel.fromJson(Map<String, dynamic> json) {
    // Get date from selected_dates or booking_date
    String dateValue = '';
    if (json['selected_dates'] != null && (json['selected_dates'] as List).isNotEmpty) {
      dateValue = (json['selected_dates'] as List).first.toString();
    } else if (json['booking_date'] != null) {
      dateValue = json['booking_date'].toString();
    }

    return DailyBookingModel(
      dateStr: dateValue,
      startTime: json['start_time'] ?? '',
      endTime: json['end_time'] ?? '',
      shiftPeriod: json['shift_period'] ?? 'morning',
      hours: json['hours'] != null ? int.tryParse(json['hours'].toString()) ?? 4 : 4,
      city: json['city'] ?? '',
      address: json['address'] ?? '',
      status: json['status'] ?? 'active',
      actualStartTime: json['actual_start_time'],
      actualEndTime: json['actual_end_time'],
      assignedWorker: json['assigned_worker'] != null 
          ? CandidateModel.fromJson(json['assigned_worker'] as Map<String, dynamic>)
          : null,
    );
  }
}

class CandidateModel extends CandidateEntity {
  const CandidateModel({
    required super.id,
    required super.name,
    super.imageUrl,
    super.professionAr,
    super.professionEn,
    super.nationalityAr,
    super.nationalityEn,
    super.workerDetails,
  });

  factory CandidateModel.fromJson(Map<String, dynamic> json) {
    String? profAr;
    String? profEn;
    if (json['profession'] is Map) {
      profAr = json['profession']['name_ar']?.toString();
      profEn = json['profession']['name_en']?.toString();
    } else {
      profAr = json['profession']?.toString();
      profEn = json['profession']?.toString();
    }

    String? natAr;
    String? natEn;
    if (json['nationality'] is Map) {
      natAr = json['nationality']['name_ar']?.toString();
      natEn = json['nationality']['name_en']?.toString();
    } else {
      natAr = json['nationality']?.toString();
      natEn = json['nationality']?.toString();
    }

    return CandidateModel(
      id: json['id']?.toString() ?? '',
      name: json['name'] ?? json['full_name_ar'] ?? json['full_name_en'] ?? 'مرشح غير معروف',
      imageUrl: json['image_url'] ?? json['photo'] ?? json['avatar'],
      professionAr: profAr,
      professionEn: profEn,
      nationalityAr: natAr,
      nationalityEn: natEn,
      workerDetails: json['worker_details'] != null 
          ? WorkerDetailsModel.fromJson(json['worker_details']) 
          : WorkerDetailsModel.fromJson(json), // Fallback: try parsing current object directly
    );
  }
}

class OrderDocumentModel extends OrderDocumentEntity {
  const OrderDocumentModel({
    required super.id,
    required super.title,
    required super.fileUrl,
    required super.uploadedAt,
  });

  factory OrderDocumentModel.fromJson(Map<String, dynamic> json) {
    return OrderDocumentModel(
      id: json['id']?.toString() ?? '',
      title: (json['description'] != null && json['description'].toString().isNotEmpty)
          ? json['description']
          : (json['title'] ?? 'مستند'),
      fileUrl: json['file_url'] ?? json['url'] ?? '',
      uploadedAt: json['uploaded_at'] ?? '',
    );
  }
}

class ContractModel extends ContractEntity {
  const ContractModel({
    required super.id,
    required super.status,
    super.printPdf,
    super.signedPdf,
    super.htmlContent,
    super.startDate,
    super.endDate,
  });

  factory ContractModel.fromJson(Map<String, dynamic> json) {
    return ContractModel(
      id: json['id']?.toString() ?? '',
      status: json['status']?.toString() ?? '',
      printPdf: json['print_pdf']?.toString(),
      signedPdf: json['signed_pdf']?.toString(),
      htmlContent: json['html_content']?.toString(),
      startDate: json['contract_start_date']?.toString(),
      endDate: json['contract_end_date']?.toString(),
    );
  }
}

class WorkerDetailsModel extends WorkerDetailsEntity {
  const WorkerDetailsModel({
    super.cv,
    super.age,
    super.religion,
    super.maritalStatus,
    super.childrenCount,
    super.height,
    super.weight,
  });

  factory WorkerDetailsModel.fromJson(Map<String, dynamic> json) {
    return WorkerDetailsModel(
      cv: json['cv'] != null ? WorkerCVDetailsModel.fromJson(json['cv']) : null,
      age: json['age']?.toString(),
      religion: json['religion'],
      maritalStatus: json['marital_status'],
      childrenCount: json['children_count'] != null ? int.tryParse(json['children_count'].toString()) : null,
      height: json['height']?.toString(),
      weight: json['weight']?.toString(),
    );
  }
}

class WorkerCVDetailsModel extends WorkerCVDetailsEntity {
  const WorkerCVDetailsModel({
    super.experiences = const [],
    super.languages = const [],
    super.skills = const [],
    super.videos = const [],
  });

  factory WorkerCVDetailsModel.fromJson(Map<String, dynamic> json) {
    return WorkerCVDetailsModel(
      experiences: (json['experiences'] as List<dynamic>?)
              ?.map((e) => ExperienceModel.fromJson(e))
              .toList() ??
          const [],
      languages: (json['languages_details'] as List<dynamic>?)
              ?.map((e) => LanguageModel.fromJson(e))
              .toList() ??
          const [],
      skills: (json['domestic_skills'] as List<dynamic>?)
              ?.map((e) => SkillModel.fromJson(e))
              .toList() ??
          const [],
      videos: (json['videos'] as List<dynamic>?)
              ?.map((e) => VideoModel.fromJson(e))
              .toList() ??
          const [],
    );
  }
}

class ExperienceModel extends ExperienceEntity {
  const ExperienceModel({
    required super.duration,
    super.titleAr,
    super.titleEn,
    super.countryAr,
    super.countryEn,
  });

  factory ExperienceModel.fromJson(Map<String, dynamic> json) {
    String parsedDuration = '';
    if (json['duration'] is Map) {
      final y = json['duration']['years'] ?? 0;
      final m = json['duration']['months'] ?? 0;
      if (y > 0 && m > 0) parsedDuration = '$y سنوات و $m شهور';
      else if (y > 0) parsedDuration = '$y سنوات';
      else if (m > 0) parsedDuration = '$m شهور';
    } else {
      parsedDuration = json['duration']?.toString() ?? '';
    }

    return ExperienceModel(
      duration: parsedDuration,
      titleAr: json['job_title'] ?? json['title_ar'] ?? json['title'],
      titleEn: json['job_title_en'] ?? json['title_en'] ?? json['title'],
      countryAr: json['country_name'] ?? json['country_name_ar'] ?? json['country'],
      countryEn: json['country_name_en'] ?? json['country_en'] ?? json['country'],
    );
  }
}

class LanguageModel extends LanguageEntity {
  const LanguageModel({required super.nameAr, required super.nameEn, required super.level});

  factory LanguageModel.fromJson(Map<String, dynamic> json) {
    final langDetails = json['language'] as Map<String, dynamic>?;
    return LanguageModel(
      nameAr: langDetails?['name_ar'] ?? json['name_ar'] ?? json['name'] ?? '',
      nameEn: langDetails?['name_en'] ?? json['name_en'] ?? json['name'] ?? '',
      level: json['level_display'] ?? json['level'] ?? '',
    );
  }
}

class SkillModel extends SkillEntity {
  const SkillModel({required super.nameAr, required super.nameEn, super.iconUrl});

  factory SkillModel.fromJson(Map<String, dynamic> json) {
    return SkillModel(
      nameAr: json['name_ar'] ?? json['name'] ?? '',
      nameEn: json['name_en'] ?? json['name'] ?? '',
      iconUrl: json['icon_url'],
    );
  }
}

class VideoModel extends VideoEntity {
  const VideoModel({required super.id, required super.title, required super.url});

  factory VideoModel.fromJson(Map<String, dynamic> json) {
    return VideoModel(
      id: json['id']?.toString() ?? '',
      title: json['title'] ?? '',
      url: json['video_url'] ?? json['url'] ?? '',
    );
  }
}
