import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart'; // المكتبة المسؤولة عن تشغيل الفيديو

// --- شاشة مشغل الفيديو ---
// ملاحظة: استخدمنا StatefulWidget لأن حالة الفيديو (تشغيل، إيقاف، تقدم زمن) تتغير باستمرار.
class VideoPlayerScreen extends StatefulWidget {
  const VideoPlayerScreen({super.key});

  @override
  State<VideoPlayerScreen> createState() => _VideoPlayerScreenState();
}

class _VideoPlayerScreenState extends State<VideoPlayerScreen> {
  late VideoPlayerController _controller; // تعريف المتحكم في الفيديو

  @override
  void initState() {
    super.initState();
    // 1. ربط ملف الفيديو الموجود في المجلد المحلي (Assets)
    _controller = VideoPlayerController.asset('assets/jordan_tourism.mp4')
      ..initialize().then((_) {
        // تأكدنا من جاهزية الفيديو، فنقوم بتحديث الواجهة لعرض أول إطار
        setState(() {});
      });
  }

  @override
  void dispose() {
    // 2. إدارة الذاكرة: يجب إغلاق المشغل عند الخروج من الشاشة لمنع استهلاك موارد الجهاز والبطارية
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor:
          Colors.black, // خلفية سوداء لتركيز نظر المستخدم على الفيديو فقط
      appBar: AppBar(
        title: const Text("الخروج من الفيديو "),
        backgroundColor: Colors.black,
        foregroundColor: Colors.white,
      ),
      body: Center(
        // فحص: هل الفيديو جاهز للعرض؟
        child: _controller.value.isInitialized
            ? Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // أداة لعرض الفيديو بنفس أبعاده الأصلية (عرض : طول)
                  AspectRatio(
                    aspectRatio: _controller.value.aspectRatio,
                    child: VideoPlayer(_controller),
                  ),

                  const SizedBox(height: 20),

                  // شريط التقدم: يسمح للمستخدم برؤية الوقت المتبقي والتقديم باللمس (Scrubbing)
                  VideoProgressIndicator(_controller,
                      allowScrubbing: true, // تفعيل ميزة السحب للتقديم والتأخير
                      colors: const VideoProgressColors(
                          playedColor: Colors.red, // لون الجزء الذي تم تشغيله
                          bufferedColor: Colors.grey)), // لون الجزء المحمل

                  const SizedBox(height: 20),

                  // صف أزرار التحكم
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      // زر الرجوع للخلف 10 ثوانٍ
                      IconButton(
                        icon: const Icon(Icons.replay_10,
                            color: Colors.white, size: 40),
                        onPressed: () {
                          _controller.seekTo(_controller.value.position -
                              const Duration(seconds: 10));
                        },
                      ),

                      const SizedBox(width: 20),

                      // زر التشغيل والإيقاف المؤقت
                      CircleAvatar(
                        radius: 35,
                        backgroundColor: Colors.red,
                        child: IconButton(
                          icon: Icon(
                            _controller.value.isPlaying
                                ? Icons.pause
                                : Icons.play_arrow,
                            color: Colors.white,
                            size: 40,
                          ),
                          onPressed: () {
                            // تغيير حالة الفيديو (Play/Pause) وتحديث شكل الزر
                            setState(() {
                              _controller.value.isPlaying
                                  ? _controller.pause()
                                  : _controller.play();
                            });
                          },
                        ),
                      ),

                      const SizedBox(width: 20),

                      // زر التقديم للأمام 10 ثوانٍ
                      IconButton(
                        icon: const Icon(Icons.forward_10,
                            color: Colors.white, size: 40),
                        onPressed: () {
                          _controller.seekTo(_controller.value.position +
                              const Duration(seconds: 10));
                        },
                      ),
                    ],
                  ),
                ],
              )
            : const CircularProgressIndicator(
                color: Colors.red), // تظهر دائرة التحميل حتى يجهز الفيديو
      ),
    );
  }
}
