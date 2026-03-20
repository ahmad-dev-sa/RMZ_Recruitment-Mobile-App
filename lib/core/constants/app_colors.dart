import 'package:flutter/material.dart';

class AppColors {
  AppColors._(); // Private constructor to prevent instantiation

  // Primary Colors
  static const Color primary = Color(0xFF24CBD4); // The Cyan color from the design
  static const Color secondary = Color(0xFF0F2035); // The Dark Blue text color from the design

  // Background Colors
  static const Color backgroundLight = Color(0xFFF9F9FA); // Very light grey/blue for the main app background
  static const Color backgroundDark = Color(0xFF121212);
  static const Color headerDarkBlue = Color(0xFF1A2B3C); // The dark blue header in Dashboard

  
  // Surface Colors
  static const Color surfaceLight = Colors.white;
  static const Color surfaceDark = Color(0xFF1E1E1E);

  // Text Colors
  static const Color textPrimaryLight = Color(0xFF0F2035); // Dark blue for headings
  static const Color textSecondaryLight = Color(0xFF6C757D); // Gray for body text
  
  static const Color textPrimaryDark = Color(0xFFF8F9FA);
  static const Color textSecondaryDark = Color(0xFFADB5BD);

  // Status/Semantic Colors
  static const Color error = Color(0xFFDC3545);
  static const Color success = Color(0xFF28A745);
  static const Color warning = Color(0xFFFFC107);
  
  // Custom specific colors
  static const Color cyanLight = Color(0xFFE8F9F9); // Light cyan for the skip button background
}
