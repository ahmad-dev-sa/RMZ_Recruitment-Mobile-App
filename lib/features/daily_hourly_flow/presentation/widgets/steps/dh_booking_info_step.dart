import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:easy_localization/easy_localization.dart';
import '../../../../../core/constants/app_colors.dart';
import '../../../../../core/widgets/primary_button.dart';
import '../../providers/daily_hourly_provider.dart';
import 'package:table_calendar/table_calendar.dart';
import '../../../../auth/presentation/providers/auth_provider.dart';
import 'package:go_router/go_router.dart';
import '../../../../address/presentation/providers/address_provider.dart';

class DHBookingInfoStep extends ConsumerStatefulWidget {
  const DHBookingInfoStep({super.key});

  @override
  ConsumerState<DHBookingInfoStep> createState() => _DHBookingInfoStepState();
}

class _DHBookingInfoStepState extends ConsumerState<DHBookingInfoStep> {
  DateTime _focusedDay = DateTime.now();
  DateTime? _selectedDay;
  Set<DateTime> _availableDates = {};
  bool _isLoadingCalendar = true;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final selectedDate = ref.read(dailyHourlyProvider).selectedDate;
      if (selectedDate != null) {
        setState(() => _focusedDay = selectedDate);
        _selectedDay = selectedDate;
      }
      _fetchAvailability(_focusedDay);
    });
  }

  Future<void> _fetchAvailability(DateTime date) async {
    setState(() => _isLoadingCalendar = true);
    
    try {
      final dio = ref.read(dioClientProvider).dio;
      final packageId = ref.read(dailyHourlyProvider).selectedPackageId;
      if (packageId == null) {
        setState(() => _isLoadingCalendar = false);
        return;
      }
      
      final baseUrlUri = Uri.parse(dio.options.baseUrl);
      final origin = baseUrlUri.origin;
      final endpointUrl = '$origin/orders/api/hourly/$packageId/calendar_availability/';
      
      final response = await dio.get(
        endpointUrl, 
        queryParameters: {
          'year': date.year,
          'month': date.month,
        }
      );
      
      if (response.statusCode == 200 && response.data['available_dates'] != null) {
        final List<dynamic> datesRaw = response.data['available_dates'];
        final dates = datesRaw.map((d) {
          final parsed = DateTime.parse(d as String);
          return DateTime(parsed.year, parsed.month, parsed.day);
        }).toSet();
        
        setState(() {
          _availableDates = dates;
          _isLoadingCalendar = false;
        });
      } else {
        setState(() => _isLoadingCalendar = false);
      }
    } catch (e) {
      debugPrint("Error fetching calendar availability: $e");
      setState(() => _isLoadingCalendar = false);
    }
  }

  void _onDaySelected(DateTime selectedDay, DateTime focusedDay) {
    setState(() {
      _selectedDay = selectedDay;
      _focusedDay = selectedDay;
    });
    ref.read(dailyHourlyProvider.notifier).setDate(selectedDay);
  }

  Widget _buildSummaryRow(String title, String value, bool isDark) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          title,
          style: TextStyle(
            fontSize: 14.sp,
            color: isDark ? Colors.grey.shade400 : Colors.grey.shade600,
          ),
        ),
        Text(
          value,
          style: TextStyle(
            fontSize: 14.sp,
            fontWeight: FontWeight.bold,
            color: isDark ? Colors.white : Colors.black87,
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final state = ref.watch(dailyHourlyProvider);
    final notifier = ref.read(dailyHourlyProvider.notifier);
    final isAr = context.locale.languageCode == 'ar';
    final addressState = ref.watch(addressProvider);

    // Auto-select address if not already selected
    if (!addressState.isLoading && addressState.addresses.isNotEmpty && state.selectedAddress == null) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        try {
          final primary = addressState.primaryAddress ?? addressState.addresses.first;
          notifier.setAddress("${primary.city}، ${primary.region}، ${primary.street}");
        } catch (_) {}
      });
    }

    return Column(
      children: [
        Expanded(
          child: SingleChildScrollView(
            padding: EdgeInsets.all(20.w),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Choose Day Section
                Row(
                  children: [
                    Container(width: 4.w, height: 24.h, color: AppColors.primary),
                    SizedBox(width: 8.w),
                    Text(
                      'daily_hourly.choose_day'.tr(),
                      style: TextStyle(fontSize: 18.sp, fontWeight: FontWeight.bold, color: isDark ? Colors.white : Colors.black87),
                    ),
                  ],
                ),
                            // Calendar Box
                Container(
                  padding: EdgeInsets.all(8.w),
                  decoration: BoxDecoration(
                    color: isDark ? Colors.grey.shade900 : Colors.white,
                    borderRadius: BorderRadius.circular(16.r),
                    border: Border.all(color: AppColors.primary.withOpacity(0.5)),
                  ),
                  child: _isLoadingCalendar 
                  ? Center(child: Padding(padding: EdgeInsets.all(40.h), child: const CircularProgressIndicator()))
                  : TableCalendar(
                      locale: context.locale.languageCode,
                      firstDay: DateTime.now(),
                      lastDay: DateTime.now().add(const Duration(days: 365)),
                      focusedDay: _focusedDay,
                      selectedDayPredicate: (day) => isSameDay(_selectedDay, day),
                      onDaySelected: _onDaySelected,
                      onPageChanged: (focusedDay) {
                        _focusedDay = focusedDay;
                        _fetchAvailability(focusedDay);
                      },
                      availableGestures: AvailableGestures.horizontalSwipe,
                      calendarFormat: CalendarFormat.month,
                      headerStyle: HeaderStyle(
                        formatButtonVisible: false,
                        titleCentered: true,
                        titleTextStyle: TextStyle(fontSize: 16.sp, fontWeight: FontWeight.bold, color: AppColors.primary),
                        leftChevronIcon: Icon(Icons.chevron_left, color: AppColors.primary),
                        rightChevronIcon: Icon(Icons.chevron_right, color: AppColors.primary),
                      ),
                      daysOfWeekStyle: DaysOfWeekStyle(
                        weekdayStyle: TextStyle(color: AppColors.primary, fontSize: 13.sp, fontWeight: FontWeight.bold),
                        weekendStyle: TextStyle(color: AppColors.primary, fontSize: 13.sp, fontWeight: FontWeight.bold),
                      ),
                      enabledDayPredicate: (day) {
                        final normalized = DateTime(day.year, day.month, day.day);
                        return _availableDates.contains(normalized);
                      },
                      calendarBuilders: CalendarBuilders(
                        defaultBuilder: (context, day, focusedDay) {
                          return Container(
                            margin: EdgeInsets.all(6.w),
                            alignment: Alignment.center,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: AppColors.primary.withOpacity(0.05),
                            ),
                            child: Text(
                              '${day.day}',
                              style: TextStyle(
                                color: isDark ? Colors.white : Colors.black87,
                                fontSize: 14.sp,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          );
                        },
                        selectedBuilder: (context, day, focusedDay) {
                          return Container(
                            margin: EdgeInsets.all(4.w),
                            alignment: Alignment.center,
                            decoration: const BoxDecoration(
                              shape: BoxShape.circle,
                              color: AppColors.primary,
                            ),
                            child: Text(
                              '${day.day}',
                              style: TextStyle(color: Colors.white, fontSize: 14.sp, fontWeight: FontWeight.bold),
                            ),
                          );
                        },
                        disabledBuilder: (context, day, focusedDay) {
                          return Container(
                            margin: EdgeInsets.all(6.w),
                            alignment: Alignment.center,
                            child: Text(
                              '${day.day}',
                              style: TextStyle(color: Colors.grey.shade400, fontSize: 14.sp),
                            ),
                          );
                        },
                      ),
                  ),
                ),
                
                if (_selectedDay != null) ...[
                  SizedBox(height: 24.h),
                  Row(
                    children: [
                      Container(width: 4.w, height: 24.h, color: AppColors.primary),
                      SizedBox(width: 8.w),
                      Text(
                        'daily_hourly.package_info'.tr(),
                        style: TextStyle(fontSize: 18.sp, fontWeight: FontWeight.bold, color: isDark ? Colors.white : Colors.black87),
                      ),
                    ],
                  ),
                  SizedBox(height: 16.h),
                  Container(
                    padding: EdgeInsets.all(16.w),
                    decoration: BoxDecoration(
                      color: isDark ? Colors.grey.shade900 : Colors.white,
                      borderRadius: BorderRadius.circular(16.r),
                      border: Border.all(color: AppColors.primary.withOpacity(0.3)),
                    ),
                    child: Column(
                      children: [
                        Builder(
                          builder: (context) {
                            String visitsText = '';
                            if (state.selectedVisitCount == 1) {
                              visitsText = 'daily_hourly.one_visit'.tr();
                            } else if (state.selectedVisitCount == 2) {
                              visitsText = 'daily_hourly.two_visits'.tr();
                            } else if (state.selectedVisitCount >= 3 && state.selectedVisitCount <= 10) {
                              visitsText = 'daily_hourly.visits_plural_3_10'.tr(namedArgs: {'count': state.selectedVisitCount.toString()});
                            } else {
                              visitsText = 'daily_hourly.visits_plural_11'.tr(namedArgs: {'count': state.selectedVisitCount.toString()});
                            }
                            return _buildSummaryRow('daily_hourly.selected_visit'.tr(), visitsText, isDark);
                          }
                        ),
                        Divider(color: Colors.grey.withOpacity(0.2), height: 16.h),
                        _buildSummaryRow(
                          'daily_hourly.selected_dates'.tr(),
                          DateFormat('yyyy-MM-dd').format(_selectedDay!),
                          isDark,
                        ),
                        Divider(color: Colors.grey.withOpacity(0.2), height: 16.h),
                        _buildSummaryRow(
                          'daily_hourly.available_period'.tr(),
                          state.selectedPeriod == DayTimePeriod.morning ? 'daily_hourly.morning'.tr() : 'daily_hourly.evening'.tr(),
                          isDark,
                        ),
                      ],
                    ),
                  ),
                ],

                SizedBox(height: 32.h),

                // Address Section
                Row(
                  children: [
                    Container(width: 4.w, height: 24.h, color: AppColors.primary),
                    SizedBox(width: 8.w),
                    Text(
                      'daily_hourly.address'.tr(),
                      style: TextStyle(fontSize: 18.sp, fontWeight: FontWeight.bold, color: isDark ? Colors.white : Colors.black87),
                    ),
                  ],
                ),
                SizedBox(height: 16.h),

                if (addressState.isLoading)
                  Center(
                    child: Padding(
                      padding: EdgeInsets.all(16.h),
                      child: const CircularProgressIndicator(),
                    ),
                  )
                else if (addressState.addresses.isEmpty)
                  GestureDetector(
                    onTap: () {
                      context.pushNamed('manage-addresses');
                    },
                    child: Container(
                      padding: EdgeInsets.all(16.w),
                      decoration: BoxDecoration(
                        color: isDark ? Colors.grey.shade900 : Colors.white,
                        borderRadius: BorderRadius.circular(16.r),
                        border: Border.all(color: AppColors.primary, width: 1.5),
                        boxShadow: [
                          BoxShadow(color: AppColors.primary.withOpacity(0.1), blurRadius: 10, offset: const Offset(0, 4))
                        ],
                      ),
                      alignment: Alignment.center,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.add_location_alt_outlined, color: AppColors.primary, size: 24.sp),
                          SizedBox(width: 8.w),
                          Text(
                            'addresses.add_new_address'.tr(),
                            style: TextStyle(color: AppColors.primary, fontSize: 16.sp, fontWeight: FontWeight.bold),
                          ),
                        ],
                      ),
                    ),
                  )
                else
                  GestureDetector(
                   onTap: () {
                     context.pushNamed('manage-addresses');
                   },
                   child: Container(
                    padding: EdgeInsets.all(20.w),
                    decoration: BoxDecoration(
                      color: isDark ? Colors.grey.shade900 : Colors.white,
                      borderRadius: BorderRadius.circular(16.r),
                      border: Border.all(color: state.selectedAddress != null ? AppColors.primary : Colors.grey.shade200),
                      boxShadow: [
                        BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 10, offset: const Offset(0, 4))
                      ],
                    ),
                    child: Row(
                      children: [
                        Container(
                          padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 6.h),
                          decoration: BoxDecoration(
                            color: AppColors.primary,
                            borderRadius: BorderRadius.circular(20.r),
                          ),
                          child: Row(
                            children: [
                              Text('daily_hourly.main_address'.tr(), style: TextStyle(color: Colors.white, fontSize: 12.sp)),
                              SizedBox(width: 4.w),
                              Icon(Icons.keyboard_arrow_down_rounded, color: Colors.white, size: 16.sp),
                            ],
                          ),
                        ),
                        SizedBox(width: 16.w),
                        Expanded(
                          child: Text(
                            state.selectedAddress ?? "اضغط لاختيار العنوان من قائمة العناوين المضافة",
                            style: TextStyle(fontSize: 12.sp, color: isDark ? Colors.grey.shade400 : Colors.grey.shade600),
                            maxLines: 2,
                          ),
                        ),
                      ],
                    ),
                   ),
                ),
              ],
            ),
          ),
        ),
        
        // Footer with Continuous Button
        Container(
          padding: EdgeInsets.all(24.w),
          decoration: BoxDecoration(
            color: Theme.of(context).scaffoldBackgroundColor,
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.05),
                offset: const Offset(0, -2),
                blurRadius: 10,
              ),
            ],
          ),
          child: SafeArea(
            top: false,
            child: PrimaryButton(
              text: 'daily_hourly.continue_btn'.tr(),
              onPressed: state.selectedAddress != null && state.selectedDate != null 
                  ? () => notifier.nextStep() 
                  : () {},
            ),
          ),
        ),
      ],
    );
  }
}
