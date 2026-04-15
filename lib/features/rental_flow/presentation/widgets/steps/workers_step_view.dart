import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:easy_localization/easy_localization.dart';

import '../../../../../core/widgets/primary_button.dart';
import '../../../../../core/constants/app_colors.dart';
import '../../providers/rental_provider.dart';
import '../../../../booking/domain/entities/order_details_entity.dart';
import '../../providers/rental_candidates_provider.dart';
import '../../../../orders/presentation/widgets/details/candidate_cv_fullscreen_view.dart';

class WorkersStepView extends ConsumerStatefulWidget {
  const WorkersStepView({super.key});

  @override
  ConsumerState<WorkersStepView> createState() => _WorkersStepViewState();
}

class _WorkersStepViewState extends ConsumerState<WorkersStepView> {


  @override
  Widget build(BuildContext context) {
    final state = ref.watch(rentalProvider);
    final notifier = ref.read(rentalProvider.notifier);
    final candidatesAsync = ref.watch(rentalCandidatesProvider);

    return Column(
      children: [
        Expanded(
          child: SingleChildScrollView(
            padding: EdgeInsets.all(24.w),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'available_workers'.tr(),
                  style: TextStyle(
                    fontSize: 18.sp,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 16.h),
                candidatesAsync.when(
                  data: (workers) {
                    if (workers.isEmpty) {
                      return Center(
                        child: Padding(
                           padding: EdgeInsets.all(24.h),
                           child: Text("لا توجد عاملات متاحات حالياً", style: TextStyle(color: Colors.grey, fontSize: 16.sp)),
                        )
                      );
                    }
                    return ListView.separated(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: workers.length,
                      separatorBuilder: (context, index) => SizedBox(height: 16.h),
                      itemBuilder: (context, index) {
                        final worker = workers[index];
                        final isSelected = state.selectedWorker?.id == worker.id;
                        
                        return GestureDetector(
                          onTap: () {
                            notifier.selectWorker(worker);
                          },
                          child: Container(
                            padding: EdgeInsets.all(16.w),
                            decoration: BoxDecoration(
                              color: isSelected ? AppColors.primary.withValues(alpha: 0.05) : Theme.of(context).cardColor,
                              borderRadius: BorderRadius.circular(12.r),
                              border: Border.all(
                                color: isSelected ? AppColors.primary : Colors.grey.shade300,
                                width: isSelected ? 2 : 1,
                              ),
                            ),
                            child: Column(
                              children: [
                                Row(
                                  children: [
                                    CircleAvatar(
                                      radius: 30.r,
                                      backgroundColor: Colors.grey.shade200,
                                      backgroundImage: worker.imageUrl != null ? NetworkImage(worker.imageUrl!) : null,
                                      child: worker.imageUrl == null ? Icon(Icons.person, size: 30.r, color: Colors.grey) : null,
                                    ),
                                    SizedBox(width: 16.w),
                                    Expanded(
                                      child: Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            worker.name,
                                            style: TextStyle(
                                              fontSize: 16.sp,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                          SizedBox(height: 8.h),
                                          Row(
                                            children: [
                                              _buildInfoChip(context, Icons.work, worker.getLocalizedProfession(context.locale.languageCode == 'ar')),
                                              SizedBox(width: 8.w),
                                              _buildInfoChip(context, Icons.flag, worker.getLocalizedNationality(context.locale.languageCode == 'ar')),
                                            ],
                                          ),
                                        ],
                                      ),
                                    ),
                                    if (isSelected)
                                      Container(
                                        padding: EdgeInsets.all(4.w),
                                        decoration: const BoxDecoration(
                                          color: AppColors.primary,
                                          shape: BoxShape.circle,
                                        ),
                                        child: Icon(Icons.check, color: Colors.white, size: 20.sp),
                                      )
                                  ],
                                ),
                                SizedBox(height: 12.h),
                                SizedBox(
                                  width: double.infinity,
                                  height: 36.h,
                                  child: OutlinedButton.icon(
                                    onPressed: () {
                                      Navigator.push(
                                        context, 
                                        MaterialPageRoute(
                                          builder: (_) => CandidateCvFullscreenView(candidate: worker),
                                        ),
                                      );
                                    },
                                    icon: Icon(Icons.description_outlined, size: 16.sp),
                                    label: Text("عرض السيرة الذاتية", style: TextStyle(fontSize: 14.sp)),
                                    style: OutlinedButton.styleFrom(
                                      foregroundColor: AppColors.primary,
                                      side: BorderSide(color: AppColors.primary.withValues(alpha: 0.5)),
                                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8.r)),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    );
                  },
                  loading: () => Center(child: Padding(padding: EdgeInsets.all(24.h), child: const CircularProgressIndicator())),
                  error: (err, stack) => Center(child: Text("يوجد مشكلة في جلب البيانات.", style: TextStyle(color: Colors.red))),
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
              text: 'continue'.tr(),
              onPressed: state.selectedWorker != null ? () => notifier.nextStep() : () {},
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildInfoChip(BuildContext context, IconData icon, String text) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 4.h),
      decoration: BoxDecoration(
        color: Colors.grey.shade100,
        borderRadius: BorderRadius.circular(16.r),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 14.sp, color: Colors.grey.shade700),
          SizedBox(width: 4.w),
          Text(
            text,
            style: TextStyle(fontSize: 12.sp, color: Colors.grey.shade700),
          ),
        ],
      ),
    );
  }
}
