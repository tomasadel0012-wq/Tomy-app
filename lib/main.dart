import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart'; // الخريطة الموحدة المجانية لكل الهواتف
import 'package:latlong2/latlong.dart'; // لضبط الإحداثيات الجغرافية
import 'package:geolocator/geolocator.dart'; // لتشغيل الـ GPS وحساب السرعة الحقيقية

void main() {
  runApp(const TomyApp());
}

class TomyApp extends StatelessWidget {
  const TomyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'TOMY',
      debugShowCheckedModeBanner: false,
      theme: ThemeData.dark().copyWith(
        scaffoldBackgroundColor: const Color(0xFF121212),
        primaryColor: const Color(0xFFBB86FC),
        colorScheme: const ColorScheme.dark(
          primary: Color(0xFFBB86FC),
          secondary: Color(0xFF03DAC6),
          surface: Color(0xFF1E1E1E),
        ),
      ),
      home: const SplashScreen(),
    );
  }
}

// =========================================================================
// 1. شاشة البداية الحصرية (تظهر لمدة 4 ثوانٍ كاملة بالثيم الغامق والنيون)
// =========================================================================
class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    Timer(const Duration(seconds: 4), () {
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (context) => const LoginScreen()),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'T',
              style: TextStyle(
                fontSize: 140,
                fontWeight: FontWeight.bold,
                color: Color(0xFFBB86FC),
                shadows: [
                  Shadow(color: Colors.purple, blurRadius: 25),
                  Shadow(color: Color(0xFF03DAC6), blurRadius: 10),
                ],
              ),
            ),
            SizedBox(height: 15),
            Text(
              'TOMY',
              style: TextStyle(
                fontSize: 32,
                fontWeight: FontWeight.w500,
                color: Colors.white,
                letterSpacing: 6,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// =========================================================================
// 2. شاشة تسجيل الدخول واختيار الصلاحية (أدمن / عضو)
// =========================================================================
class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _nameController = TextEditingController();
  final _phoneController = TextEditingController();
  final _codeController = TextEditingController();
  bool isAdminChoice = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Center(
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const Text(
                  'تسجيل الدخول في تومي',
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 26, fontWeight: FontWeight.bold, color: Colors.white),
                ),
                const SizedBox(height: 30),
                TextField(
                  controller: _nameController,
                  decoration: const InputDecoration(
                    labelText: 'الاسم بالكامل',
                    border: OutlineInputBorder(),
                    prefixIcon: Icon(Icons.person),
                  ),
                ),
                const SizedBox(height: 16),
                TextField(
                  controller: _phoneController,
                  keyboardType: TextInputType.phone,
                  decoration: const InputDecoration(
                    labelText: 'رقم الهاتف',
                    border: OutlineInputBorder(),
                    prefixIcon: Icon(Icons.phone),
                  ),
                ),
                const SizedBox(height: 16),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    ChoiceChip(
                      label: const Text('دخول كـ أدمن جروب'),
                      selected: isAdminChoice,
                      onSelected: (val) => setState(() => isAdminChoice = true),
                    ),
                    const SizedBox(width: 12),
                    ChoiceChip(
                      label: const Text('الانضمام لجروب قائم'),
                      selected: !isAdminChoice,
                      onSelected: (val) => setState(() => isAdminChoice = false),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                if (!isAdminChoice)
                  TextField(
                    controller: _codeController,
                    decoration: const InputDecoration(
                      labelText: 'أدخل كود الجروب المكون من 6 أرقام',
                      border: OutlineInputBorder(),
                      prefixIcon: Icon(Icons.lock),
                    ),
                  ),
                const SizedBox(height: 24),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFFBB86FC),
                    foregroundColor: Colors.black,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                  ),
                  onPressed: () {
                    if (_nameController.text.isEmpty) return;
                    if (isAdminChoice) {
                      Navigator.of(context).pushReplacement(
                        MaterialPageRoute(
                          builder: (context) => AdminDashboard(adminName: _nameController.text),
                        ),
                      );
                    } else {
                      Navigator.of(context).pushReplacement(
                        MaterialPageRoute(
                          builder: (context) => WaitingScreen(userName: _nameController.text),
                        ),
                      );
                    }
                  },
                  child: Text(isAdminChoice ? 'إنشاء جروب جديد كأدمن' : 'طلب انضمام للجروب'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

// =========================================================================
// 3. شاشة قائمة الانتظار (تمنع العضو من رؤية الخريطة حتى يوافق الأدمن)
// =========================================================================
class WaitingScreen extends StatefulWidget {
  final String userName;
  const WaitingScreen({Key? key, required this.userName}) : super(key: key);

  @override
  State<WaitingScreen> createState() => _WaitingScreenState();
}

class _WaitingScreenState extends State<WaitingScreen> {
  @override
  void initState() {
    super.initState();
    // محاكاة قبول الأدمن تلقائياً بعد 10 ثوانٍ للانتقال الحقيقي للخريطة
    Timer(const Duration(seconds: 10), () {
      if (mounted) {
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (context) => MapScreen(userName: widget.userName)),
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const CircularProgressIndicator(color: Color(0xFFBB86FC)),
              const SizedBox(height: 30),
              Text(
                'أهلاً يا ${widget.userName}',
                style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 10),
              const Text(
                'أنت الآن في قائمة الانتظار (Pending List)\nلا يمكنك رؤية الخريطة أو الأعضاء حتى يوافق الأدمن على دخولك أو يطردك.',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 16, color: Colors.grey),
              ),
              const SizedBox(height: 40),
              const Text(
                '(لمحاكاة التجربة الحية: سيتم قبولك برمجياً بعد ثوانٍ لفتح الخريطة والـ GPS الفعلي)',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 12, color: Color(0xFF03DAC6), fontStyle: FontStyle.italic),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class Member {
  final String id;
  final String name;
  double speed;
  String status;

  Member({required this.id, required this.name, required this.speed, this.status = 'active'});
}

// =========================================================================
// 4. لوحة تحكم الأدمن (قائمة الانتظار + طرد فوري + مراقبة حية للسرعة)
// =========================================================================
class AdminDashboard extends StatefulWidget {
  final String adminName;
  const AdminDashboard({Key? key, required this.adminName}) : super(key: key);

  @override
  State<AdminDashboard> createState() => _AdminDashboardState();
}

class _AdminDashboardState extends State<AdminDashboard> {
  final List<Member> activeMembers = [
    Member(id: '1', name: 'محمود (الهريسة)', speed: 85.5),
    Member(id: '2', name: 'كريم سيارة', speed: 42.0),
  ];

  final List<Member> pendingMembers = [
    Member(id: '3', name: 'محمد صابر', speed: 0.0, status: 'pending'),
    Member(id: '4', name: 'إبراهيم علي', speed: 0.0, status: 'pending'),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('لوحة تحكم الأدمن: ${widget.adminName}'),
        backgroundColor: const Color(0xFF1E1E1E),
        actions: [
          IconButton(
            icon: const Icon(Icons.smart_toy, color: Color(0xFF03DAC6)),
            onPressed: () {
              Navigator.of(context).push(
                MaterialPageRoute(builder: (context) => const TomyAIScreen()),
              );
            },
          )
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: const Color(0xFF1E1E1E),
                borderRadius: BorderRadius.circular(10),
                border: Border.all(color: const Color(0xFFBB86FC)),
              ),
              child: const Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('كود الجروب الخاص بك الحصري:', style: TextStyle(fontSize: 16)),
                  Text('TOMY77', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Color(0xFFBB86FC))),
                ],
              ),
            ),
            const SizedBox(height: 20),
            Text('⚠️ قائمة الانتظار المعلقة (${pendingMembers.length})', style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.amber)),
            Expanded(
              child: pendingMembers.isEmpty 
                ? const Center(child: Text('لا توجد طلبات انتظار حالياً'))
                : ListView.builder(
                    itemCount: pendingMembers.length,
                    itemBuilder: (context, index) {
                      final member = pendingMembers[index];
                      return Card(
                        color: const Color(0xFF222222),
                        child: ListTile(
                          title: Text(member.name),
                          subtitle: const Text('طلب انضمام جديد...'),
                          trailing: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              IconButton(
                                icon: const Icon(Icons.check_circle, color: Colors.green),
                                onPressed: () {
                                  setState(() {
                                    member.status = 'active';
                                    activeMembers.add(member);
                                    pendingMembers.removeAt(index);
                                  });
                                },
                              ),
                              IconButton(
                                icon: const Icon(Icons.cancel, color: Colors.red),
                                onPressed: () {
                                  setState(() {
                                    pendingMembers.removeAt(index);
                                  });
                                },
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
            ),
            const Divider(color: Colors.grey),
            const Text('🟢 الأعضاء النشطين ومراقبة السرعات', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.green)),
            Expanded(
              child: ListView.builder(
                itemCount: activeMembers.length,
                itemBuilder: (context, index) {
                  final member = activeMembers[index];
                  return Card(
                    color: const Color(0xFF1E1E1E),
                    child: ListTile(
                      leading: const CircleAvatar(
                        backgroundColor: Color(0xFFBB86FC),
                        child: Text('T', style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold)),
                      ),
                      title: Text(member.name),
                      subtitle: Text('السرعة اللحظية: ${member.speed} كم/س', style: TextStyle(color: member.speed > 80 ? Colors.red : Colors.grey)),
                      trailing: ElevatedButton(
                        style: ElevatedButton.styleFrom(backgroundColor: Colors.red.shade900),
                        onPressed: () {
                          setState(() {
                            activeMembers.removeAt(index);
                          });
                        },
                        child: const Text('طرد فوراً'),
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// =========================================================================
// 5. شاشة الخريطة الدقيقة وتتبع الـ GPS الحقيقي والسرعة اللحظية المحدثة
// =========================================================================
class MapScreen extends StatefulWidget {
  final String userName;
  const MapScreen({Key? key, required this.userName}) : super(key: key);

  @override
  State<MapScreen> createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
  double userLat = 30.0444; 
  double userLng = 31.2357;
  double speedInKmH = 0.0;
  bool isLoading = true;
  StreamSubscription<Position>? _positionStreamSubscription;

  @override
  void initState() {
    super.initState();
    _initLiveLocationTracking(); // بدء تتبع الأقمار الصناعية الدقيق فوراً
  }

  Future<void> _initLiveLocationTracking() async {
    bool serviceEnabled;
    LocationPermission permission;

    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) return;

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) return;
    }

    setState(() {
      isLoading = false;
    });

    // استماع لحظي دقيق للتغير في الموقع والسرعة (كل 2 متر حركة)
    _positionStreamSubscription = Geolocator.getPositionStream(
      locationSettings: const LocationSettings(accuracy: LocationAccuracy.high, distanceFilter: 2)
    ).listen((Position position) {
      setState(() {
        userLat = position.latitude;
        userLng = position.longitude;
        speedInKmH = position.speed * 3.6; // تحويل فوري دقيق من م/ث إلى كم/س
      });
    });
  }

  @override
  void dispose() {
    _positionStreamSubscription?.cancel(); // إغلاق التتبع عند قفل الشاشة لحفظ البطارية
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: isLoading
        ? const Center(child: CircularProgressIndicator(color: Color(0xFFBB86FC)))
        : Stack(
            children: [
              FlutterMap(
                options: MapOptions(
                  initialCenter: LatLng(userLat, userLng),
                  initialZoom: 16.0,
                ),
                children: [
                  TileLayer(
                    urlTemplate: 'https://{s}.basemaps.cartocdn.com/dark_all/{z}/{x}/{y}{r}.png',
                    subdomains: ['a', 'b', 'c', 'd'],
                  ),
                  MarkerLayer(
                    markers: [
                      Marker(
                        point: LatLng(userLat, userLng),
                        width: 80,
                        height: 80,
                        child: const Column(
                          children: [
                            Icon(Icons.location_on, color: Color(0xFFBB86FC), size: 40),
                            Text('أنت (تومي)', style: TextStyle(color: Colors.white, fontSize: 10, fontWeight: FontWeight.bold)),
                          ],
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              Positioned(
                top: 50,
                left: 20,
                right: 20,
                child: Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: const Color(0xFF1E1E1E),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: speedInKmH > 80 ? Colors.red : const Color(0xFFBB86FC), width: 2),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text('العضو: $userName', style: const TextStyle(fontWeight: FontWeight.bold)),
                      Text(
                        'السرعة الحالية: ${speedInKmH.toStringAsFixed(1)} كم/س',
                        style: TextStyle(
                          color: speedInKmH > 80 ? Colors.red : const Color(0xFF03DAC6),
                          fontWeight: FontWeight.bold,
                          fontSize: 18,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
    );
  }
}

// =========================================================================
// 6. شاشة ذكاء تومي الاصطناعي (TOMY AI) لمراقبة وتحليل غرف التتبع
// =========================================================================
class TomyAIScreen extends StatefulWidget {
  const TomyAIScreen({Key? key}) : super(key: key);

  @override
  State<TomyAIScreen> createState() => _TomyAIScreenState();
}

class _TomyAIScreenState extends State<TomyAIScreen> {
  final _msgController = TextEditingController();
  final List<Map<String, String>> chatHistory = [
    {'bot': 'أهلاً بك! أنا مساعد TOMY AI الذكي المجاني. يمكنك سؤالي عن أي شيء يخص الأعضاء، السرعات، أو كيفية إدارة غرف التتبع حالياً.'}
  ];

  void handleSend() {
    if (_msgController.text.isEmpty) return;
    String userText = _msgController.text;
    setState(() {
      chatHistory.add({'user': userText});
      _msgController.clear();
    });

    Timer(const Duration(milliseconds: 600), () {
      String botReply = 'أنا هنا لمساعدتك بذكاء مجاني تماماً. تم رصد "محمود (الهريسة)" يسير بسرعة 85.5 كم/س وهو العضو الأعلى سرعة الآن!';
      if (userText.contains('مين') || userText.contains('سرعة')) {
        botReply = '🚨 تقرير السرعة اللحظي: العضو "محمود (الهريسة)" يتصدر القائمة بسرعة 85.5 كم/س في نطاق الجيزة. تم إرسال إشعار فوري له.';
      } else if (userText.contains('انتظار') || userText.contains('قبول')) {
        botReply = '💡 يوجد حالياً (2) أعضاء في قائمة الانتظار المعلقة (Pending List) بانتظار ضغطك على زر القبول لتفعيل الخريطة لهم.';
      }
      setState(() {
        chatHistory.add({'bot': botReply});
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('مساعد تومي الذكي TOMY AI'), backgroundColor: const Color(0xFF1E1E1E)),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: chatHistory.length,
              itemBuilder: (context, index) {
                final item = chatHistory[index];
                bool isBot = item.containsKey('bot');
                return Align(
                  alignment: isBot ? Alignment.centerRight : Alignment.centerLeft,
                  child: Container(
                    margin: const EdgeInsets.symmetric(vertical: 6),
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: isBot ? const Color(0xFF1E1E1E) : const Color(0xFFBB86FC),
                      borderRadius: BorderRadius.circular(10),
                      border: isBot ? Border.all(color: const Color(0xFF03DAC6)) : null,
                    ),
                    child: Text(
                      isBot ? item['bot']! : item['user']!,
                      style: TextStyle(color: isBot ? Colors.white : Colors.black),
                    ),
                  ),
                );
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(12.0),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _msgController,
                    decoration: const InputDecoration(
                      hintText: 'اسأل TOMY AI عن سرعة الأعضاء...',
                      border: OutlineInputBorder(),
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                IconButton(
                  icon: const Icon(Icons.send, color: Color(0xFFBB86FC)),
                  onPressed: handleSend,
                )
              ],
            ),
          )
        ],
      ),
    );
  }
}