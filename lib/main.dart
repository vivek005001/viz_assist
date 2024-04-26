import 'package:camera/camera.dart';
import 'pages/camera_page.dart';
import 'package:flutter/material.dart';
import 'pages/home.dart';
import 'pages/login_register_page.dart';
import 'pages/home_page.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  final cameras = await availableCameras();
  runApp(MainApp(cameras: cameras));
}

class MainApp extends StatelessWidget {
  final List<CameraDescription> cameras;
  const MainApp({super.key, required this.cameras});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: CameraPage(
        cameras: cameras,
      ),
    );
  }
}



