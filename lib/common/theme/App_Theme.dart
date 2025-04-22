import 'package:flutter/material.dart';

class MedicalTheme {
  // Main colors
  static const primaryColor = Color(0xFF05699f);
  static const secondaryColor = Color(0xFF1a4179);
  static const loading = Color(0xFFD6D6D6); // Equivalent to Colors.grey.shade300
    static const loadinganimation = Color(0xFFF5F5F5); // Equivalent to Colors.grey.shade100

  // Background and surface colors
  static const backgroundColor = Colors.white;
  static const surfaceColor = Color(0xFFF0F4F8);
  static const cardColor = Colors.white;
  
  // Text colors
  static const textPrimaryColor = Color(0xFF1F2937);
  static const textSecondaryColor = Color(0xFF6B7280);
  static const textLightColor = Colors.white;
  
  // Status colors
  static const successColor = Color(0xFF4CAF50);
  static const warningColor = Color(0xFFFFC107);
  static const errorColor = Color(0xFFFF3B3B);
  static const infoColor = Color(0xFF2196F3);
  
  // Utility colors
  static final dividerColor = Color(0xFFE4E7EB);
  static final shadowColor = Colors.black.withOpacity(0.1);
  static final disabledColor = Color(0xFFBDBDBD);
  
  // Gradients
  static LinearGradient get primaryGradient => LinearGradient(
    colors: [primaryColor, secondaryColor],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );
  
  static LinearGradient get blueGradient => LinearGradient(
    colors: [Color(0xFF0099cc), Color(0xFF00ccff)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );
  
  static LinearGradient get purpleGradient => LinearGradient(
    colors: [Color(0xFF8A2BE2), Color(0xFFDA70D6)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );
  
  // Radius values
  static const smallRadius = 8.0;
  static const mediumRadius = 12.0;
  static const largeRadius = 20.0;
  
  // Padding values
  static const paddingSmall = 8.0;
  static const paddingMedium = 16.0;
  static const paddingLarge = 24.0;
  
  // Elevation values
  static const elevationSmall = 2.0;
  static const elevationMedium = 4.0;
  static const elevationLarge = 8.0;
  
  // Border radius objects
  static BorderRadius get smallBorderRadius => BorderRadius.circular(smallRadius);
  static BorderRadius get mediumBorderRadius => BorderRadius.circular(mediumRadius);
  static BorderRadius get largeBorderRadius => BorderRadius.circular(largeRadius);
  
  // Shadows
  static BoxShadow get lightShadow => BoxShadow(
    color: shadowColor.withOpacity(0.05),
    blurRadius: 8,
    offset: const Offset(0, 2),
  );
  
  static BoxShadow get mediumShadow => BoxShadow(
    color: shadowColor.withOpacity(0.1),
    blurRadius: 12,
    offset: const Offset(0, 4),
  );
  
  // Box decorations
  static BoxDecoration get cardDecoration => BoxDecoration(
    color: cardColor,
    borderRadius: mediumBorderRadius,
    border: Border.all(color: dividerColor),
    boxShadow: [lightShadow],
  );
  
  static BoxDecoration get statusCardDecoration => BoxDecoration(
    color: surfaceColor,
    borderRadius: mediumBorderRadius,
    border: Border.all(color: dividerColor),
  );
  
  // Text styles
  static TextStyle get headingLarge => const TextStyle(
    fontSize: 28,
    fontWeight: FontWeight.bold,
    color: textPrimaryColor,
  );
  
  static TextStyle get headingMedium => const TextStyle(
    fontSize: 22,
    fontWeight: FontWeight.bold,
    color: textPrimaryColor,
  );
  
  static TextStyle get headingSmall => const TextStyle(
    fontSize: 18,
    fontWeight: FontWeight.bold,
    color: textPrimaryColor,
  );
  
  static TextStyle get subtitleLarge => const TextStyle(
    fontSize: 16,
    fontWeight: FontWeight.w500,
    color: textSecondaryColor,
  );
  
  static TextStyle get subtitleMedium => const TextStyle(
    fontSize: 14,
    fontWeight: FontWeight.w500,
    color: textSecondaryColor,
  );
  
  static TextStyle get bodyLarge => const TextStyle(
    fontSize: 16,
    color: textPrimaryColor,
  );
  
  static TextStyle get bodyMedium => const TextStyle(
    fontSize: 14,
    color: textPrimaryColor,
  );
  
  static TextStyle get bodySmall => const TextStyle(
    fontSize: 12,
    color: textSecondaryColor,
  );
  
  static TextStyle get buttonText => const TextStyle(
    fontSize: 16,
    fontWeight: FontWeight.w600,
    color: textLightColor,
  );
  
  static TextStyle get statusText => TextStyle(
    fontSize: 18,
    fontWeight: FontWeight.bold,
    color: primaryColor,
  );
  
  static TextStyle get bannerText => TextStyle(
    fontSize: 24,
    fontWeight: FontWeight.bold,
    color: textLightColor,
  );
  
  // Theme data
  static ThemeData get themeData => ThemeData(
    useMaterial3: true,
    primaryColor: primaryColor,
    scaffoldBackgroundColor: backgroundColor,
    
    colorScheme: ColorScheme.light(
      primary: primaryColor,
      secondary: secondaryColor,
      surface: surfaceColor,
      background: backgroundColor,
      error: errorColor,
      onPrimary: textLightColor,
      onSecondary: textLightColor,
      onSurface: textPrimaryColor,
      onBackground: textPrimaryColor,
      onError: textLightColor,
    ),
    
    // AppBar theme
    appBarTheme: AppBarTheme(
      backgroundColor: textPrimaryColor,
      foregroundColor: backgroundColor,
      elevation: 0,
      iconTheme: IconThemeData(color: textPrimaryColor),
      titleTextStyle: headingSmall,
    ),
    
    // Card theme
    cardTheme: CardTheme(
      color: cardColor,
      elevation: elevationSmall,
      shape: RoundedRectangleBorder(
        borderRadius: mediumBorderRadius,
      ),
    ),
    
    // Button themes
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: primaryColor,
        foregroundColor: textLightColor,
        shape: RoundedRectangleBorder(
          borderRadius: smallBorderRadius,
        ),
        padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
        textStyle: buttonText,
      ),
    ),
    
    textButtonTheme: TextButtonThemeData(
      style: TextButton.styleFrom(
        foregroundColor: primaryColor,
        shape: RoundedRectangleBorder(
          borderRadius: smallBorderRadius,
        ),
        textStyle: TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.w600,
        ),
      ),
    ),
    
