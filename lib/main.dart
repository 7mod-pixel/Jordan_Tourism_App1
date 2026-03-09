import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart'; // المكتبة التي أضفناها للـ pubspec
import 'home_screen.dart';

void main() {
  // كود إضافي للتأكد من استقرار تشغيل الفيديو والصوت
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const JordanTourismApp());
}

class JordanTourismApp extends StatelessWidget {
  const JordanTourismApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'اكتشف الأردن',

      // إعدادات الثيم الاحترافي
      theme: ThemeData(
        useMaterial3: true, // تفعيل ديزاين جوجل الأحدث

        // تطبيق خط "Cairo" على كل نصوص التطبيق تلقائياً
        textTheme: GoogleFonts.cairoTextTheme(
          Theme.of(context).textTheme,
        ),

        // تنسيق الألوان الاحترافي (براند سياحي)
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFF8B0000), // العنابي الملكي
          primary: const Color(0xFF8B0000),
          secondary: const Color(0xFFC5A059), // الذهبي الرملي (لون البترا)
          surface: Colors.white,
        ),

        // تحسين شكل الأزرار في كل التطبيق لتكون بحواف دائرية
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
            padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 20),
          ),
        ),

        // تحسين شكل الـ AppBar
        appBarTheme: AppBarTheme(
          centerTitle: true,
          backgroundColor: const Color(0xFF8B0000),
          foregroundColor: Colors.white,
          titleTextStyle: GoogleFonts.cairo(
            fontSize: 22,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
      ),

      home: const HomeScreen(),
    );
  }
}
