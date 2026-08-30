import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_app_check/firebase_app_check.dart';
import 'features/onboarding/screens/t_and_c_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  // 1. Khởi tạo Firebase
  await Firebase.initializeApp();
  
  // 2. Bảo mật: Kích hoạt Firebase App Check (Chống CSRF & Bot)
  // Chỉ những request từ App thật mới được đi qua Firestore & Cloud Functions
  await FirebaseAppCheck.instance.activate(
    androidProvider: AndroidProvider.playIntegrity,
    appleProvider: AppleProvider.deviceCheck,
  );

  runApp(const ScamSimulatorApp());
}

class ScamSimulatorApp extends StatelessWidget {
  const ScamSimulatorApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Scam Simulator',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        brightness: Brightness.dark,
        scaffoldBackgroundColor: Colors.black,
        primarySwatch: Colors.blue,
      ),
      home: const TermsAndConditionsScreen(),
    );
  }
}
