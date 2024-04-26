import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:image_speak/pages/image_chat.dart';
import 'chat.dart';
import 'package:http/http.dart' as http;

class DetailsPage extends StatefulWidget {
  // requires imagePath
  const DetailsPage(
      {Key? key, required this.imagePath, required this.imageFile})
      : super(key: key);
  final String imagePath;
  final File imageFile;

  @override
  State<DetailsPage> createState() => _DetailsPageState();
}

Future<String> encodeImage(String imagePath) async {
  File imageFile = File(imagePath);
  List<int> imageBytes = await imageFile.readAsBytes();
  String encodedString = base64Encode(imageBytes);
  return encodedString;
}

class RequestResult {
  final String text;
  final String title;

  RequestResult(this.text, this.title);
}

Future<RequestResult> makeRequest(path, File file) async {
  var request = http.MultipartRequest(
      'POST', Uri.parse('https://dfa9-34-139-66-56.ngrok-free.app/caption'));
  request.files.add(http.MultipartFile.fromBytes(
      'file', file.readAsBytesSync(),
      filename: file.path.split('/').last));
  var streamedResponse = await request.send();
  var res = await http.Response.fromStream(streamedResponse);
  var responseBody = json.decode(res.body);
  String text = responseBody['content'];
  String title = responseBody['title'];
  if (res.statusCode == 200) {
    print("Uploaded!");
    print("Description: $text");
    print("Title: $title");
    return RequestResult(text, title);
  } else {
    print("Failed to upload");
    // print error
    print("Server response: $res");
  }
  return RequestResult('text', 'title');
}

class _DetailsPageState extends State<DetailsPage> {
  final FlutterTts flutterTts = FlutterTts();

  RequestResult result =
      RequestResult(" Loading Description...", " Loading Title...");

  @override
  void initState() {
    super.initState();
    // Call a separate function to handle the asynchronous operation
    _initializeRequest();
  }

  Future<void> _initializeRequest() async {
    // Call your async function here
    RequestResult requestResult =
        await makeRequest(widget.imagePath, widget.imageFile);
    setState(() {
      result = requestResult;
    });
  }

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
      body: Column(
        children: [
          Expanded(
            child: Stack(
              children: [
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
                            ],
                          ),
                        ),
                        width: MediaQuery.of(context).size.width,
                        height: MediaQuery.of(context).size.height * 0.50,
                        decoration: BoxDecoration(
                          image: DecorationImage(
                            image: FileImage(File(imagePath)),
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                      Container(
                        margin: const EdgeInsets.symmetric(horizontal: 20),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const SizedBox(
                              height: 20,
                            ),
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    SizedBox(
                                      width: 300,
                                      height:
                                          60, // Adjust this height according to your layout needs
                                      child: Flexible(
                                        child: Text(
                                          result.title.substring(1),
                                          style: const TextStyle(
                                            color: Colors.white,
                                            fontSize: 20,
                                            fontWeight: FontWeight.w600,
                                          ),
                                        ),
                                      ),
                                    ),
                                    const SizedBox(
                                      height: 10,
                                    ),
                                    const Text(
                                      "Description:",
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
                                      "", // "Speech"
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 15,
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                    const SizedBox(
                                      width: 0,
                                    ),
                                    InkWell(
                                      onTap: () => speak(result.text),
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
                              height: 5,
                            ),
                            Padding(
                              padding: const EdgeInsets.only(right: 20),
                              child: SizedBox(
                                height: 200, // Set a fixed height
                                child: ListView(
                                  scrollDirection: Axis.vertical,
                                  children: [
                                    Text(
                                      result.text.substring(1),
                                      style: const TextStyle(
                                        color: Colors.white38,
                                        fontSize: 15,
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            )

,
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                // the bottom chat bar
                Positioned(
                  bottom: 0,
                  left: 0,
                  right: 0,
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 20, vertical: 10),
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
                                color: Colors
                                    .white), // Ensure text color is visible
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
                            print(
                                "Typed Text: $text"); // Check if text is captured
                            textController.clear();
                            // Navigate to ChatScreen with the text and image path
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => ChatPage(
                                  message: text,
                                  imageFile: widget.imageFile,
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
              ],
            ),
          ),
        ],
      ),
    );
  }
}
