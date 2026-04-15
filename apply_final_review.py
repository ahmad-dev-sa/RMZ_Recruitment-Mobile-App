import re

# 1. Update backend api views to properly append add_review endpoint and change url_path
with open('../backend/api/views/orders.py', 'r') as f:
    views_content = f.read()

review_logic = """
    @action(detail=True, methods=['post'], url_path='submit-review')
    def add_review(self, request, pk=None):
        order = self.get_object()
        
        if hasattr(order, 'review'):
            from rest_framework import status
            from rest_framework.response import Response
            return Response({'error': 'تم التقييم مسبقاً'}, status=status.HTTP_400_BAD_REQUEST)
        
        rating = request.data.get('rating')
        worker_rating = request.data.get('worker_rating')
        comment = request.data.get('comment', '')
        
        if not rating or not worker_rating:
            from rest_framework import status
            from rest_framework.response import Response
            return Response({'error': 'تقييم الخدمة والعاملة مطلوب'}, status=status.HTTP_400_BAD_REQUEST)
            
        worker = None
        if hasattr(order, 'daily_booking') and order.daily_booking and order.daily_booking.worker:
            worker = order.daily_booking.worker
            
        from orders.models import OrderReview
        OrderReview.objects.create(
            order=order,
            worker=worker,
            rating=rating,
            worker_rating=worker_rating,
            comment=comment,
            is_approved=False
        )
        
        from rest_framework import status
        from rest_framework.response import Response
        return Response({'success': True}, status=status.HTTP_201_CREATED)

    @action(detail=True, methods="""

if "url_path='submit-review'" not in views_content:
    # Inject it right before customer_requests exactly
    views_content = re.sub(r"    @action\(detail=True, methods=.*?url_path='requests'\)\s*def customer_requests", 
                          review_logic + "['post', 'get'], url_path='requests')\n    def customer_requests", 
                          views_content)
with open('../backend/api/views/orders.py', 'w') as f:
    f.write(views_content)


# 2. Update Repo Impl to use submit-review URL
with open('../mobile_app/lib/features/booking/data/repositories/booking_repository_impl.dart', 'r') as f:
    repo_content = f.read()
repo_content = repo_content.replace("'orders/$orderId/add_review/'", "'orders/$orderId/submit-review/'")
with open('../mobile_app/lib/features/booking/data/repositories/booking_repository_impl.dart', 'w') as f:
    f.write(repo_content)


# 3. Add ReviewEntity to order_details_entity.dart
with open('../mobile_app/lib/features/booking/domain/entities/order_details_entity.dart', 'r') as f:
    entity = f.read()

review_entity = """
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
"""

if "OrderReviewEntity" not in entity:
    entity = entity.replace("class CustomerRequestEntity", review_entity + "\nclass CustomerRequestEntity")
    entity = entity.replace("final List<CustomerRequestEntity> customerRequests;", "final List<CustomerRequestEntity> customerRequests;\n  final OrderReviewEntity? review;")
    entity = entity.replace("this.customerRequests = const [],", "this.customerRequests = const [],\n    this.review,")

with open('../mobile_app/lib/features/booking/domain/entities/order_details_entity.dart', 'w') as f:
    f.write(entity)


# 4. Add parse logic to order_details_model.dart
with open('../mobile_app/lib/features/booking/data/models/order_details_model.dart', 'r') as f:
    model = f.read()

model_review_class = """
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
"""

if "OrderReviewModel" not in model:
    model = model.replace("class CustomerRequestModel", model_review_class + "\nclass CustomerRequestModel")
    model = model.replace("super.customerRequests = const [],", "super.customerRequests = const [],\n    super.review,")
    
    parsing_logic = """      customerRequests: (json['customer_requests'] as List<dynamic>?)
          ?.map((e) => CustomerRequestModel.fromJson(e as Map<String, dynamic>))
          .toList() ?? [],
      review: json['review'] != null ? OrderReviewModel.fromJson(json['review']) : null,"""
    model = model.replace("      customerRequests: (json['customer_requests'] as List<dynamic>?)\n          ?.map((e) => CustomerRequestModel.fromJson(e as Map<String, dynamic>))\n          .toList() ?? [],", parsing_logic)

