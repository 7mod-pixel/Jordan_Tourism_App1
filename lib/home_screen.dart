// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import 'data/models.dart';
import 'site_details_screen.dart';
import 'quiz_screen.dart';
import 'rating_screen.dart';
import 'video_player_screen.dart';

// --- الشاشة الرئيسية (HomeScreen) ---
// الملاحظة: هي الشاشة الأساسية (StatefulWidget) لأنها تحتوي على قائمة تنقل تغير محتوى الشاشة
class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  // متغير لتحديد رقم الصفحة الحالية (Index)
  int _selectedIndex = 0;

  // قائمة تحتوي على الصفحات الخمسة (Widgets) المرتبطة بشريط التنقل
  final List<Widget> _pages = [
    const MainContent(), // صفحة المعالم السياحية
    const DictionaryPage(), // صفحة الكلمات الأردنية
    const FoodPage(), // صفحة الأكلات الشعبية
    const QuizPageWithTransition(), // صفحة الاختبار
    const RatingScreen(), // صفحة التقييم والنجوم
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // عرض الصفحة بناءً على الرقم المختار من القائمة السفلى
      body: _pages[_selectedIndex],
      // شريط التنقل السفلي
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex, // الرقم الحالي النشط
        onTap: (index) =>
            setState(() => _selectedIndex = index), // تحديث الحالة عند الضغط
        type: BottomNavigationBarType.fixed, // ثبات الأيقونات في مكانها
        selectedItemColor:
            const Color(0xFF8B0000), // لون الأيقونة المختارة (أحمر ملكي)
        unselectedItemColor: Colors.grey, // لون الأيقونات غير النشطة
        selectedFontSize: 12,
        unselectedFontSize: 10,
        // العناصر (الأيقونات) الموجودة في الشريط السفلي
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: "الرئيسية"),
          BottomNavigationBarItem(
              icon: Icon(Icons.translate), label: "قاموسنا"),
          BottomNavigationBarItem(
              icon: Icon(Icons.restaurant_menu), label: "أكلاتنا"),
          BottomNavigationBarItem(icon: Icon(Icons.quiz), label: "الاختبار"),
          BottomNavigationBarItem(icon: Icon(Icons.star), label: "التقييم"),
        ],
      ),
    );
  }
}

