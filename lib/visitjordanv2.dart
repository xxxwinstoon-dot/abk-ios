import 'package:flutter/material.dart'; // استيراد مكتبة الواجهات الأساسية
import 'package:video_player/video_player.dart'; // مكتبة تشغيل الفيديو
import 'package:audioplayers/audioplayers.dart'; // مكتبة تشغيل الأصوات
import 'package:flutter_localizations/flutter_localizations.dart'; // مكتبة دعم اللغات والاتجاهات

void main() => runApp(const JordanTourismApp()); // نقطة انطلاق التطبيق

class JordanTourismApp extends StatelessWidget {
  const JordanTourismApp({super.key});
  @override
  Widget build(BuildContext context) => MaterialApp(
    title: 'سياحة الأردن', 
    debugShowCheckedModeBanner: false, // إخفاء علامة التصحيح المائية
    localizationsDelegates: const [
      GlobalMaterialLocalizations.delegate,
      GlobalWidgetsLocalizations.delegate,
      GlobalCupertinoLocalizations.delegate
    ], // تعريف مندوبي الترجمة للواجهات
    supportedLocales: const [Locale('ar', 'AE')], // تحديد اللغات المدعومة (العربية)
    locale: const Locale('ar', 'AE'), // ضبط لغة التطبيق الافتراضية
    theme: ThemeData(
      colorScheme: ColorScheme.fromSeed(seedColor: const Color(0xFFCE1126)), // لون أساسي مستوحى من علم الأردن
      useMaterial3: true, // تفعيل تصميم Material 3 الحديث
      fontFamily: 'Arial' // تحديد الخط المستخدم
    ),
    home: const MainNavigationScreen()); // الشاشة الافتتاحية عند التشغيل
}

class MainNavigationScreen extends StatefulWidget {
  const MainNavigationScreen({super.key});
  @override State<MainNavigationScreen> createState() => _MainNavigationScreenState();
}

class _MainNavigationScreenState extends State<MainNavigationScreen> {
  int _currentIndex = 0; // متغير لتتبع رقم الصفحة النشطة
  final List<Widget> _pages = [
    const WelcomeScreen(), 
    const TourismSitesScreen(), 
    const InteractiveQuizScreen(), 
    const AppRatingScreen()
  ]; // قائمة الصفحات الرئيسية في التطبيق

  @override
  Widget build(BuildContext context) => Scaffold(
    body: IndexedStack(index: _currentIndex, children: _pages), // عرض الصفحة مع حفظ حالتها عند التنقل
    bottomNavigationBar: BottomNavigationBar(
      currentIndex: _currentIndex, // تحديد الأيقونة النشطة حالياً
      type: BottomNavigationBarType.fixed, // تثبيت حجم الأيقونات
      selectedItemColor: const Color(0xFFCE1126), // لون الأيقونة المختارة
      onTap: (index) => setState(() => _currentIndex = index), // تحديث الواجهة عند الضغط على زر
      items: const [
        BottomNavigationBarItem(icon: Icon(Icons.home), label: 'الرئيسية'),
        BottomNavigationBarItem(icon: Icon(Icons.explore), label: 'المعالم'),
        BottomNavigationBarItem(icon: Icon(Icons.quiz), label: 'الاختبار'),
        BottomNavigationBarItem(icon: Icon(Icons.star), label: 'التقييم'),
      ]));
}

class WelcomeScreen extends StatefulWidget {
  const WelcomeScreen({super.key});
  @override State<WelcomeScreen> createState() => _WelcomeScreenState();
}

