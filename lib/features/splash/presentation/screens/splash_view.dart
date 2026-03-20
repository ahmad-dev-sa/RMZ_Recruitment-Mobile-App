import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../auth/presentation/providers/auth_provider.dart';
import '../../../auth/presentation/providers/auth_state.dart';

class SplashView extends ConsumerStatefulWidget {
  const SplashView({super.key});

  @override
  ConsumerState<SplashView> createState() => _SplashViewState();
}

class _SplashViewState extends ConsumerState<SplashView>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;

  @override
  void initState() {
    super.initState();
    _initAnimations();
    _navigateToNextScreen();
  }

  void _initAnimations() {
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1500),
    );

    // Fade animation for the Logo
    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: Curves.easeIn,
      ),
    );

    // Slide up animation for the Text
    _slideAnimation = Tween<Offset>(
      begin: const Offset(0, 0.5),
      end: Offset.zero,
    ).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: Curves.easeOutBack,
      ),
    );

    _animationController.forward();
  }

  Future<void> _navigateToNextScreen() async {
    // Wait for animation to finish + extra 1 second for user to view the splash
    await Future.delayed(const Duration(milliseconds: 2500));
    
    if (mounted) {
      final authState = ref.read(authProvider);
      
      // If still loading, wait a bit
      if (authState is AuthLoading || authState is AuthInitial) {
         await Future.delayed(const Duration(milliseconds: 500));
      }
      
      final currentAuthState = ref.read(authProvider);
      if (currentAuthState is AuthAuthenticated) {
        context.goNamed('home');
      } else {
        context.goNamed('onboarding');
      }
    }
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // Handling Dark/Light mode Background automatically based on AppTheme
    final theme = Theme.of(context);

    // Define logo path based on theme to handle contrast if needed
    // Assuming the user provides a standard logo, we will tint it if it's an SVG
    // But since it's a PNG right now, we just display it.
    // If you need a white version of the logo for dark mode, handle it here.

    return Scaffold(
      body: SizedBox(
        width: double.infinity,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // Logo with Fade In Animation
            FadeTransition(
              opacity: _fadeAnimation,
              child: Container(
                width: 180.w,
                height: 180.w,
                decoration: const BoxDecoration(
                  shape: BoxShape.circle,
                  // We add a subtle shadow or specific color if needed
                ),
                child: ClipOval(
                  child: Image.asset(
                    'assets/images/logo.png', // This logo file must be created
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) {
                      return Icon(Icons.business, size: 80.w, color: theme.colorScheme.primary);
                    },
                  ),
                ),
              ),
            ),
            
            SizedBox(height: 30.h),
            
            // Slogan with Slide Up Animation
            SlideTransition(
              position: _slideAnimation,
              child: FadeTransition(
                opacity: _fadeAnimation,
                child: Text(
                  'splash.slogan'.tr(), // Fetches "نظافة منزلية ... وأكثر" from localization
                  style: theme.textTheme.headlineSmall?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: theme.colorScheme.onSurface,
                    fontSize: 24.sp,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