// --- 1. محتوى الرئيسية (المعالم + النصائح) ---
// ملاحظة: Stateless لأن المحتوى ثابت ويعرض بيانات من القائمة فقط
class MainContent extends StatelessWidget {
  const MainContent({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.end, // محاذاة لليمين (عربي)
        children: [
          _buildHeader(context), // جزء الترحيب وفيديو البترا
          _buildTravelTipsSection(), // جزء نصائح السفر (الأفقي)
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 20, vertical: 15),
            child: Text("أشهر الوجهات السياحية",
                style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
          ),
          // تحويل قائمة المواقع السياحية (jordanSites) إلى بطاقات (Cards) وعرضها
          // ignore: unnecessary_to_list_in_spreads
          ...jordanSites.map((site) => _buildSiteCard(context, site)).toList(),
          const SizedBox(height: 30),
        ],
      ),
    );
  }

  // ميثود لبناء رأس الصفحة (Header) مع زر تشغيل الفيديو
  Widget _buildHeader(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.only(top: 60, bottom: 30, right: 20, left: 20),
      decoration: const BoxDecoration(
        color: Color(0xFF8B0000),
        borderRadius: BorderRadius.vertical(bottom: Radius.circular(30)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          const Text("مرحباً بك في الأردن",
              style: TextStyle(
                  color: Colors.white,
                  fontSize: 26,
                  fontWeight: FontWeight.bold)),
          const SizedBox(height: 20),
          GestureDetector(
            onTap: () => Navigator.push(context,
                MaterialPageRoute(builder: (c) => const VideoPlayerScreen())),
            child: Container(
              height: 150,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20),
                image: const DecorationImage(
                    image: AssetImage('assets/images/petra.jpg'),
                    fit: BoxFit.cover,
                    opacity: 0.7),
              ),
              child: const Center(
                  child: Icon(Icons.play_circle_fill,
                      color: Colors.white, size: 60)),
            ),
          ),
        ],
      ),
    );
  }

  // ميثود لبناء قسم النصائح الذي يتحرك بشكل أفقي (Horizontal ListView)
  Widget _buildTravelTipsSection() {
    final List<Map<String, dynamic>> tips = [
      {"icon": Icons.wb_sunny, "text": "زر البترا باكراً لتجنب الحرارة"},
      {"icon": Icons.water_drop, "text": "اشرب الكثير من الماء في وادي رم"},
      {
        "icon": Icons.directions_car,
        "text": "تطبيقات النقل الذكية هي الأفضل في عمان"
      },
    ];

    return Container(
      margin: const EdgeInsets.only(top: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          const Padding(
            padding: EdgeInsets.only(right: 20, bottom: 10),
            child: Text("نصائح تهمك 💡",
                style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFFC5A059))),
          ),
          SizedBox(
            height: 100,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              reverse: true, // لتبدأ القائمة من اليمين
              itemCount: tips.length,
              itemBuilder: (context, index) => Container(
                width: 200,
                margin: const EdgeInsets.only(right: 20),
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(15),
                  boxShadow: [
                    BoxShadow(
                        color: Colors.black.withOpacity(0.05), blurRadius: 5)
                  ],
                ),
                child: Row(
                  children: [
                    Expanded(
                        child: Text(tips[index]['text'],
                            textAlign: TextAlign.right,
                            style: const TextStyle(fontSize: 13))),
                    const SizedBox(width: 10),
                    Icon(tips[index]['icon'], color: const Color(0xFFC5A059)),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ميثود لبناء بطاقة (Card) لكل موقع سياحي (البترا، جرش، إلخ)
  Widget _buildSiteCard(BuildContext context, TourismSite site) {
    return GestureDetector(
      onTap: () => Navigator.push(context,
          MaterialPageRoute(builder: (c) => SiteDetailsScreen(site: site))),
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(20),
            // ignore: prefer_const_literals_to_create_immutables
            boxShadow: [
              const BoxShadow(color: Colors.black12, blurRadius: 10)
            ]),
        child: Column(
          children: [
            Hero(
                tag: site.nameAr, // تأثير حركة الصورة بين الشاشات
                child: ClipRRect(
                    borderRadius:
                        const BorderRadius.vertical(top: Radius.circular(20)),
                    child: Image.asset(site.imageUrl,
                        height: 180,
                        width: double.infinity,
                        fit: BoxFit.cover))),
            ListTile(
              title: Text(site.nameAr,
                  textAlign: TextAlign.right,
                  style: const TextStyle(fontWeight: FontWeight.bold)),
              subtitle: Text(site.category, textAlign: TextAlign.right),
              leading: const Icon(Icons.arrow_back_ios, size: 14),
            ),
          ],
        ),
      ),
    );
  }
}

// --- 2. صفحة القاموس الأردني ---
// ملاحظة: تعرض كلمات شعبية ومعانيها في قائمة بسيطة
class DictionaryPage extends StatelessWidget {
  const DictionaryPage({super.key});

  @override
  Widget build(BuildContext context) {
    final List<Map<String, String>> phrases = [
      {"word": "هلا بالنشامى", "mean": "ترحيب أردني حار بالأصدقاء"},
      {"word": "على راسي", "mean": "تعبير عن الاحترام الشديد"},
      {"word": "حيالله", "mean": "تحية ترحيبية أصيلة"},
      {"word": "منور", "mean": "تقال للضيف العزيز"},
      {"word": "يزم", "mean": "يا زلمة (لفت انتباه)"},
      {"word": "وحد الله", "mean": "لتهدئة الشخص أو التعجب"},
      {"word": "خاوه", "mean": "تعبير عن الإصرار"},
    ];

    return Scaffold(
      appBar: AppBar(
          title: const Text("قاموس اللهجة 🇯🇴"),
          backgroundColor: const Color(0xFF8B0000),
          foregroundColor: Colors.white,
          centerTitle: true),
      body: ListView.builder(
        itemCount: phrases.length,
        itemBuilder: (context, index) => Card(
          margin: const EdgeInsets.symmetric(horizontal: 15, vertical: 8),
          child: ListTile(
            title: Text(phrases[index]['word']!,
                textAlign: TextAlign.right,
                style: const TextStyle(
                    fontWeight: FontWeight.bold, color: Color(0xFF8B0000))),
            subtitle: Text(phrases[index]['mean']!, textAlign: TextAlign.right),
          ),
        ),
      ),
    );
  }
}

// --- 3. صفحة أكلات نشمية ---
// ملاحظة: تعرض الأكلات الستة (المنسف، المقلوبة، إلخ) مع صورها ووصفها
class FoodPage extends StatelessWidget {
  const FoodPage({super.key});

  @override
  Widget build(BuildContext context) {
    final List<Map<String, String>> foods = [
      {
        "name": "المنسف",
        "desc": "سيد المائدة الأردنية، يُقدم مع اللحم والجميد الكركي الأصيل.",
        "img": "assets/images/mansaf.jpg"
      },
      {
        "name": "المقلوبة",
        "desc": "أكلة شعبية غنية بالدجاج والخضار المقلية والأرز المتبل.",
        "img": "assets/images/maklouba.jpg"
      },
      {
        "name": "المسخن",
        "desc":
            "خبز الطابون مع الدجاج المحمر والبصل والسماق البلدي وزيت الزيتون.",
        "img": "assets/images/musakhan.jpg"
      },
      {
        "name": "الدوالي (ورق العنب)",
        "desc": "ورق عنب محشو بالأرز واللحم، أكلة بيتية لا يُعلى عليها.",
        "img": "assets/images/dawali.jpg"
      },
      {
        "name": "المطابق",
        "desc": "أكلة تراثية من الطحين والبصل وزيت الزيتون، مشهورة في الأرياف.",
        "img": "assets/images/matabaq.jpg"
      },
      {
        "name": "الملوخية",
        "desc": "تُقدم على الطريقة الأردنية مع الدجاج والأرز والليمون.",
        "img": "assets/images/mulukhiya.jpg"
      },
    ];

    return Scaffold(
      appBar: AppBar(
          title: const Text("أكلات نشمية 🥘"),
          backgroundColor: const Color(0xFF8B0000),
          foregroundColor: Colors.white,
          centerTitle: true),
      body: ListView.builder(
        itemCount: foods.length,
        itemBuilder: (context, index) => Container(
          margin: const EdgeInsets.all(15),
          decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(20),
              // ignore: prefer_const_literals_to_create_immutables
              boxShadow: [
                const BoxShadow(color: Colors.black12, blurRadius: 10)
              ]),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              ClipRRect(
                  borderRadius:
                      const BorderRadius.vertical(top: Radius.circular(20)),
                  child: Image.asset(foods[index]['img']!,
                      height: 180, width: double.infinity, fit: BoxFit.cover)),
              Padding(
                padding: const EdgeInsets.all(15),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(foods[index]['name']!,
                        style: const TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF8B0000))),
                    const SizedBox(height: 5),
                    Text(foods[index]['desc']!,
                        textAlign: TextAlign.right,
                        style:
                            const TextStyle(color: Colors.grey, fontSize: 14)),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// --- 4. صفحة بوابة الاختبار ---
// ملاحظة: تتحكم في الانتقال لشاشة الاختبار وعرض حالة "الاكتمال"
class QuizPageWithTransition extends StatefulWidget {
  const QuizPageWithTransition({super.key});
  @override
  State<QuizPageWithTransition> createState() => _QuizPageWithTransitionState();
}

class _QuizPageWithTransitionState extends State<QuizPageWithTransition> {
  bool _finished = false; // متغير لحفظ حالة انتهاء الاختبار
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          title: const Text("اختبر نفسك"),
          backgroundColor: const Color(0xFF8B0000),
          foregroundColor: Colors.white),
      body: Center(
        child: _finished
            ? Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.check_circle, size: 80, color: Colors.green),
                  const Text("اكتمل الاختبار بنجاح!",
                      style: TextStyle(fontSize: 20)),
                  const SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: () => Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (c) => const RatingScreen())),
                    style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFFC5A059)),
                    child: const Text("قيم تجربة التطبيق",
                        style: TextStyle(color: Colors.white)),
                  ),
                ],
              )
            : ElevatedButton(
                onPressed: () => Navigator.push(context,
                        MaterialPageRoute(builder: (c) => const QuizScreen()))
                    .then((_) => setState(() => _finished =
                        true)), // تحديث الحالة عند الرجوع من الاختبار
                style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF8B0000)),
                child: const Text("ابدأ الاختبار",
                    style: TextStyle(color: Colors.white)),
              ),
      ),
    );
  }
}
