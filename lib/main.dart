import 'package:flutter/material.dart';
import 'package:our_mediapipe_app/services/service_locator.dart';
import 'package:our_mediapipe_app/ui/pages/camera_page.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  setupLocator();
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: CameraPage(),
    );
  }
}
