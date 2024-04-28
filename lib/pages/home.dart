import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_speak/pages/camera_page.dart';
import '../utils/translation_page.dart';
import 'package:lottie/lottie.dart';
import '/utils/smart_device_box.dart';
import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:translator/translator.dart';


class HomePage extends StatefulWidget {
  const HomePage({super.key, required this.cameras});
  final List<CameraDescription> cameras;

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  // padding constants
  final double horizontalPadding = 40;
  final double verticalPadding = 25;
  String output = "";
  String selectedLanguage = 'en';
  String? destinationLanguage = "";
  // final List<String> languages = ['Select Language', 'Hindi', 'English', 'Japanese'];



  // void temp = translate("en","ja","Hello");


  @override

  Widget build(BuildContext context) {
    return GestureDetector(
      onDoubleTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => CameraPage(cameras: widget.cameras),
          ),
        );
      },
      child: Scaffold(
      backgroundColor: const Color(0xFF0D0D0D),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // app bar
            Padding(
              padding: EdgeInsets.symmetric(
                horizontal: horizontalPadding,
                vertical: verticalPadding,
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  // menu icon
                  Image.asset(
                    'lib/icons/menu.png',
                    height: 45,
                    // color: Colors.grey[800],
                  ),

                  // account icon
                  Theme(
                    data: ThemeData(
                      // canvasColor: Colors.black,


                    ),

                    child: DropdownButton(
                      // value: destinationLanguage != null? destinationLanguage : null,
                      focusColor: Colors.blueAccent,
                      icon: Icon(Icons.translate,color: const Color(0xFF4D96AF),),
                      // iconDisabledColor: Colors.grey,
                      // iconEnabledColor: Colors.white,

                      items: const [


                        // DropdownMenuItem(child: Text("English"),value: "en",),
                        DropdownMenuItem(

                          child: Text("Hindi", style: TextStyle( color: const Color(0xFF4D96AF),)),
                          value: "hi",
                        ),
                        DropdownMenuItem(
                          child: Text("Japanese", style: TextStyle(color: const Color(0xFF4D96AF),)),
                          value: "ja",
                        ),

                      ], onChanged: (String? value) { destinationLanguage = value;
                    print(destinationLanguage);},
                    ),
                  ),

                ],
              ),
            ),

            const SizedBox(height: 20),

            // welcome home
            Padding(
              padding: EdgeInsets.symmetric(horizontal: horizontalPadding),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[

                  Text(

                    'Hello',
                    style: TextStyle(fontSize: 20, color: Colors.grey.shade700),
                  ),
                  Container(
                    child: AnimatedTextKit(
                      animatedTexts: [
                        TyperAnimatedText(
                          'Vivek Aggarwal',
                          textStyle: TextStyle(
                            fontFamily: GoogleFonts.bebasNeue().fontFamily,
                            fontSize: 62,
                            color: const Color(0xFF4D96AF),
                          ),
                          speed: const Duration(milliseconds: 150),
                        ),
                      ],
                      totalRepeatCount: 1,

                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 25),

            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 40.0),
              child: Divider(
                thickness: 1,
                color: Color.fromARGB(255, 204, 204, 204),
              ),
            ),

            const SizedBox(height: 25),

            // smart devices grid
            Padding(
              padding: EdgeInsets.symmetric(horizontal: horizontalPadding),
              child: Text(
                "IMAGE SPEAK",
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 30,
                  color: Colors.white,
                ),
              ),
            ),
            const SizedBox(height: 10),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: horizontalPadding),
              child: Text(
                "Empowering the visually impaired with the language of images, providing access to a world of visual information through spoken captions",
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 18,
                  color: Colors.grey.shade600,
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.only(
                  top: 65), // Adjust the top padding value as needed
              child: Container(
                alignment: Alignment.center,
                child: Lottie.asset(
                  "assets/animations/camera.json",
                  repeat: true,
                  height: 80,
                  width: 80,
                ),
                // Image.asset(
                //   'lib/icons/camera.png',
                //   height: 80,
                //   width: 80,
                //   color: const Color(0xFF4D96AF),
                //   // specify other parameters like width, height, etc. as needed
                // ),
              ),
            ),
            Padding(
              padding: EdgeInsets.symmetric(
                  vertical: verticalPadding, horizontal: horizontalPadding),
              child: Text(
                textAlign: TextAlign.center,
                "Double Tap Anywhere to Enable Camera",
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 20,
                  color: Colors.grey.shade600,
                ),
              ),
            ),
          ],
        ),
      ),
      ),
    );
  }
}