    // Input decoration
    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: surfaceColor,
      contentPadding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
      border: OutlineInputBorder(
        borderRadius: smallBorderRadius,
        borderSide: BorderSide.none,
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: smallBorderRadius,
        borderSide: BorderSide.none,
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: smallBorderRadius,
        borderSide: BorderSide(color: primaryColor, width: 1.5),
      ),
      labelStyle: TextStyle(color: textSecondaryColor),
      hintStyle: TextStyle(color: textSecondaryColor.withOpacity(0.7)),
    ),
    
    // Bottom navigation bar
    bottomNavigationBarTheme: BottomNavigationBarThemeData(
      backgroundColor: backgroundColor,
      selectedItemColor: primaryColor,
      unselectedItemColor: disabledColor,
      selectedLabelStyle: TextStyle(fontSize: 12, fontWeight: FontWeight.w500),
      unselectedLabelStyle: TextStyle(fontSize: 12),
      elevation: 8,
    ),
    
    // Divider
    dividerTheme: DividerThemeData(
      color: dividerColor,
      thickness: 1,
      space: 1,
    ),
    
    // Icon theme
    iconTheme: IconThemeData(
      color: primaryColor,
      size: 24,
    ),
  );
  
  // Helper methods for common widgets
  
  // Primary button
  static Widget createPrimaryButton({
    required String text,
    required VoidCallback onPressed,
    bool isFullWidth = true,
    double? height, 
  }) {
    return SizedBox(
      width: isFullWidth ? double.infinity : null,
      height: height ?? 48,
      child: ElevatedButton(
        onPressed: onPressed,
        child: Text(text),
      ),
    );
  }
  
  // Status card
  static Widget createStatusCard(String title, String status) {
    return Container(
      width: 200,
      decoration: statusCardDecoration,
      padding: const EdgeInsets.all(paddingMedium),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            title,
            style: subtitleMedium,
          ),
          const SizedBox(height: paddingSmall),
          Text(
            status,
            style: statusText,
          ),
        ],
      ),
    );
  }
  
  // Event card
  static Widget createEventCard({
    required String bannerText,
    required String title,
    required String date,
    required String location,
    required List<Color> gradientColors,
    IconData icon = Icons.medical_services,
  }) {
    return Container(
      width: double.infinity,
      decoration: cardDecoration,
      clipBehavior: Clip.antiAlias,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Banner with gradient
          Container(
            height: 80,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: gradientColors,
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
            ),
            child: Center(
              child: Padding(
                padding: const EdgeInsets.all(paddingMedium),
                child: Row(
                  children: [
                    Icon(
                      icon,
                      color: textLightColor,
                      size: 32,
                    ),
                    SizedBox(width: paddingSmall),
                    Text(
                      bannerText,
                      style: MedicalTheme.bannerText,
                    ),
                  ],
                ),
              ),
            ),
          ),
          // Event details
          Padding(
            padding: const EdgeInsets.all(paddingMedium),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: headingSmall,
                ),
                SizedBox(height: paddingSmall),
                Text(
                  date,
                  style: subtitleMedium,
                ),
                SizedBox(height: 4),
                Text(
                  location,
                  style: subtitleMedium,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}