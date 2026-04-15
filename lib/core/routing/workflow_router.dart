import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../enums/workflow_type.dart';
import '../../features/services/domain/entities/service_entity.dart';
import '../../features/services/domain/entities/category_entity.dart';

class WorkflowRouter {
  WorkflowRouter._();

  /// Starts the appropriate workflow based on the explicit [type] or falls back 
  /// intelligently using the [service] or [category].
  static void startWorkflow(
    BuildContext context, {
    WorkflowType? type,
    ServiceEntity? service,
    CategoryEntity? category,
  }) {
    // Determine the type: Priority -> Explicit Type -> Service Type -> Service Category Type -> Category Type
    final effectiveType = type ?? 
                          service?.workflowType ?? 
                          service?.category?.workflowType ?? 
                          category?.workflowType ?? 
                          WorkflowType.unknown;

    // Build the query parameters to pass forward
    final queryParams = <String, String>{};
    if (service != null) {
      queryParams['serviceId'] = service.id.toString();
      queryParams['serviceName'] = service.nameAr; // Defaulting to Arabic name for UI, could enhance
    }
    if (category != null) {
      queryParams['categoryId'] = category.id.toString();
      queryParams['categoryName'] = category.nameAr;
    }

    // Route based on determined workflow
    switch (effectiveType) {
      case WorkflowType.recruitment:
        context.pushNamed('workflow-recruitment', queryParameters: queryParams);
        break;
      case WorkflowType.rental:
        context.pushNamed('workflow-rental', queryParameters: queryParams);
        break;
      case WorkflowType.dailyHourly:
        context.pushNamed('workflow-daily-hourly', queryParameters: queryParams);
        break;
      case WorkflowType.unknown:
      default:
        // Fallback: If no workflow type is defined, show an error or fallback screen
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('نوع الخدمة غير مدعوم حالياً')),
        );
        break;
    }
  }
}
