import 'package:go_router/go_router.dart';
import 'package:flutter/material.dart';

import '../../features/splash/presentation/screens/splash_view.dart';
import '../../features/onboarding/presentation/screens/onboarding_view.dart';
import '../../features/auth/presentation/screens/login_view.dart';
import '../../features/auth/presentation/screens/register_view.dart';
import '../../features/home/presentation/screens/main_home_view.dart';
import '../../features/offers/presentation/screens/offers_view.dart';
import '../../features/services/presentation/screens/services_list_view.dart';
import '../../features/booking/presentation/screens/booking_wizard_view.dart';
import '../../features/booking/presentation/screens/booking_success_view.dart';
import '../../features/recruitment_flow/presentation/screens/recruitment_wizard_view.dart';
import '../../features/recruitment_flow/presentation/screens/recruitment_success_view.dart';
import '../../features/rental_flow/presentation/screens/rental_wizard_view.dart';
import '../../features/rental_flow/presentation/screens/rental_success_view.dart';
import '../../features/daily_hourly_flow/presentation/screens/daily_hourly_flow_view.dart';
import '../../features/daily_hourly_flow/presentation/screens/dh_success_view.dart';
import '../../features/address/presentation/screens/manage_addresses_view.dart';
import '../../features/notifications/presentation/screens/notifications_view.dart';

final GlobalKey<NavigatorState> _rootNavigatorKey = GlobalKey<NavigatorState>(debugLabel: 'root');

class AppRouter {
  AppRouter._();

  static final GoRouter router = GoRouter(
    navigatorKey: _rootNavigatorKey,
    initialLocation: '/',
    // TODO: Add redirect logic here (e.g., check auth state)
    routes: [
      GoRoute(
        path: '/',
        name: 'splash',
        builder: (context, state) => const SplashView(),
      ),
      GoRoute(
        path: '/onboarding',
        name: 'onboarding',
        builder: (context, state) => const OnboardingView(),
      ),
      GoRoute(
        path: '/login',
        name: 'login',
        builder: (context, state) => const LoginView(),
      ),
      GoRoute(
        path: '/register',
        name: 'register',
        builder: (context, state) => const RegisterView(),
      ),
      GoRoute(
        path: '/home',
        name: 'home',
        builder: (context, state) => const MainHomeView(),
      ),
      GoRoute(
        path: '/offers',
        name: 'offers',
        builder: (context, state) => const OffersView(),
      ),
      GoRoute(
        path: '/services',
        name: 'services',
        builder: (context, state) {
          final categoryId = int.tryParse(state.uri.queryParameters['categoryId'] ?? '0') ?? 0;
          final categoryName = state.uri.queryParameters['categoryName'] ?? '';
          return ServicesListView(
            categoryId: categoryId,
            categoryName: categoryName,
          );
        },
      ),
      GoRoute(
        path: '/booking',
        name: 'booking',
        builder: (context, state) {
          final categoryId = int.tryParse(state.uri.queryParameters['categoryId'] ?? '1') ?? 1;
          final serviceId = int.tryParse(state.uri.queryParameters['serviceId'] ?? '1') ?? 1;
          final serviceName = state.uri.queryParameters['serviceName'] ?? 'طلب خدمة';
          return BookingWizardView(
            categoryId: categoryId,
            serviceId: serviceId,
            serviceName: serviceName,
          );
        },
      ),
      GoRoute(
        path: '/booking-success',
        name: 'booking-success',
        builder: (context, state) => const BookingSuccessView(),
      ),
      GoRoute(
        path: '/workflow/recruitment',
        name: 'workflow-recruitment',
        builder: (context, state) {
          final categoryId = int.tryParse(state.uri.queryParameters['categoryId'] ?? '1') ?? 1;
          final serviceId = int.tryParse(state.uri.queryParameters['serviceId'] ?? '1') ?? 1;
          final serviceName = state.uri.queryParameters['serviceName'] ?? 'طلب خدمة';
          return RecruitmentWizardView(
            categoryId: categoryId,
            serviceId: serviceId,
            serviceName: serviceName,
          );
        },
      ),
      GoRoute(
        path: '/workflow/recruitment/success',
        name: 'recruitment-success',
        builder: (context, state) {
          final order = state.extra; // OrderEntity or OrderModel
          return RecruitmentSuccessView(order: order);
        },
      ),
      GoRoute(
        path: '/workflow/daily-hourly/success',
        name: 'workflow-dh-success',
        builder: (context, state) => const DhSuccessView(),
      ),
      GoRoute(
        path: '/workflow/rental',
        name: 'workflow-rental',
        builder: (context, state) {
          final categoryId = int.tryParse(state.uri.queryParameters['categoryId'] ?? '1') ?? 1;
          final serviceId = int.tryParse(state.uri.queryParameters['serviceId'] ?? '0') ?? 0;
          return RentalWizardView(categoryId: categoryId, serviceId: serviceId);
        },
      ),
      GoRoute(
        path: '/workflow/rental/success',
        name: 'rental-success',
        builder: (context, state) => const RentalSuccessView(),
      ),

      GoRoute(
        path: '/workflow/daily-hourly',
        name: 'workflow-daily-hourly',
        builder: (context, state) {
          final categoryId = int.tryParse(state.uri.queryParameters['categoryId'] ?? '1') ?? 1;
          final serviceId = int.tryParse(state.uri.queryParameters['serviceId'] ?? '1') ?? 1;
          final serviceName = state.uri.queryParameters['serviceName'] ?? 'مدبرة منزل';
          return DailyHourlyFlowView(
            categoryId: categoryId,
            serviceId: serviceId,
            serviceName: serviceName,
          );
        },
      ),
      GoRoute(
        path: '/manage-addresses',
        name: 'manage-addresses',
        builder: (context, state) => const ManageAddressesView(),
      ),
      GoRoute(
        path: '/notifications',
        name: 'notifications',
        builder: (context, state) => const NotificationsView(),
      ),
      // All other features routes (auth, home, etc) will be added here incrementally
    ],
    errorBuilder: (context, state) => Scaffold(
      body: Center(child: Text('Navigation Error: ${state.error}')),
    ),
  );
}
