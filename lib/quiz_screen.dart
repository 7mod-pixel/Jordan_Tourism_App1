import 'package:flutter/material.dart';
import 'package:audioplayers/audioplayers.dart';
import 'data/questions.dart';

class QuizScreen extends StatefulWidget {
  const QuizScreen({super.key});

  @override
  State<QuizScreen> createState() => _QuizScreenState();
}

class _QuizScreenState extends State<QuizScreen> {
  int _idx = 0;
  int _score = 0;
  final _player = AudioPlayer();

  // دالة التحقق من الإجابة
  void _check(int selected) async {
    if (selected == quizQuestions[_idx].correctIndex) {
      _score++;
      await _player.play(AssetSource('success.mp3'));
    } else {
      await _player.play(AssetSource('fail.mp3'));
    }

    setState(() {
      if (_idx < quizQuestions.length - 1) {
        _idx++;
      } else {
        _showResult();
      }
    });
  }

  // دالة إظهار النتيجة النهائية
  void _showResult() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (c) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: const Text("انتهى الاختبار! 🎉", textAlign: TextAlign.center),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text("نتيجتك هي: $_score من ${quizQuestions.length}",
                style:
                    const TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
            const SizedBox(height: 10),
            Text(
                _score >= 7
                    ? "أنت خبير في سياحة الأردن! 🇯🇴"
                    : "محاولة جيدة، استمر في التعلم! ✨",
                textAlign: TextAlign.center),
          ],
        ),
        actions: [
          Center(
            child: ElevatedButton(
              onPressed: () {
                Navigator.pop(context); // إغلاق الحوار
                Navigator.pop(context); // العودة للرئيسية
              },
              child: const Text("العودة للقائمة الرئيسية"),
            ),
          )
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    var q = quizQuestions[_idx];

    return Scaffold(
      appBar: AppBar(
        title: const Text("تحدي المعلومات"),
        centerTitle: true,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        // أفضل من ListView هنا لتجنب أخطاء الـ Generate
        child: Column(
          children: [
            // شريط التقدم العلوي
            LinearProgressIndicator(
              value: (_idx + 1) / quizQuestions.length,
              color: const Color(0xFF8B0000), // أحمر ملكي
              backgroundColor: Colors.grey[300],
              minHeight: 8,
            ),
            const SizedBox(height: 30),

            // رقم السؤال
            Text("السؤال ${_idx + 1} / ${quizQuestions.length}",
                style: const TextStyle(fontSize: 16, color: Colors.grey)),

            const SizedBox(height: 20),

            // نص السؤال داخل بطاقة
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(15),
                  // ignore: prefer_const_literals_to_create_immutables, prefer_const_constructors
                  boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 10)],
                ),
                child: Text(
                  q.text,
                  style: const TextStyle(
                      fontSize: 20, fontWeight: FontWeight.bold),
                  textAlign: TextAlign.center,
                ),
              ),
            ),

            const SizedBox(height: 40),

            // خيارات الإجابة
            ...List.generate(
              q.options.length,
              (i) => Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 25, vertical: 10),
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.white,
                    foregroundColor: Colors.black87,
                    minimumSize: const Size(double.infinity, 60),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15),
                      side:
                          const BorderSide(color: Color(0xFF8B0000), width: 1),
                    ),
                    elevation: 2,
                  ),
                  onPressed: () => _check(i),
                  child:
                      Text(q.options[i], style: const TextStyle(fontSize: 18)),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
