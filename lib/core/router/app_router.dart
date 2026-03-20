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
      // All other features routes (auth, home, etc) will be added here incrementally
    ],
    errorBuilder: (context, state) => Scaffold(
      body: Center(child: Text('Navigation Error: ${state.error}')),
    ),
  );
}
