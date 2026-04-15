import re

with open('../mobile_app/lib/features/orders/presentation/widgets/details/order_review_card.dart', 'r') as f:
    content = f.read()

# Add _workerRating instead of just _selectedRating
if "int _selectedRating = 0;" in content:
    content = content.replace("int _selectedRating = 0;", "int _selectedRating = 0;\n  int _workerRating = 0;")
    
# Change the _submitReview logic snippet
change_start = "void _submitReview() async {"
change_end = "  @override"
pattern = r"void _submitReview\(\) async \{.*?^\s*@override"
new_submit_logic = """void _submitReview() async {
    if (_selectedRating == 0 || _workerRating == 0) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('الرجاء تقييم الخدمة والعاملة أولاً')),
      );
      return;
    }

    setState(() {
      _isLoading = true;
    });

    try {
      await ref.read(orderDetailsActionProvider.notifier).submitOrderReview(
        widget.order.id, 
        _selectedRating, 
        _workerRating, 
        _commentController.text.trim()
      );
      
      if (mounted) {
        setState(() {
          _isLoading = false;
          _isSubmitted = true;
        });
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('تم إرسال تقييمك بنجاح. شكراً لك!')),
        );
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
        final errorMsg = e.toString().replaceAll('Exception: ', '');
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(errorMsg), backgroundColor: Colors.red));
      }
    }
  }

  @override"""
  
content = re.sub(pattern, new_submit_logic, content, flags=re.DOTALL | re.MULTILINE)

# Also we need to make it a ConsumerStatefulWidget to access ref
if "extends StatefulWidget" in content:
    content = content.replace("extends StatefulWidget", "extends ConsumerStatefulWidget")
    content = content.replace("State<OrderReviewCard> createState()", "ConsumerState<OrderReviewCard> createState()")
    content = content.replace("State<OrderReviewCard>", "ConsumerState<OrderReviewCard>")
    content = content.replace("import 'package:flutter_screenutil/flutter_screenutil.dart';", "import 'package:flutter_screenutil/flutter_screenutil.dart';\nimport 'package:flutter_riverpod/flutter_riverpod.dart';\nimport '../../providers/order_details_provider.dart';")

# Add the worker rating row to the form
old_stars = """        // Stars Rating
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: List.generate(5, (index) {
            final starIndex = index + 1;
            return GestureDetector(
              onTap: () {
                setState(() {
                  _selectedRating = starIndex;
                });
              },
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 4.w),
                child: Icon(
                  starIndex <= _selectedRating ? Icons.star_rounded : Icons.star_outline_rounded,
                  color: starIndex <= _selectedRating ? Colors.amber : Colors.grey.shade400,
                  size: 40.sp,
                ),
              ),
            );
          }),
        ),"""

new_stars = """        // Worker Rating row
        Text(
          'تقييم العاملة',
          style: TextStyle(fontSize: 14.sp, fontWeight: FontWeight.bold, color: isDark ? Colors.white : AppColors.textPrimaryLight),
        ),
        SizedBox(height: 8.h),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: List.generate(5, (index) {
            final starIndex = index + 1;
            return GestureDetector(
              onTap: () {
                setState(() {
                  _workerRating = starIndex;
                });
              },
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 4.w),
                child: Icon(
                  starIndex <= _workerRating ? Icons.star_rounded : Icons.star_outline_rounded,
                  color: starIndex <= _workerRating ? Colors.amber : Colors.grey.shade400,
                  size: 40.sp,
                ),
              ),
            );
          }),
        ),
        SizedBox(height: 16.h),
        // Service Rating row
        Text(
          'تقييم الخدمة',
          style: TextStyle(fontSize: 14.sp, fontWeight: FontWeight.bold, color: isDark ? Colors.white : AppColors.textPrimaryLight),
        ),
        SizedBox(height: 8.h),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: List.generate(5, (index) {
            final starIndex = index + 1;
            return GestureDetector(
              onTap: () {
                setState(() {
                  _selectedRating = starIndex;
                });
              },
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 4.w),
                child: Icon(
                  starIndex <= _selectedRating ? Icons.star_rounded : Icons.star_outline_rounded,
                  color: starIndex <= _selectedRating ? Colors.amber : Colors.grey.shade400,
                  size: 40.sp,
                ),
              ),
            );
          }),
        ),"""
content = content.replace(old_stars, new_stars)


# Optional: Update Success view to show both
# I will just keep it simple and show a combined success message without stars, or only the service stars.

with open('../mobile_app/lib/features/orders/presentation/widgets/details/order_review_card.dart', 'w') as f:
    f.write(content)
