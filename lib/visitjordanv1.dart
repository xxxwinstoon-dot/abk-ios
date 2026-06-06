import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

void main() => runApp(const JordanTourismApp());

class JordanTourismApp extends StatelessWidget {
  const JordanTourismApp({super.key});
  @override
  Widget build(BuildContext context) => MaterialApp(
    debugShowCheckedModeBanner: false,
    localizationsDelegates: const [GlobalMaterialLocalizations.delegate, GlobalWidgetsLocalizations.delegate, GlobalCupertinoLocalizations.delegate],
    supportedLocales: const [Locale('ar', 'AE')], locale: const Locale('ar', 'AE'),
    theme: ThemeData(colorScheme: ColorScheme.fromSeed(seedColor: const Color(0xFFCE1126)), useMaterial3: true),
    home: const MainNavigationScreen());
}

class MainNavigationScreen extends StatefulWidget {
  const MainNavigationScreen({super.key});
  @override State<MainNavigationScreen> createState() => _MainNavigationScreenState();
}

class _MainNavigationScreenState extends State<MainNavigationScreen> {
  int _currentIndex = 0;
  final List<Widget> _pages = [const WelcomeScreen(), const TourismSitesScreen(), const InteractiveQuizScreen(), const AppRatingScreen()];
  @override
  Widget build(BuildContext context) => Scaffold(
    body: IndexedStack(index: _currentIndex, children: _pages),
    bottomNavigationBar: BottomNavigationBar(
      currentIndex: _currentIndex, type: BottomNavigationBarType.fixed, selectedItemColor: const Color(0xFFCE1126),
      onTap: (index) => setState(() => _currentIndex = index),
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
  late VideoPlayerController _vc;
  @override
  void initState() { 
    super.initState(); 
    _vc = VideoPlayerController.asset('assets/video/intro.mp4')..initialize().then((_) { 
      if (mounted) setState(() {}); 
      _vc.play(); 
      _vc.setLooping(true); 
    }); 
  }
  @override void dispose() { _vc.dispose(); super.dispose(); }
  @override
  Widget build(BuildContext context) => Scaffold(
    appBar: AppBar(title: const Text('أهلاً بكم في الأردن'), centerTitle: true),
    body: Center(child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
      const Text('اكتشف عبق التاريخ وجمال الطبيعة', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
      const SizedBox(height: 20),
      if (_vc.value.isInitialized) AspectRatio(aspectRatio: _vc.value.aspectRatio, child: VideoPlayer(_vc))
      else const CircularProgressIndicator(),
    ])));
}

class TourismSitesScreen extends StatelessWidget {
  const TourismSitesScreen({super.key});
  @override
  Widget build(BuildContext context) {
    final List<Map<String, String>> data = [
      {'name': 'البتراء', 'img': 'assets/images/petra.jpg', 'info': 'المدينة الوردية وعجيبة الدنيا.'},
      {'name': 'جرش', 'img': '', 'info': 'مدينة الألف عمود الرومانية.'},
      {'name': 'وادي رم', 'img': '', 'info': 'وادي القمر والطبيعة الخلابة.'},
      {'name': 'البحر الميت', 'img': '', 'info': 'أخفض نقطة مالح في العالم.'},
      {'name': 'قلعة عجلون', 'img': '', 'info': 'حصن تاريخي بناه الأيوبيون.'},
      {'name': 'العقبة', 'img': '', 'info': 'ثغر الأردن الباسم على البحر.'}
    ];
    return Scaffold(
      appBar: AppBar(title: const Text('المواقع السياحية')),
      body: ListView.builder(itemCount: data.length, itemBuilder: (context, i) => ListTile(
        leading: (data[i]['name'] == 'البتراء') 
          ? Image.asset(data[i]['img']!, width: 50, errorBuilder: (c, e, s) => const Icon(Icons.image)) 
          : const Icon(Icons.location_city),
        title: Text(data[i]['name']!),
        subtitle: Text(data[i]['info']!),
        onTap: () => Navigator.push(context, MaterialPageRoute(builder: (context) => SiteDetail(data: data[i]))))));
  }
}

class SiteDetail extends StatelessWidget {
  final Map<String, String> data;
  const SiteDetail({super.key, required this.data});
  @override
  Widget build(BuildContext context) => Scaffold(appBar: AppBar(title: Text(data['name']!)), body: Center(child: Padding(padding: const EdgeInsets.all(20), child: Text(data['info']!, style: const TextStyle(fontSize: 20)))));
}

class InteractiveQuizScreen extends StatefulWidget {
  const InteractiveQuizScreen({super.key});
  @override State<InteractiveQuizScreen> createState() => _InteractiveQuizScreenState();
}

class _InteractiveQuizScreenState extends State<InteractiveQuizScreen> {
  int _qIdx = 0;
  final List _qs = [
    {'q': 'أين تقع البتراء؟', 'o': ['عمان', 'معان', 'اربد'], 'c': 1},
    {'q': 'ما هو وادي القمر؟', 'o': ['جرش', 'وادي رم', 'العقبة'], 'c': 1}
  ];

  void _processAnswer(int i) {
    setState(() {
      if (_qIdx < _qs.length - 1) {
        _qIdx++;
      } else {
        _qIdx = 0; // إعادة الاختبار ببساطة
      }
    });
  }

  @override
  Widget build(BuildContext context) => Scaffold(
    body: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
      Text("سؤال رقم ${_qIdx + 1}", style: const TextStyle(color: Colors.grey)),
      const SizedBox(height: 10),
      Text(_qs[_qIdx]['q'], style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold), textAlign: TextAlign.center),
      const SizedBox(height: 30),
      ...List.generate(3, (i) => Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 5),
        child: ElevatedButton(
          style: ElevatedButton.styleFrom(minimumSize: const Size(double.infinity, 50)),
          onPressed: () => _processAnswer(i), 
          child: Text(_qs[_qIdx]['o'][i])),
      ))
    ]));
}

class AppRatingScreen extends StatelessWidget {
  const AppRatingScreen({super.key});
  @override
  Widget build(BuildContext context) => Scaffold(
    body: Center(child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
      const Text('التقييم معطل حالياً', style: TextStyle(fontSize: 20)),
      const SizedBox(height: 20),
      Row(mainAxisAlignment: MainAxisAlignment.center, children: List.generate(5, (i) => const Icon(Icons.star_border, size: 40, color: Colors.orange)))
    ])));
}