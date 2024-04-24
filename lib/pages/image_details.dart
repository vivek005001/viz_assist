import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'chat.dart';
import 'package:dio/dio.dart';


class DetailsPage extends StatefulWidget {
  // requires imagePath
  const DetailsPage({Key? key, required this.imagePath}) : super(key: key);
  final String imagePath;

  @override
  State<DetailsPage> createState() => _DetailsPageState();
}

class _DetailsPageState extends State<DetailsPage> {
  final FlutterTts flutterTts = FlutterTts();

  @override
  Widget build(BuildContext context) {
    // get the image path
    final imagePath = widget.imagePath;
    final TextEditingController textController = TextEditingController();

    speak(String text) async {
      await flutterTts.setLanguage("en-US");
      await flutterTts.setPitch(1.25);
      await flutterTts.speak(text);
    }

    return Scaffold(
        backgroundColor: const Color(0xff121012),
        body: Stack(children: [
          SingleChildScrollView(
            child: Column(
              children: [
                Container(
                  foregroundDecoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(0),
                      gradient: LinearGradient(
                          begin: Alignment.bottomCenter,
                          end: Alignment.topCenter,
                          colors: [
                            const Color(0xff121012).withOpacity(0.8),
                            Colors.transparent,
                          ])),
                  width: MediaQuery.of(context).size.width,
                  height: MediaQuery.of(context).size.height * 0.50,
                  decoration: BoxDecoration(
                      image: DecorationImage(
                          image: FileImage(File(imagePath)),
                          fit: BoxFit.cover)),
                ),
                Container(
                  margin: const EdgeInsets.symmetric(horizontal: 20),
                  child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // the basic information
                        const SizedBox(
                          height: 20,
                        ),
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  "Image",
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 30,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                                SizedBox(
                                  height: 10,
                                ),
                                Text(
                                  "Description",
                                  style: TextStyle(
                                    color: Colors.white38,
                                    fontSize: 15,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ],
                            ),
                            Row(
                              children: [
                                const Text(
                                  "Speech",
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 15,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                                const SizedBox(
                                  width: 10,
                                ),
                                InkWell(
                                  onTap: () => speak(
                                      "Lorem ipsum dolor sit amet, consectetur adipiscing elit. Nulla nec purus feugiat, molestie ipsum et, consequat nunc. Nulla facilisi. Nullam ac nisi non nisl posuere blandit. Ut sit amet erat sit amet libero lacinia ultricies. Nulla facilisi. Nullam ac nisi non nisl posuere blandit. Ut sit amet erat sit amet libero lacinia ultricies."),
                                  child: const Icon(
                                    Icons.volume_up,
                                    color: Colors.white70,
                                    size: 25,
                                  ),
                                )
                              ],
                            )
                          ],
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        const Padding(
                            padding: EdgeInsets.only(right: 20),
                            child: Text(
                              "Lorem ipsum dolor sit amet, consectetur adipiscing elit. Nulla nec purus feugiat, molestie ipsum et, consequat nunc. Nulla facilisi. Nullam ac nisi non nisl posuere blandit. Ut sit amet erat sit amet libero lacinia ultricies. Nulla facilisi. Nullam ac nisi non nisl posuere blandit. Ut sit amet erat sit amet libero lacinia ultricies."
                              " Lorem ipsum dolor sit amet, consectetur adipiscing elit. Nulla nec purus feugiat, molestie ipsum et, consequat nunc. Nulla facilisi. Nullam ac nisi non nisl posuere blandit. Ut sit amet erat sit amet libero lacinia ultricies. Nulla facilisi. Nullam ac nisi non nisl posuere blandit. Ut sit amet erat sit amet libero lacinia ultricies."
                              " Lorem ipsum dolor sit amet, consectetur adipiscing elit. Nulla nec purus feugiat, molestie ipsum et, consequat nunc. Nulla facilisi. Nullam ac nisi non nisl posuere blandit. Ut sit amet erat sit amet libero lacinia ultricies. Nulla facilisi. Nullam ac nisi non nisl posuere blandit. Ut sit amet erat sit amet libero lacinia ultricies.",
                              style: TextStyle(
                                color: Colors.white38,
                                fontSize: 15,
                                fontWeight: FontWeight.w600,
                              ),
                            )),
                      ]),
                )
              ],
            ),
          ),
          // the bottom chat bar
          Positioned(
            bottom: 0,
            child: Container(
              width: MediaQuery.of(context).size.width,
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
              decoration: const BoxDecoration(
                color: Color(0xff1a1a1a),
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(20),
                  topRight: Radius.circular(20),
                ),
              ),
              child: Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: textController,
                      style: const TextStyle(
                          color: Colors.white), // Ensure text color is visible
                      decoration: const InputDecoration(
                        hintText: "Ask anything...",
                        hintStyle: TextStyle(
                          color: Colors.white38,
                          fontSize: 15,
                          fontWeight: FontWeight.w600,
                        ),
                        border: InputBorder.none,
                      ),
                    ),
                  ),
                  const SizedBox(
                    width: 10,
                  ),
                  InkWell(
                    onTap: () {
                      String text = textController.text;
                      print("Typed Text: $text"); // Check if text is captured
                      textController.clear();
                      // Navigate to ChatScreen with the text and image path
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => ChatScreen(
                            message: text,
                            imagePath: imagePath,
                          ),
                        ),
                      );
                    },
                    child: Container(
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        color: const Color(0xff3a3a3a),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: const Icon(
                        Icons.send,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ]));
  }
}
