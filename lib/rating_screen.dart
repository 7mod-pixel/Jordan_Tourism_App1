import 'package:flutter/material.dart';
import 'package:audioplayers/audioplayers.dart'; // مكتبة تشغيل الأصوات

// --- صفحة التقييم (RatingScreen) ---
// ملاحظة: استخدمنا StatefulWidget لأن الصفحة تتغير قيمتها (النجوم) عند تحريك المستخدم للمؤشر.
class RatingScreen extends StatefulWidget {
  const RatingScreen({super.key});
  @override
  State<RatingScreen> createState() => _RatingScreenState();
}

class _RatingScreenState extends State<RatingScreen> {
  double _rating = 3.0; // القيمة الافتراضية للتقييم (3 نجوم)
  final _player = AudioPlayer(); // إنشاء كائن لتشغيل الملفات الصوتية

  // ميثود (وظيفة) الإرسال عند الضغط على الزر
  void _submit() async {
    // إذا كان التقييم 4 نجوم أو أكثر (تقييم ممتاز)
    if (_rating >= 4) {
      // تشغيل صوت "تصفيق" من ملفات الأصول (Assets)
      await _player.play(AssetSource('clapping.mp3'));
      _showMessage(
          "شكراً جزيلاً! 😍\nيسعدنا جداً أن التطبيق نال إعجابك، أهلاً بك في الأردن!");
    } else {
      // إذا كان التقييم أقل من 4، تظهر رسالة شكر عادية بدون صوت تصفيق
      _showMessage(
          "شكراً لك! 🌸\nنقدّر ملاحظتك وسنعمل بجد لتطوير التطبيق ليكون أفضل في المرة القادمة.");
    }
  }

  // ميثود لإظهار نافذة منبثقة (Dialog) بالرسالة
  void _showMessage(String msg) {
    showDialog(
      context: context,
      builder: (c) => AlertDialog(
        content: Text(msg,
            textAlign: TextAlign.center, style: const TextStyle(fontSize: 18)),
        actions: [
          TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text("حسناً"))
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("تقييم التطبيق")),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center, // توسيط العناصر عمودياً
          children: [
            const Text("كيف كانت تجربتك معنا؟", style: TextStyle(fontSize: 22)),

            // أداة الاختيار المنزلقة (Slider)
            Slider(
              value: _rating, // القيمة الحالية
              min: 1, // أقل قيمة (نجمة واحدة)
              max: 5, // أعلى قيمة (5 نجوم)
              divisions: 4, // تقسيم المسافة لـ 4 أجزاء (1, 2, 3, 4, 5)
              label: _rating
                  .round()
                  .toString(), // يظهر الرقم فوق المؤشر أثناء التحريك
              onChanged: (v) =>
                  setState(() => _rating = v), // تحديث الواجهة عند التحريك
            ),

            // نص يعرض عدد النجوم المختار حالياً
            Text("${_rating.toInt()} نجوم",
                style:
                    const TextStyle(fontSize: 30, fontWeight: FontWeight.bold)),

            const SizedBox(height: 30),

            // زر إرسال التقييم
            ElevatedButton(
                onPressed: _submit, child: const Text("إرسال التقييم")),
          ],
        ),
      ),
    );
  }
}