class _WelcomeScreenState extends State<WelcomeScreen> {
  late VideoPlayerController _vc; // تعريف متحكم مشغل الفيديو
  @override
  void initState() { 
    super.initState(); 
    _vc = VideoPlayerController.asset('assets/video/intro.mp4') // تحميل الفيديو من الملفات
      ..initialize().then((_) { 
        setState(() {}); // تحديث الواجهة بمجرد جاهزية الفيديو
        _vc.play(); // بدء التشغيل تلقائياً
        _vc.setLooping(true); // تكرار الفيديو بشكل مستمر
      }); 
  }
  @override void dispose() { _vc.dispose(); super.dispose(); } // تحرير الذاكرة عند إغلاق الشاشة
  @override
  Widget build(BuildContext context) => Scaffold(
    appBar: AppBar(title: const Text('أهلاً بكم في الأردن'), centerTitle: true),
    body: SingleChildScrollView(child: Column(children: [ // تمكين التمرير العمودي
      const SizedBox(height: 20),
      Center(child: Image.asset('assets/images/logo.png', height: 100, // عرض الشعار
        errorBuilder: (c, e, s) => const Icon(Icons.flag, size: 80, color: Colors.red))), // أيقونة بديلة في حال فقدان الصورة
      const Padding(padding: EdgeInsets.symmetric(vertical: 15), 
        child: Text('اكتشف عبق التاريخ وجمال الطبيعة', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Color(0xFFCE1126)))),
      if (_vc.value.isInitialized) AspectRatio(aspectRatio: _vc.value.aspectRatio, child: Stack(alignment: Alignment.bottomCenter, children: [
        VideoPlayer(_vc), // عرض طبقة الفيديو
        Center(child: IconButton(
          icon: Icon(_vc.value.isPlaying ? Icons.pause_circle_filled : Icons.play_circle_filled, color: Colors.white70, size: 60),
          onPressed: () { setState(() { if (_vc.value.isPlaying) { _vc.pause(); } else { _vc.play(); } }); }, // تبديل حالة التشغيل
        )),
      ])) else const SizedBox(height: 200, child: Center(child: CircularProgressIndicator())), // عرض مؤشر تحميل
     const Padding(padding: EdgeInsets.all(20.0), child: Text('مرحباً بكم في تطبيق سياحة الأردن، بوابتكم الرقمية لاستكشاف واحدة من أجمل الوجهات السياحية في العالم. هذا التطبيق هو دليل متكامل مصمم خصيصاً ليأخذكم في رحلة عبر الزمن، من المدن الأثرية الرومانية والأنباط إلى المناظر الطبيعية الخلابة في الصحاري والبحار. يهدف الموقع لتسهيل رحلتكم وتقديم المعلومات الأساسية لكل معلم بأسلوب شيق وتفاعلي، ليكون رفيقكم الأمثل في التعرف على كرم الضيافة الأردنية وأسرار التاريخ المكنونة في كل زاوية من زوايا المملكة الأردنية الهاشمية.', textAlign: TextAlign.justify, style: TextStyle(fontSize: 16, height: 1.6))),
    ])));
}

