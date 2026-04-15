  import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../widgets/home_header.dart';
import '../widgets/category_selector.dart';
import '../widgets/latest_packages_slider.dart';
import '../widgets/services_grid.dart';

class HomeTabView extends StatelessWidget {
  const HomeTabView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          const HomeHeader(),
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                children: [
                  SizedBox(height: 24.h),
                  const CategorySelector(),
                  SizedBox(height: 32.h),
                  const LatestPackagesSlider(),
                  SizedBox(height: 32.h),
                  const ServicesGrid(),
                  SizedBox(height: 100.h), // Bottom padding for navbar
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

