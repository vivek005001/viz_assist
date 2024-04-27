import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_speak/utils/translation_page.dart';
import '/utils/smart_device_box.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);



  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  // padding constants
  final double horizontalPadding = 40;
  final double verticalPadding = 25;

  // // list of smart devices
  // List mySmartDevices = [
  //   // [ smartDeviceName, iconPath , powerStatus ]
  //   ["Use Camera", "lib/icons/camera.png", false],
  //   ["", "lib/icons/use_camera.png", false],
  //   ["", "lib/icons/fan.png", false],
  //   ["Upload Image", "lib/icons/document.png", false],
  // ];

  // power button switched
  // void powerSwitchChanged(bool value, int index) {
  //   setState(() {
  //     mySmartDevices[index][2] = value;
  //   });
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0D0D0D),
      body: SafeArea(
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
                  // const Icon(
                  //   Icons.person,
                  //   size: 45,
                  //   color: Color(0xFF539FB8),
                  // )

                ],
              ),
            ),

            const SizedBox(height: 20),

            // welcome home
            Padding(
              padding: EdgeInsets.symmetric(horizontal: horizontalPadding),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Welcome",
                    style: TextStyle(fontSize: 20, color: Colors.grey.shade700),
                  ),
                  Text(
                    'Vivek Aggarwal',
                    style: TextStyle(
                      fontFamily: GoogleFonts.bebasNeue().fontFamily,
                      fontSize: 62,
                      color: const Color(0xFF4D96AF),
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
                  fontSize: 24,
                  color: Colors.grey.shade600,
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.only(
                  top: 100), // Adjust the top padding value as needed
              child: Container(
                alignment: Alignment.center,
                child: Image.asset(
                  'lib/icons/camera.png',
                  height: 80,
                  width: 80,
                  color: const Color(0xFF4D96AF),
                  // specify other parameters like width, height, etc. as needed
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.symmetric(vertical: verticalPadding,horizontal: horizontalPadding),
              child: Text(
                "Double Tap Anywhere to Enable Camera",
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 20,
                  color: Colors.grey.shade600,
                ),
              ),
            ),
            // grid
            // Expanded(
            //   child: GridView.builder(
            //     itemCount: 4,
            //     physics: const NeverScrollableScrollPhysics(),
            //     padding: const EdgeInsets.symmetric(horizontal: 20),
            //     gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            //       crossAxisCount: 2,
            //       childAspectRatio: 1 / 1.3,
            //     ),
            //     itemBuilder: (context, index) {
            //       // Check if index is 0 or 1, if yes, set transparent color
            //       final color =
            //           index == 1 || index == 2 ? Colors.transparent : null;
            //       // return SmartDeviceBox(
            //       //   smartDeviceName: mySmartDevices[index][0],
            //       //   iconPath: mySmartDevices[index][1],
            //       //   powerOn: mySmartDevices[index][2],
            //       //   onChanged: (value) => powerSwitchChanged(value, index),
            //       //   index: index,
            //       //   customColor: color,
            //       // );
            //     },
            //   ),
            // )
          ],
        ),
      ),
    );
  }
}