class TourismSitesScreen extends StatelessWidget {
  const TourismSitesScreen({super.key});
  @override
  Widget build(BuildContext context) {
    final List<Map<String, String>> data = [ // مصفوفة البيانات للمعالم السياحية
      {'name': 'مدينة البتراء الأثرية', 'image': 'assets/images/petra.jpg', 'info': 'تعتبر مدينة البتراء، المعروفة بالمدينة الوردية، جوهرة السياحة الأردنية وواحدة من عجائب الدنيا السبع الجديدة. نحتها الأنباط العرب في صخور جبال الشراة قبل أكثر من ألفي عام لتكون عاصمة لمملكتهم المزدهرة. تبدأ الرحلة إليها عبر "السيق"، وهو شق صخري ضيق يمتد لأكثر من كيلومتر، وينتهي بمشهد الخزنة المهيب. تضم البتراء مئات المعالم من معابد ومقابر ملكية ومدرج روماني ضخم. تتميز بألوان صخورها المتغيرة التي تتراوح بين الوردي والأحمر والأرجواني. إنها مكان يجمع بين العمارة العبقرية والتاريخ الغامض الذي لا يزال يبهر العلماء والسياح. زيارتها تعد تجربة فريدة لا تُنسى في حياة كل مسافر.'},
      {'name': 'مدينة جرش الرومانية', 'image': 'assets/images/jerash.jpg', 'info': 'تعد جرش واحدة من أكبر وأفضل المدن الرومانية المحفوظة في العالم خارج إيطاليا، وتعرف بلقب مدينة الألف عمود. تعكس المدينة عظمة العمارة الرومانية من خلال شوارعها المرصوفة، ومعابدها الشاهقة مثل معبد أرتميس، ومسارحها الضخمة التي لا تزال تستضيف المهرجانات. يمكن للزوار السير في "شارع الأعمدة" الطويل وتخيل الحياة اليومية في العصور القديمة. تضم المدينة أيضاً ساحة البيضاوي الفريدة من نوعها ومجموعة من الكنائس البيزنطية ذات الأرضيات الفسيفسائية. في كل عام، يقام فيها مهرجان جرش للثقافة والفنون، مما يجعلها ملتقى للحضارة القديمة والإبداع المعاصر. إنها وجهة مثالية لعشاق التاريخ والآثار الرومانية.'},
      {'name': 'صحراء وادي رم', 'image': 'assets/images/wadi_rum.jpg', 'info': 'وادي رم، الملقب بوادي القمر، هو محمية طبيعية خلابة تقع في جنوب الأردن وتتميز بتشكيلاتها الصخرية الرملية المذهلة. تشتهر الصحراء برمالها الحمراء وجبالها الشاهقة التي نحتها الرياح عبر آلاف السنين، مما خلق مشهداً يشبه سطح كوكب المريخ. يعتبر الوادي مكاناً مثالياً لمغامرات السفاري بسيارات الدفع الرباعي، وتسلق الجبال، والتخييم تحت سماء مليئة بالنجوم. ارتبط تاريخياً بالثورة العربية الكبرى ولورنس العرب، حيث توجد نقوش ثمودية قديمة على جدرانه. يمنح الوادي زواره شعوراً بالسكينة المطلقة بعيداً عن ضجيج المدن. كما استُخدم كموقع لتصوير العديد من أفلام هوليوود العالمية بفضل طبيعته الفريدة. إنها تجربة سياحية تمزج بين المغامرة والجمال الطبيعي الخام.'},
      {'name': 'شواطئ البحر الميت', 'image': 'assets/images/dead_sea.jpg', 'info': 'يقع البحر الميت في أخفض نقطة على سطح الأرض، وهو ظاهرة طبيعية فريدة لا مثيل لها في العالم أجمع. تتميز مياهه بملوحة شديدة تجعل الغرق فيه أمراً مستحيلاً، حيث يطفو جسم الإنسان بسهولة على سطحه. يعد البحر الميت مقصداً عالمياً للسياحة العلاجية بفضل مياهه الغنية بالأملاح وطينه الأسود الغني بالمعادن المفيدة للبشرة. تحيط به الجبال الشاهقة التي تضفي جمالاً مهيباً على المنطقة عند غروب الشمس. الهواء هنا غني بالأكسجين مما يساعد على الاسترخاء وتحسين التنفس. تتوفر في منطقته أرقى المنتجعات والفنادق العالمية التي تقدم خدمات استجمام فاخرة. زيارة البحر الميت ليست مجرد رحلة ترفيهية، بل هي رحلة للاستشفاء وتجديد الطاقة في أحضان الطبيعة.'},
      {'name': 'قلعة عجلون التاريخية', 'image': 'assets/images/ajloun.jpg', 'info': 'تتربع قلعة عجلون، أو قلعة الربض، فوق قمة جبل عوف لتطل على مساحات شاسعة من الغابات والأراضي الخضراء في شمال الأردن. بناها القائد عز الدين أسامة، أحد قادة صلاح الدين الأيوبي، عام 1184 لتكون حصناً منيعاً ضد الصليبيين وحماية لطرق التجارة. تتميز القلعة بتصميمها العسكري القوي وخنادقها العميقة وأبراجها المرتفعة التي تمنح رؤية بانورامية حتى جبال فلسطين. يمكن للزوار استكشاف الممرات الضيقة والقاعات الحجرية والتعرف على فنون العمارة الإسلامية الحربية. تحيط بالقلعة غابات عجلون الكثيفة التي تعد متنفساً طبيعياً رائعاً للتنزه في فصل الصيف. القلعة تروي قصصاً من البطولة والصمود الإسلامي عبر العصور. إنها وجهة تجمع بين عبق التاريخ وجمال المناظر الطبيعية الجبلية.'},
      {'name': 'مدينة العقبة البحرية', 'image': 'assets/images/aqaba.jpg', 'info': 'تمثل العقبة المنفذ البحري الوحيد للأردن على البحر الأحمر، وهي مدينة سياحية نابضة بالحياة تجمع بين الاستجمام والرياضات المائية. تشتهر العقبة بشعابها المرجانية الملونة وتنوع الحياة البحرية، مما يجعلها جنة لهواة الغوص والسباحة. تضم المدينة العديد من المنتجعات الفخمة والأسواق التقليدية التي توفر تجربة تسوق ممتعة بفضل صفتها كمنطقة اقتصادية خاصة. يمكن للزوار الاستمتاع برحلات القوارب الزجاجية أو ممارسة التزلج على الماء وركوب الأمواج. تاريخياً، تضم العقبة قلعة العقبة الشهيرة ومتحفاً يحكي قصة المدينة عبر العصور. تتميز العقبة بجوها المعتدل في فصل الشتاء، مما يجعلها وجهة مفضلة طوال العام. إنها المكان المثالي للعائلات والباحثين عن مزيج من الشمس والبحر والمغامرة.'}
    ];
    return Scaffold(
      appBar: AppBar(title: const Text('المواقع السياحية')),
      body: ListView.builder( // بناء قائمة ديناميكية
        padding: const EdgeInsets.all(10), 
        itemCount: data.length, // عدد العناصر في القائمة
        itemBuilder: (context, i) => Card(elevation: 4, margin: const EdgeInsets.only(bottom: 15), child: ListTile(
        contentPadding: const EdgeInsets.all(12),
        leading: ClipRRect(borderRadius: BorderRadius.circular(8), child: Image.asset(data[i]['image']!, width: 90, height: 90, fit: BoxFit.cover, 
          errorBuilder: (c, e, s) => const Icon(Icons.image, size: 80))), // عرض صورة المعلم
        title: Text(data[i]['name']!, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
        subtitle: const Text('انقر لقراءة التفاصيل الكاملة'),
        onTap: () => Navigator.push(context, MaterialPageRoute(builder: (context) => SiteDetailView(title: data[i]['name']!, imagePath: data[i]['image']!, description: data[i]['info']!))))))); // الانتقال لصفحة التفاصيل
  }
}

class SiteDetailView extends StatelessWidget {
  final String title, imagePath, description; // استقبال البيانات المطلوبة للعرض
  const SiteDetailView({super.key, required this.title, required this.imagePath, required this.description});
  @override
  Widget build(BuildContext context) => Scaffold(appBar: AppBar(title: Text(title)), body: SingleChildScrollView(child: Column(children: [
    Image.asset(imagePath, width: double.infinity, height: 300, fit: BoxFit.cover, errorBuilder: (c, e, s) => const Icon(Icons.broken_image, size: 100)),
    Padding(padding: const EdgeInsets.all(20), child: Text(description, textAlign: TextAlign.justify, style: const TextStyle(fontSize: 18, height: 1.8))),
  ])));
}

class InteractiveQuizScreen extends StatefulWidget {
  const InteractiveQuizScreen({super.key});
  @override State<InteractiveQuizScreen> createState() => _InteractiveQuizScreenState();
}

class _InteractiveQuizScreenState extends State<InteractiveQuizScreen> {
  int _qIdx = 0, _score = 0; final AudioPlayer _ap = AudioPlayer(); // تعريف متغيرات النتيجة ومشغل الصوت
  final List<Map<String, dynamic>> _qs = [ // مصفوفة الأسئلة والخيارات والإجابة الصحيحة
    {'q': 'في أي محافظة تقع مدينة البتراء؟', 'o': ['عمان', 'معان', 'اربد'], 'c': 1},
    {'q': 'ما هو الموقع الذي يسمى وادي القمر؟', 'o': ['جرش', 'وادي رم', 'البحر الميت'], 'c': 1},
    {'q': 'أي موقع يعتبر أخفض نقطة في العالم؟', 'o': ['البحر الميت', 'العقبة', 'وادي رم'], 'c': 0},
    {'q': 'ما هي المدينة التي تسمى مدينة الألف عمود؟', 'o': ['الكرك', 'البتراء', 'جرش'], 'c': 2},
    {'q': 'من الذي بنى قلعة عجلون؟', 'o': ['الرومان', 'الأنباط', 'الأيوبيون'], 'c': 2}
  ];
  void _ans(int i) { // دالة التحقق من الإجابة
    if (i == _qs[_qIdx]['c']) { _score++; _ap.play(AssetSource('sounds/correct.mp3')); } // إجابة صحيحة وصوت نجاح
    else { _ap.play(AssetSource('sounds/wrong.mp3')); } // إجابة خاطئة وصوت فشل
    setState(() { 
      if (_qIdx < _qs.length - 1) _qIdx++; // الانتقال للسؤال التالي
      else showDialog(context: context, barrierDismissible: false, builder: (ctx) => AlertDialog( // عرض مربع النتيجة النهائية
        title: const Text('النتيجة'), 
        content: Text('درجتك: $_score من اصل ${_qs.length}'), 
        actions: [TextButton(onPressed: () { Navigator.pop(ctx); setState(() { _qIdx = 0; _score = 0; }); }, child: const Text('إعادة'))])); 
    });
  }
  @override
  Widget build(BuildContext context) => Scaffold(appBar: AppBar(title: const Text('اختبر معلوماتك')), body: Padding(padding: const EdgeInsets.all(20.0), child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
    Text('سؤال ${_qIdx + 1} / ${_qs.length}'), const SizedBox(height: 20),
    Text(_qs[_qIdx]['q'], textAlign: TextAlign.center, style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold)), const SizedBox(height: 40),
    ...List.generate(3, (i) => Padding(padding: const EdgeInsets.only(bottom: 15), child: ElevatedButton(style: ElevatedButton.styleFrom(minimumSize: const Size(double.infinity, 60)), 
      onPressed: () => _ans(i), child: Text(_qs[_qIdx]['o'][i], style: const TextStyle(fontSize: 18))))), // توليد أزرار الإجابات
  ])));
}

