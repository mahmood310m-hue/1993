import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const KautharSchoolApp());
}

class KautharSchoolApp extends StatelessWidget {
  const KautharSchoolApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'مدرسة كوثر الأهلية المختلطة',
      debugShowCheckedModeBanner: false,
      locale: const Locale('ar', 'IQ'),
      supportedLocales: const [Locale('ar', 'IQ')],
      localizationsDelegates: const [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      theme: ThemeData(
        primarySwatch: Colors.teal,
        scaffoldBackgroundColor: const Color(0xFFF7F9F6),
        fontFamily: 'Cairo',
      ),
      home: const MainScreen(),
    );
  }
}

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  String _currentTime = '';
  String _currentDate = '';
  late Timer _timer;

  @override
  void initState() {
    super.initState();
    _updateTime();
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) => _updateTime());
  }

  void _updateTime() {
    final now = DateTime.now();
    setState(() {
      _currentTime = intl.DateFormat('hh:mm:ss a', 'ar').format(now);
      _currentDate = intl.DateFormat('yyyy/MM/dd', 'ar').format(now);
    });
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.white,
          elevation: 0.5,
          title: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'مدرسة كوثر الأهلية المختلطة',
                style: TextStyle(color: Colors.black85, fontSize: 16, fontWeight: FontWeight.bold),
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(_currentTime, style: const TextStyle(color: Colors.teal, fontSize: 12, fontWeight: FontWeight.bold)),
                  Text(_currentDate, style: const TextStyle(color: Colors.grey, fontSize: 10)),
                ],
              ),
            ],
          ),
          iconTheme: const IconThemeData(color: Colors.black85),
        ),
        body: SingleChildScrollView(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // البطاقة الترحيبية المطابقة للصورة
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: const Color(0xFFE8F5E9),
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: const Color(0xFFC8E6C9)),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: const [
                    Text('مدرستنا • بيت العلم والإبداع', style: TextStyle(color: Colors.teal, fontSize: 12, fontWeight: FontWeight.bold)),
                    SizedBox(height: 8),
                    Text('مرحباً بكم في مدرسة كوثر', style: TextStyle(color: Color(0xFF1B5E20), fontSize: 20, fontWeight: FontWeight.bold)),
                    SizedBox(height: 8),
                    Text('بيئة تعليمية آمنة ومحفزة، نؤمن أن لكل طالب موهبة تستحق الرعاية.', style: TextStyle(color: Colors.black54, fontSize: 13)),
                  ],
                ),
              ),
              const SizedBox(height: 20),
              // بطاقات الإحصائيات (الطلبة، المتفوقون، العام الدراسي، الإعلانات)
              GridView.count(
                crossAxisCount: 2,
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                crossAxisSpacing: 12,
                mainAxisSpacing: 12,
                childAspectRatio: 1.4,
                children: [
                  _buildStatCard('المتفوقون', '4', Icons.star, Colors.amber),
                  _buildStatCard('الطلاب', '120', Icons.person, Colors.blue),
                  _buildStatCard('العام الدراسي', '2026-2027', Icons.calendar_today, Colors.teal),
                  _buildStatCard('الإعلانات', '3', Icons.announcement, Colors.orange),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildStatCard(String title, String value, IconData icon, Color color) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(color: Colors.grey.withOpacity(0.08), blurRadius: 8, offset: const Offset(0, 2)),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(title, style: const TextStyle(color: Colors.grey, fontSize: 13, fontWeight: FontWeight.bold)),
              Icon(icon, color: color, size: 20),
            ],
          ),
          const Spacer(),
          Text(value, style: const TextStyle(color: Colors.black85, fontSize: 22, fontWeight: FontWeight.bold)),
        ],
      ),
    );
  }
}