with open('../mobile_app/lib/features/booking/data/models/order_details_model.dart', 'w') as f:
    f.write(model)


# 5. Fix UI in order_review_card.dart
with open('../mobile_app/lib/features/orders/presentation/widgets/details/order_review_card.dart', 'r') as f:
    review_card = f.read()

new_build_func = """  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    final review = widget.order.review;
    final bool hasExistingReview = review != null || _isSubmitted;

    return Container(
      padding: EdgeInsets.all(20.w),
      decoration: BoxDecoration(
        color: isDark ? AppColors.surfaceDark : Colors.white,
        borderRadius: BorderRadius.circular(16.r),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: hasExistingReview 
          ? _buildSuccessOrExistingView(isDark, review) 
          : _buildReviewForm(isDark),
    );
  }

  Widget _buildSuccessOrExistingView(bool isDark, [OrderReviewEntity? review]) {
    final int serviceR = review?.rating ?? _selectedRating;
    final int workerR = review?.workerRating ?? _workerRating;
    final String commentText = review?.comment ?? _commentController.text;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Container(
          padding: EdgeInsets.all(12.w),
          decoration: BoxDecoration(
            color: Colors.green.withAlpha(25),
            shape: BoxShape.circle,
          ),
          child: Icon(Icons.check_circle_rounded, color: Colors.green, size: 36.sp),
        ),
        SizedBox(height: 12.h),
        Text(
          'تم التقييم بنجاح',
          style: TextStyle(
            fontSize: 16.sp,
            fontWeight: FontWeight.bold,
            color: isDark ? Colors.white : AppColors.textPrimaryLight,
          ),
        ),
        SizedBox(height: 24.h),
        
        Text(
          'تقييم العاملة',
          style: TextStyle(fontSize: 13.sp, fontWeight: FontWeight.bold, color: Colors.grey),
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: List.generate(5, (index) {
            return Padding(
              padding: EdgeInsets.symmetric(horizontal: 2.w),
              child: Icon(
                index < workerR ? Icons.star_rounded : Icons.star_outline_rounded,
                color: index < workerR ? Colors.amber : Colors.grey.shade400,
                size: 24.sp,
              ),
            );
          }),
        ),
        
        SizedBox(height: 16.h),
        
        Text(
          'تقييم الخدمة',
          style: TextStyle(fontSize: 13.sp, fontWeight: FontWeight.bold, color: Colors.grey),
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: List.generate(5, (index) {
            return Padding(
              padding: EdgeInsets.symmetric(horizontal: 2.w),
              child: Icon(
                index < serviceR ? Icons.star_rounded : Icons.star_outline_rounded,
                color: index < serviceR ? Colors.amber : Colors.grey.shade400,
                size: 24.sp,
              ),
            );
          }),
        ),
        
        if (commentText.isNotEmpty) ...[
           SizedBox(height: 16.h),
           Container(
             width: double.infinity,
             padding: EdgeInsets.all(12.w),
             decoration: BoxDecoration(
               color: isDark ? const Color(0xFF1E293B) : Colors.grey.shade50,
               borderRadius: BorderRadius.circular(8.r)
             ),
             child: Text(commentText, style: TextStyle(fontSize: 12.sp, color: isDark ? Colors.grey.shade300 : Colors.grey.shade700), textAlign: TextAlign.center),
           )
        ]
      ],
    );
  }"""

if "_buildSuccessOrExistingView" not in review_card:
    review_card = re.sub(
        r"  @override\s*Widget build\(BuildContext context\) \{.*?\}\s*Widget _buildReviewForm\(bool isDark\) \{", 
        new_build_func + "\n\n  Widget _buildReviewForm(bool isDark) {", 
        review_card, flags=re.DOTALL
    )
    
    # Remove the old _buildSuccessView
    review_card = re.sub(r"  Widget _buildSuccessView\(bool isDark\) \{.*?\}\s*\}\s*$", "}\n", review_card, flags=re.DOTALL)

with open('../mobile_app/lib/features/orders/presentation/widgets/details/order_review_card.dart', 'w') as f:
    f.write(review_card)