class AppRatingScreen extends StatefulWidget {
  const AppRatingScreen({super.key});
  @override State<AppRatingScreen> createState() => _AppRatingScreenState();
}

class _AppRatingScreenState extends State<AppRatingScreen> {
  int _r = 0; bool _s = false; // متغيرات لتخزين عدد النجوم وحالة الإرسال
  @override
  Widget build(BuildContext context) => Scaffold(appBar: AppBar(title: const Text('تقييم التطبيق'), centerTitle: true), body: Center(child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
    const Icon(Icons.stars_rounded, size: 100, color: Color(0xFFCE1126)), const SizedBox(height: 30),
    const Text('اكتب تقييمك', style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)), const SizedBox(height: 15),
    const Text('رأيك يهمنا لتحسين تجربة المستخدم', textAlign: TextAlign.center, style: TextStyle(fontSize: 16, color: Colors.grey)), const SizedBox(height: 40),
    Row(mainAxisAlignment: MainAxisAlignment.center, children: List.generate(5, (i) => IconButton(
      icon: Icon(i < _r ? Icons.star : Icons.star_border, color: Colors.orange, size: 50), 
      onPressed: () => setState(() { _r = i + 1; _s = true; })))), // تحديث النجوم عند الضغط
    const SizedBox(height: 30), 
    if (_s) Container(padding: const EdgeInsets.all(15), decoration: BoxDecoration(color: Colors.green.shade50, borderRadius: BorderRadius.circular(10)), 
      child: const Text('شكراً على تقييمك!', style: TextStyle(fontSize: 20, color: Colors.green, fontWeight: FontWeight.bold))), // رسالة شكر تظهر بعد التقييم
  ])));
}