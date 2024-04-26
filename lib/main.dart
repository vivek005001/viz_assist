import 'package:animated_splash_screen/animated_splash_screen.dart';
import 'package:camera/camera.dart';
import 'package:image_speak/utils/splash.dart';
import 'pages/camera_page.dart';
import 'package:flutter/material.dart';
import 'pages/home.dart';
import 'pages/login_register_page.dart';
import 'pages/home_page.dart';
import 'package:flutter_gemini/flutter_gemini.dart';
import 'pages/consts.dart';
import 'pages/image_chat.dart';


Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  Gemini.init(apiKey: GEMINI_API_KEY);
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
      home: AnimatedSplashScreen(splash: Center(
        child: ClipRRect(
          borderRadius: BorderRadius.circular(20),
          child: Image.asset(
            'lib/icons/icon.png',
            width: 80,
            height: 80,
          ),
        ),

      ),nextScreen: HomePage(),),

      // home: ChatPage(),
    );
  }
}



