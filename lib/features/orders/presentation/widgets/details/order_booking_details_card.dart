import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../providers/order_details_provider.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../../../../../core/constants/app_colors.dart';
import '../../../../booking/domain/entities/order_details_entity.dart';
import 'candidate_cv_fullscreen_view.dart';
import 'dart:async';

class OrderBookingDetailsCard extends ConsumerStatefulWidget {
  final OrderDetailsEntity order;

  const OrderBookingDetailsCard({super.key, required this.order});

  @override
  ConsumerState<OrderBookingDetailsCard> createState() => _OrderBookingDetailsCardState();
}

class _OrderBookingDetailsCardState extends ConsumerState<OrderBookingDetailsCard> {
  Timer? _timer;
  DateTime _now = DateTime.now();

  @override
  void initState() {
    super.initState();
    _timer = Timer.periodic(const Duration(minutes: 1), (timer) {
      if (mounted) {
        setState(() {
          _now = DateTime.now();
        });
      }
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  Future<void> _submitRequest(String type, {String? date, String? details}) async {
    try {
      await ref.read(orderDetailsActionProvider.notifier).submitCustomerRequest(
        widget.order.id, 
        type, 
        requestedDate: date, 
        details: details
      );
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('تم إرسال الطلب للإدارة بنجاح')));
      }
    } catch (e) {
      if (mounted) {
        final errorMsg = e.toString().replaceAll('Exception: ', '');
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(errorMsg), backgroundColor: Colors.red));
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    if (widget.order.dailyBooking == null) return const SizedBox.shrink();
    
    final booking = widget.order.dailyBooking!;
    final isDark = Theme.of(context).brightness == Brightness.dark;

    final bool isCancelled = widget.order.status == 'cancelled' || widget.order.status == 'canceled' || booking.status == 'cancelled';
    final String statusStr = isCancelled 
        ? 'ملغي'
        : (booking.status == 'completed' 
            ? 'orders.status_completed'.tr() 
            : (booking.status == 'active' ? 'orders.status_active'.tr() : 'orders.status_processing'.tr()));
            
    final Color statusColor = isCancelled 
        ? Colors.red 
        : (booking.status == 'completed' ? Colors.green : Colors.orange.shade700);
        
    final Color statusBgColor = isCancelled 
        ? Colors.red.withAlpha(25) 
        : (booking.status == 'completed' ? Colors.green.withAlpha(25) : Colors.orange.withAlpha(25));

    return Container(
      padding: EdgeInsets.all(20.w),
      decoration: BoxDecoration(
        color: isDark ? AppColors.surfaceDark : Colors.white,
        borderRadius: BorderRadius.circular(16.r),
        border: Border(
          right: BorderSide(color: AppColors.primary, width: 4.w),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'تفاصيل الحجز', // 'orders.booking_details'.tr()
                style: TextStyle(
                  fontSize: 18.sp,
                  fontWeight: FontWeight.bold,
                  color: isDark ? Colors.white : AppColors.textPrimaryLight,
                ),
              ),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 6.h),
                decoration: BoxDecoration(
                  color: statusBgColor,
                  borderRadius: BorderRadius.circular(20.r),
                ),
                child: Text(
                  statusStr,
                  style: TextStyle(
                    color: statusColor,
                    fontSize: 12.sp,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
          
          SizedBox(height: 16.h),
          Divider(color: isDark ? Colors.grey.shade800 : Colors.grey.shade200),
          SizedBox(height: 16.h),

          // Section 1: Assigned Worker
          Text(
            'العامل المعين',
            style: TextStyle(fontSize: 12.sp, color: Colors.grey, fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 8.h),
          _buildAssignedWorker(booking.assignedWorker, context),

          SizedBox(height: 24.h),

          // Section 2: Date & Shift Duration
          Container(
            padding: EdgeInsets.all(16.w),
            decoration: BoxDecoration(
              color: isDark ? const Color(0xFF1E293B) : Colors.grey.shade50,
              borderRadius: BorderRadius.circular(12.r),
              border: Border.all(color: isDark ? Colors.grey.shade700 : Colors.grey.shade200),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('التاريخ والوردية', style: TextStyle(fontSize: 12.sp, color: Colors.grey, fontWeight: FontWeight.bold)),
                    SizedBox(height: 4.h),
                    Row(
                      children: [
                        Text(
                          _formatDate(booking.dateStr),
                          style: TextStyle(fontSize: 14.sp, fontWeight: FontWeight.bold, color: isDark ? Colors.white : Colors.black),
                        ),
                        SizedBox(width: 8.w),
                        Container(
                          padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 2.h),
                          decoration: BoxDecoration(
                            color: Colors.blue.withOpacity(0.15),
                            borderRadius: BorderRadius.circular(12.r),
                          ),
                          child: Text(
                            booking.shiftPeriod == 'morning' ? 'صباحي' : 'مسائي',
                            style: TextStyle(color: Colors.blue, fontSize: 10.sp, fontWeight: FontWeight.bold),
                          ),
                        ),
                      ],
                    ),
                    
                    SizedBox(height: 16.h),
                    
                    Text('المدة', style: TextStyle(fontSize: 12.sp, color: Colors.grey, fontWeight: FontWeight.bold)),
                    SizedBox(height: 4.h),
                    Row(
                      children: [
                        Text(
                          '${booking.hours} ساعات',
                          style: TextStyle(fontSize: 14.sp, fontWeight: FontWeight.bold, color: isDark ? Colors.white : Colors.black),
                        ),
                        Padding(
                          padding: EdgeInsets.symmetric(horizontal: 8.w),
                          child: Icon(Icons.arrow_forward_rounded, color: Colors.grey, size: 16.sp),
                        ),
                        Text(
                          _formatTime(booking.startTime),
                          style: TextStyle(fontSize: 14.sp, fontWeight: FontWeight.bold, color: isDark ? Colors.white : Colors.black),
                        ),
                      ],
                    ),
                  ],
                ),
                
                SizedBox(height: 20.h),
                Divider(color: isDark ? Colors.grey.shade700 : Colors.grey.shade300, height: 1),
                SizedBox(height: 20.h),
                
                Text('العنوان', style: TextStyle(fontSize: 12.sp, color: Colors.grey, fontWeight: FontWeight.bold)),
                SizedBox(height: 4.h),
                Text(
                  booking.address.isNotEmpty ? booking.address : 'لم يتم تحديد عنوان',
                  style: TextStyle(fontSize: 14.sp, color: isDark ? Colors.white : Colors.black, fontWeight: FontWeight.w600),
                ),
                
                SizedBox(height: 24.h),
                
                // Text for service start to end
                Container(
                  padding: EdgeInsets.symmetric(vertical: 8.h, horizontal: 12.w),
                  decoration: BoxDecoration(
                    color: AppColors.primary.withOpacity(0.05),
                    borderRadius: BorderRadius.circular(8.r),
                    border: Border.all(color: AppColors.primary.withOpacity(0.2)),
                  ),
                  child: Row(
                    children: [
                      Icon(Icons.info_outline, color: AppColors.primary, size: 16.sp),
                      SizedBox(width: 8.w),
                      Expanded(
                        child: Text(
                          'تبدأ الخدمة من ${_formatTime(booking.startTime)} إلى ${_formatTime(booking.endTime)} للفترة المحددة بالحجز',
                          style: TextStyle(color: AppColors.primary, fontSize: 11.sp, fontWeight: FontWeight.bold),
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 24.h),

             
                
                // Actual Timeline
                if (booking.actualStartTime != null && !isCancelled) ...[
                  SizedBox(height: 24.h),
                  _buildTimeline(
                    title: 'الشريط الزمني الفعلي',
                    progress: _getActualProgress(booking),
                    startTimeStr: _formatActualTime(booking.actualStartTime),
                    endTimeStr: (booking.actualEndTime != null || booking.status == 'completed')
                        ? (booking.actualEndTime != null ? _formatActualTime(booking.actualEndTime) : _formatTime(booking.endTime))
                        : 'جاري...',
                    isDark: isDark,
                    isStarted: true,
                    activeColor: Colors.green,
                  ),
                ],
                
                SizedBox(height: 24.h),
                
                // Action Buttons
                if (booking.actualStartTime == null && booking.status != 'completed' && !isCancelled) ...[
                  Builder(
                    builder: (context) {
                      final hasPendingPostpone = widget.order.customerRequests.any((r) => r.requestType == 'postpone' && r.status == 'pending');
                      final hasPendingRefund = widget.order.customerRequests.any((r) => r.requestType == 'refund' || r.requestType == 'cancel' && r.status == 'pending');

                      return Column(
                        children: [
                          /* 
                          SizedBox(
                            width: double.infinity,
                            child: ElevatedButton(
                              onPressed: () {
                                ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('سيتم بدء الخدمة...')));
                              },
                              style: ElevatedButton.styleFrom(
                                backgroundColor: AppColors.primary,
                                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8.r)),
                                padding: EdgeInsets.symmetric(vertical: 12.h),
                              ),
                              child: Text('بدء الخدمة', style: TextStyle(fontSize: 14.sp, fontWeight: FontWeight.bold, color: Colors.white)),
                            ),
                          ),
                          SizedBox(height: 12.h),
                          */
                          Row(
                            children: [
                              Expanded(
                                child: OutlinedButton(
                                  onPressed: hasPendingPostpone ? null : () {
                                    _showPostponeDialog(context, booking);
                                  },
                                  style: OutlinedButton.styleFrom(
                                    side: BorderSide(color: hasPendingPostpone ? Colors.grey : Colors.orange.shade700),
                                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8.r)),
                                    padding: EdgeInsets.symmetric(vertical: 12.h),
                                  ),
                                  child: Text(hasPendingPostpone ? 'تم إرسال طلب التاجيل' : 'تأجيل', style: TextStyle(color: hasPendingPostpone ? Colors.grey : Colors.orange.shade700, fontSize: 12.sp, fontWeight: FontWeight.bold)),
                                ),
                              ),
                              SizedBox(width: 12.w),
                              Expanded(
                                child: OutlinedButton(
                                  onPressed: hasPendingRefund ? null : () {
                                    _showRefundDialog(context, booking);
                                  },
                                  style: OutlinedButton.styleFrom(
                                    side: BorderSide(color: hasPendingRefund ? Colors.grey : Colors.red.shade700),
                                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8.r)),
                                    padding: EdgeInsets.symmetric(vertical: 12.h),
                                  ),
                                  child: Text(hasPendingRefund ? 'تم إرسال طلب الاسترداد' : 'طلب استرداد', style: TextStyle(color: hasPendingRefund ? Colors.grey : Colors.red.shade700, fontSize: 12.sp, fontWeight: FontWeight.bold)),
                                ),
                              ),
                            ],
                          ),
                        ],
                      );
                    }
                  ),
                ] else if (booking.actualStartTime != null && booking.actualEndTime == null && booking.status != 'completed' && !isCancelled) ...[
                  SizedBox(
                    width: double.infinity,
                    child: OutlinedButton(
                      onPressed: () {
                        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('سيتم إيقاف الخدمة')));
                      },
                      style: OutlinedButton.styleFrom(
                        side: const BorderSide(color: Colors.red),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8.r)),
                        padding: EdgeInsets.symmetric(vertical: 12.h),
                      ),
                      child: Text('إيقاف الخدمة', style: TextStyle(color: Colors.red, fontSize: 14.sp, fontWeight: FontWeight.bold)),
                    ),
                  ),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAssignedWorker(CandidateEntity? worker, BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    
    if (worker == null) {
      return Container(
        padding: EdgeInsets.all(16.w),
        decoration: BoxDecoration(
          color: isDark ? const Color(0xFF1E293B) : Colors.grey.shade50,
          borderRadius: BorderRadius.circular(12.r),
          border: Border.all(color: isDark ? Colors.grey.shade700 : Colors.grey.shade200),
        ),
        child: Row(
          children: [
            CircleAvatar(
              radius: 26.r,
              backgroundColor: isDark ? Colors.grey.shade800 : Colors.grey.shade200,
              child: Icon(Icons.person_outline, color: Colors.grey, size: 24.sp),
            ),
            SizedBox(width: 16.w),
            Text(
              'لم يعين بعد',
              style: TextStyle(fontSize: 14.sp, color: Colors.grey, fontWeight: FontWeight.bold),
            ),
          ],
        ),
      );
    }
    
    final bool isAr = context.locale.languageCode == 'ar';
    final ageStr = worker.workerDetails?.age != null ? '${worker.workerDetails!.age} سنوات' : '';

    return Container(
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF1E293B) : Colors.grey.shade50,
        borderRadius: BorderRadius.circular(12.r),
        border: Border.all(color: isDark ? Colors.grey.shade700 : Colors.grey.shade200),
      ),
      child: Row(
        children: [
          // Avatar (First element: Right in RTL)
          Container(
            padding: EdgeInsets.all(2.w),
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(color: AppColors.primary, width: 2.w),
            ),
            child: CircleAvatar(
              radius: 36.r,
              backgroundColor: const Color(0xFF10B981), // Green color matching MA initials from design
              backgroundImage: (worker.imageUrl != null && worker.imageUrl!.isNotEmpty) 
                  ? CachedNetworkImageProvider(worker.imageUrl!) 
                  : null,
              child: (worker.imageUrl == null || worker.imageUrl!.isEmpty)
                  ? Text(
                      _getInitials(worker.name),
                      style: TextStyle(color: Colors.black, fontSize: 24.sp, fontWeight: FontWeight.bold),
                    )
                  : null,
            ),
          ),
          
          SizedBox(width: 16.w),
          
          // Worker details column (Second element: Left in RTL)
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  worker.name,
                  style: TextStyle(
                    fontSize: 16.sp,
                    fontWeight: FontWeight.bold,
                    color: isDark ? Colors.white : AppColors.textPrimaryLight,
                  ),
                ),
                SizedBox(height: 8.h),
                Row(
                  children: [
                    if (worker.getLocalizedNationality(isAr).isNotEmpty) ...[
                      Container(
                        padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 2.h),
                        decoration: BoxDecoration(
                          color: isDark ? Colors.grey.shade800 : Colors.grey.shade200,
                          borderRadius: BorderRadius.circular(12.r),
                        ),
                        child: Text(
                          worker.getLocalizedNationality(isAr),
                          style: TextStyle(fontSize: 10.sp, color: isDark ? Colors.grey.shade300 : Colors.grey.shade700),
                        ),
                      ),
                      SizedBox(width: 8.w),
                    ],
                    if (ageStr.isNotEmpty) ...[
                       Container(
                        padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 2.h),
                        decoration: BoxDecoration(
                          color: isDark ? Colors.grey.shade800 : Colors.grey.shade200,
                          borderRadius: BorderRadius.circular(12.r),
                        ),
                        child: Text(
                          ageStr,
                          style: TextStyle(fontSize: 10.sp, color: isDark ? Colors.grey.shade300 : Colors.grey.shade700),
                        ),
                      ),
                    ],
                  ],
                ),
                SizedBox(height: 12.h),
                OutlinedButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => CandidateCvFullscreenView(candidate: worker),
                      ),
                    );
                  },
                  style: OutlinedButton.styleFrom(
                    side: const BorderSide(color: AppColors.primary),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8.r)),
                    padding: EdgeInsets.symmetric(vertical: 2.h, horizontal: 16.w),
                    minimumSize: Size(0, 32.h),
                  ),
                  child: Text(
                    'عرض',
                    style: TextStyle(color: AppColors.primary, fontSize: 12.sp, fontWeight: FontWeight.bold),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  void _showPostponeDialog(BuildContext context, DailyBookingEntity booking) {
    DateTime? selectedDate;
    final isDark = Theme.of(context).brightness == Brightness.dark;

    showDialog(
      context: context,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setDialogState) {
            return AlertDialog(
              backgroundColor: isDark ? AppColors.surfaceDark : Colors.white,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16.r)),
              title: Text('تأجيل', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18.sp, color: isDark ? Colors.white : Colors.black)),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'حدد تاريخًا جديدًا لخدمتك. سيتم مراجعة طلبك من قبل الإدارة.',
                    style: TextStyle(fontSize: 14.sp, color: Colors.grey.shade600, height: 1.5),
                  ),
                  SizedBox(height: 20.h),
                  InkWell(
                    onTap: () async {
                      final date = await showDatePicker(
                        context: context,
                        initialDate: DateTime.now().add(const Duration(days: 1)),
                        firstDate: DateTime.now(),
                        lastDate: DateTime.now().add(const Duration(days: 90)),
                      );
                      if (date != null) {
                        setDialogState(() {
                          selectedDate = date;
                        });
                      }
                    },
                    child: Container(
                      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
                      decoration: BoxDecoration(
                        border: Border.all(color: AppColors.primary),
                        borderRadius: BorderRadius.circular(8.r),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            selectedDate == null 
                                ? 'اختر التاريخ' 
                                : DateFormat('yyyy-MM-dd').format(selectedDate!),
                            style: TextStyle(color: selectedDate == null ? Colors.grey : (isDark ? Colors.white : Colors.black), fontSize: 14.sp),
                          ),
                          Icon(Icons.calendar_today_outlined, color: AppColors.primary, size: 20.sp),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: Text('إلغاء', style: TextStyle(color: Colors.grey, fontSize: 14.sp)),
                ),
                ElevatedButton(
                  onPressed: selectedDate == null ? null : () {
                    final dateFormatted = DateFormat('yyyy-MM-dd').format(selectedDate!);
                    Navigator.pop(context);
                    _submitRequest('postpone', date: dateFormatted);
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primary,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8.r)),
                  ),
                  child: Text('تأكيد التأجيل', style: TextStyle(color: Colors.white, fontSize: 14.sp, fontWeight: FontWeight.bold)),
                ),
              ],
            );
          }
        );
      },
    );
  }

  void _showRefundDialog(BuildContext context, DailyBookingEntity booking) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final reasonController = TextEditingController();

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          backgroundColor: isDark ? AppColors.surfaceDark : Colors.white,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16.r)),
          title: Text('طلب استرداد', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18.sp, color: isDark ? Colors.white : Colors.black)),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'يرجى توضيح سبب طلب الاسترداد. سيتم مراجعة طلبك وإفادتك في أقرب وقت ممكن.',
                style: TextStyle(fontSize: 14.sp, color: Colors.grey.shade600, height: 1.5),
              ),
              SizedBox(height: 20.h),
              TextField(
                controller: reasonController,
                maxLines: 3,
                decoration: InputDecoration(
                  hintText: 'سبب الاسترداد...',
                  hintStyle: TextStyle(fontSize: 12.sp, color: Colors.grey),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8.r),
                    borderSide: BorderSide(color: Colors.grey.shade300),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8.r),
                    borderSide: const BorderSide(color: AppColors.primary),
                  ),
                ),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text('إلغاء', style: TextStyle(color: Colors.grey, fontSize: 14.sp)),
            ),
            ElevatedButton(
              onPressed: () {
                final reason = reasonController.text.trim();
                if(reason.isEmpty) {
                   ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('الرجاء كتابة السبب'), backgroundColor: Colors.red));
                   return;
                }
                Navigator.pop(context);
                _submitRequest('cancel', details: reason);
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red.shade700,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8.r)),
              ),
              child: Text('إرسال الطلب', style: TextStyle(color: Colors.white, fontSize: 14.sp, fontWeight: FontWeight.bold)),
            ),
          ],
        );
      },
    );
  }

  String _getInitials(String name) {
    if (name.isEmpty) return '??';
    List<String> parts = name.split(' ');
    if (parts.length > 1) {
      if (parts[0].isNotEmpty && parts[1].isNotEmpty) {
        return '${parts[0][0].toUpperCase()}${parts[1][0].toUpperCase()}';
      }
    }
    return name.substring(0, name.length > 1 ? 2 : 1).toUpperCase();
  }

  String _formatDate(String dateStr) {
    if (dateStr.isEmpty) return 'غير محدد';
    try {
      final date = DateTime.parse(dateStr);
      // Simplified arabic date formatting for the layout matching. 
      // Using Intls properly would be Better but hardcoded mapping suffices.
      List<String> months = ['يناير', 'فبراير', 'مارس', 'أبريل', 'مايو', 'يونيو', 'يوليو', 'أغسطس', 'سبتمبر', 'أكتوبر', 'نوفمبر', 'ديسمبر'];
      List<String> days = ['الاثنين', 'الثلاثاء', 'الأربعاء', 'الخميس', 'الجمعة', 'السبت', 'الأحد'];
      
      String month = months[date.month - 1];
      String day = days[date.weekday - 1];
      
      return '$day، $month ${date.day}, ${date.year}';
    } catch (e) {
      return dateStr;
    }
  }

  String _formatTime(String timeStr) {
    if (timeStr.isEmpty) return '--:--';
    try {
      // Assuming timeStr from backend is "HH:MM:SS" or "HH:MM" in 24hr
      final parts = timeStr.split(':');
      if (parts.length >= 2) {
        int hour = int.parse(parts[0]);
        String minute = parts[1];
        String ampm = hour >= 12 ? 'مساءً' : 'صباحاً';
        
        int hr12 = hour % 12;
        if (hr12 == 0) hr12 = 12; // 12 AM / 12 PM
        
        return '$hr12:$minute $ampm';
      }
      return timeStr;
    } catch (e) {
      return timeStr; // Return as is if parsing fails
    }
  }

  DateTime? _parseDateTime(String date, String time) {
    try {
      return DateTime.parse('$date $time');
    } catch (e) {
      return null;
    }
  }

  double _getScheduledProgress(DailyBookingEntity booking) {
    final start = _parseDateTime(booking.dateStr, booking.startTime);
    final end = _parseDateTime(booking.dateStr, booking.endTime);
    if (start == null || end == null) return 0.0;
    
    if (_now.isAfter(end)) return 1.0;
    if (_now.isBefore(start)) return 0.0;
    
    final total = end.difference(start).inMinutes;
    final elapsed = _now.difference(start).inMinutes;
    if (total <= 0) return 0.0;
    return (elapsed / total).clamp(0.0, 1.0);
  }

  double _getActualProgress(DailyBookingEntity booking) {
    if (booking.actualStartTime == null) return 0.0;
    if (booking.actualEndTime != null || booking.status == 'completed') return 1.0;
    
    try {
      final actualStart = DateTime.parse(booking.actualStartTime!);
      final actualEnd = actualStart.add(Duration(hours: booking.hours));
      
      if (_now.isAfter(actualEnd)) return 1.0;
      if (_now.isBefore(actualStart)) return 0.0;
      
      final total = actualEnd.difference(actualStart).inMinutes;
      final elapsed = _now.difference(actualStart).inMinutes;
      if (total <= 0) return 0.0;
      return (elapsed / total).clamp(0.0, 1.0);
    } catch (e) {
      return 0.0;
    }
  }

  Widget _buildTimeline({
    required String title,
    required double progress,
    required String startTimeStr,
    required String endTimeStr,
    required bool isDark,
    required bool isStarted,
    Color? activeColor,
  }) {
    final color = activeColor ?? AppColors.primary;
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(title, style: TextStyle(fontSize: 12.sp, color: Colors.grey, fontWeight: FontWeight.bold)),
            Container(
              padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 4.h),
              decoration: BoxDecoration(
                color: isStarted ? color : Colors.black,
                borderRadius: BorderRadius.circular(16.r),
              ),
              child: Text(
                '${(progress * 100).toInt()}%',
                style: TextStyle(color: Colors.white, fontSize: 10.sp, fontWeight: FontWeight.bold),
              ),
            ),
          ],
        ),
        SizedBox(height: 12.h),
        
        Stack(
          children: [
            Container(
              height: 8.h,
              width: double.infinity,
              decoration: BoxDecoration(
                color: isDark ? Colors.grey.shade800 : Colors.grey.shade300,
                borderRadius: BorderRadius.circular(4.r),
              ),
            ),
            Align(
              alignment: AlignmentDirectional.centerStart,
              child: FractionallySizedBox(
                widthFactor: progress,
                child: Container(
                  height: 8.h,
                  decoration: BoxDecoration(
                    color: color,
                    borderRadius: BorderRadius.circular(4.r),
                  ),
                ),
              ),
            ),
          ],
        ),
        
        SizedBox(height: 12.h),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('البداية', style: TextStyle(fontSize: 10.sp, color: Colors.grey)),
                Text(startTimeStr, style: TextStyle(fontSize: 12.sp, fontWeight: FontWeight.bold, color: isDark ? Colors.grey.shade300 : Colors.grey.shade800)),
              ],
            ),
            Text(
              isStarted ? (progress >= 1.0 ? 'مكتمل' : 'قيد التنفيذ') : 'لم تبدأ',
              style: TextStyle(fontSize: 12.sp, color: isStarted ? color : Colors.grey, fontWeight: isStarted ? FontWeight.bold : FontWeight.normal),
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text('النهاية', style: TextStyle(fontSize: 10.sp, color: Colors.grey)),
                Text(endTimeStr, style: TextStyle(fontSize: 12.sp, fontWeight: FontWeight.bold, color: isDark ? Colors.grey.shade300 : Colors.grey.shade800)),
              ],
            ),
          ],
        ),
      ],
    );
  }

  String _formatActualTime(String? dateTimeStr) {
    if (dateTimeStr == null || dateTimeStr.isEmpty) return '--:--';
    try {
      final date = DateTime.parse(dateTimeStr).toLocal();
      final hour = date.hour;
      final minute = date.minute.toString().padLeft(2, '0');
      final ampm = hour >= 12 ? 'مساءً' : 'صباحاً';
      int hr12 = hour % 12;
      if (hr12 == 0) hr12 = 12;
      return '$hr12:$minute $ampm';
    } catch (e) {
      return '--:--';
    }
  }
}
