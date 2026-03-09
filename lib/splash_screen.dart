import 'package:flutter/material.dart';
import 'home_screen.dart';

// --- شاشة الترحيب (SplashScreen) ---
// ملاحظة: استخدمنا StatefulWidget لأننا نحتاج لتنفيذ كود (مؤقت زمني) بمجرد تشغيل الشاشة.
class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});
  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  // ميثود initState تُنفذ مرة واحدة فقط عند تشغيل الشاشة لأول مرة
  @override
  void initState() {
    super.initState();

    // إعداد مؤقت زمني (Timer) للانتقال التلقائي
    // بعد مرور 3 ثوانٍ، سيتم تنفيذ الكود داخل القوسين
    Future.delayed(const Duration(seconds: 3), () {
      // استخدام pushReplacement بدلاً من push لكي لا يستطيع المستخدم العودة لشاشة الترحيب مرة أخرى بالضغط على زر الرجوع
      Navigator.pushReplacement(
          // ignore: use_build_context_synchronously
          context,
          MaterialPageRoute(builder: (c) => const HomeScreen()));
    });
  }

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      backgroundColor: Color(0xFF8B0000), // اللون الأحمر الملكي الموحد للتطبيق
      body: Center(
        child: Column(
          mainAxisAlignment:
              MainAxisAlignment.center, // توسيط المحتوى في منتصف الشاشة
          children: [
            // أيقونة تعبر عن السفر والاستكشاف
            Icon(Icons.travel_explore, size: 100, color: Colors.white),

            SizedBox(height: 20),

            // نص الترحيب
            Text("أهلاً بكم في الأردن",
                style: TextStyle(
                    color: Colors.white,
                    fontSize: 24,
                    fontWeight: FontWeight.bold)),

            SizedBox(height: 10),

            // مؤشر تحميل دائري يعطي انطباعاً بأن التطبيق يتم تجهيزه
            CircularProgressIndicator(color: Colors.white),
          ],
        ),
      ),
    );
  }
}
