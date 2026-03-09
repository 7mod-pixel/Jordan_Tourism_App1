import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart'; // مكتبة لفتح الروابط الخارجية مثل الخرائط
import 'data/models.dart';

// --- شاشة تفاصيل المعلم السياحي ---
// ملاحظة: StatelessWidget لأنها تستقبل بيانات المعلم وتعرضها فقط ولا يتغير محتواها داخلياً.
class SiteDetailsScreen extends StatelessWidget {
  final TourismSite
      site; // كائن يحتوي على بيانات الموقع (الاسم، الصورة، الوصف...)
  const SiteDetailsScreen({super.key, required this.site});

  // ميثود (وظيفة) لفتح موقع المعلم في تطبيق خرائط جوجل
  Future<void> _launchMap() async {
    // تشفير اسم المعلم ليتم استخدامه كـ رابط بحث (Query) في جوجل
    // ignore: prefer_interpolation_to_compose_strings
    final String query = Uri.encodeComponent(site.nameAr + " الأردن");
    final Uri googleMapsUrl =
        Uri.parse("https://www.google.com/maps/search/?api=1&query=$query");

    // التحقق إذا كان الجهاز قادراً على فتح الرابط (وجود تطبيق خرائط أو متصفح)
    if (await canLaunchUrl(googleMapsUrl)) {
      await launchUrl(googleMapsUrl, mode: LaunchMode.externalApplication);
    } else {
      throw 'تعذر فتح الخريطة حالياً';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(
        // ملاحظة: استخدمنا هذا النوع لتنفيذ تأثير الـ Sliver (التمدد والتقلص)
        slivers: [
          // 1. رأس الصفحة التفاعلي (صورة المعلم التي تتقلص عند رفع الشاشة)
          SliverAppBar(
            expandedHeight: 350, // طول الصورة عند فتح الصفحة
            pinned: true, // يبقى شريط العنوان ظاهراً في الأعلى حتى بعد السكرول
            backgroundColor: const Color(0xFF8B0000),
            flexibleSpace: FlexibleSpaceBar(
              title: Text(site.nameAr,
                  style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                      shadows: [Shadow(blurRadius: 10, color: Colors.black)])),
              background: Hero(
                tag: site
                    .nameAr, // نفس الـ Tag الموجود في الشاشة الرئيسية لعمل انتقال سلس
                child: Image.asset(site.imageUrl, fit: BoxFit.cover),
              ),
            ),
          ),

          // 2. محتوى تفاصيل المعلم (النصوص والمعلومات)
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.end, // محاذاة لليمين
                children: [
                  // بطاقة صغيرة لعرض تصنيف المعلم (تاريخي، طبيعي...)
                  Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                    decoration: BoxDecoration(
                      // ignore: deprecated_member_use
                      color: const Color(0xFFC5A059).withOpacity(0.2),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Text(site.category,
                        style: const TextStyle(
                            color: Color(0xFF8B0000),
                            fontWeight: FontWeight.bold)),
                  ),

                  const SizedBox(height: 20),

                  // نص "حول المعلم"
                  const Text("حول المعلم",
                      style:
                          TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 10),
                  // عرض الوصف الكامل للموقع
                  Text(site.description,
                      textAlign: TextAlign.right,
                      style: const TextStyle(
                          fontSize: 18, height: 1.7, color: Colors.black87)),

                  const SizedBox(height: 35),

                  // 3. صندوق الخريطة التفاعلي
                  const Text("الموقع الجغرافي",
                      style:
                          TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 15),

                  // عند الضغط على هذا الصندوق، يتم استدعاء ميثود الخرائط
                  GestureDetector(
                    onTap: _launchMap,
                    child: Container(
                      padding: const EdgeInsets.all(20),
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          // تدرج لوني يعطي طابع الخريطة
                          colors: [Colors.blue.shade900, Colors.blue.shade600],
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                        ),
                        borderRadius: BorderRadius.circular(25),
                        boxShadow: [
                          BoxShadow(
                            // ignore: deprecated_member_use
                            color: Colors.blue.withOpacity(0.3),
                            blurRadius: 15,
                            offset: const Offset(0, 8),
                          )
                        ],
                      ),
                      child: Row(
                        children: [
                          const Icon(Icons.directions,
                              color: Colors.white, size: 40),
                          const SizedBox(width: 15),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Text("الانتقال إلى خرائط جوجل",
                                    style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 18,
                                        fontWeight: FontWeight.bold)),
                                Text(
                                    site.location, // عرض اسم المحافظة أو الموقع
                                    style: const TextStyle(
                                        color: Colors.white70, fontSize: 14)),
                              ],
                            ),
                          ),
                          const Icon(Icons.arrow_forward_ios,
                              color: Colors.white, size: 18),
                        ],
                      ),
                    ),
                  ),

                  const SizedBox(height: 40),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
