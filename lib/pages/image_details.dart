import 'dart:convert';
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

Future<String> encodeImage(String imagePath) async {
  File imageFile = File(imagePath);
  List<int> imageBytes = await imageFile.readAsBytes();
  String encodedString = base64Encode(imageBytes);
  return encodedString;
}

Future<String> uploadImage(String imagePath) async {
  String url = "https://api.imgbb.com/1/upload";
  String clientApiKey = "61aa016205031b92495bd11ff19b1d44"; // Replace this with your actual client API key

  // Image data (base64 encoded string)
  String imageData = await encodeImage(imagePath);

  // Request parameters
  Map<String, dynamic> params = {
    "expiration": 600,
    "key": clientApiKey,
  };

  // Form data
  FormData formdata = FormData.fromMap({
    "image": imageData,
  });

  // Creating Dio instance
  Dio dio = Dio();

  try {
    // Making the POST request
    Response response = await dio.post(
      url,
      queryParameters: params,
      data: formdata,
    );

    // Printing the response
    print(response.data);

    Map<String, dynamic> responseData = response.data;

    // Access the 'data' field
    Map<String, dynamic> data = responseData['data'];

    // Access the 'url' field within the 'data' field
    String imageUrl = data['url'];
    print("Image uploaded successfully! at $url");
    return imageUrl;
  } catch (e) {
    print("Error uploading image: $e");
    return "https://tinyjpg.com/images/social/website.jpg";
  }
}

makeRequest(path) async {
  // Define the API endpoint
  String url = 'https://9f7e-34-91-194-123.ngrok-free.app/single_caption';

  // Define the image URL
  String imageUrl = await uploadImage(path);
  print("Fetching image from: $imageUrl");

  // Define headers
  Options options = Options(
    headers: {
      'accept': 'application/json',
    },
  );

  // Create Dio instance
  Dio dio = Dio();

  try {
    // Make the POST request
    Response response = await dio.post(
      url,
      options: options,
      queryParameters: {'image_path': imageUrl},
    );

    // Check if the request was successful (status code 200)
    if (response.statusCode == 200) {
      // Get the 'content' part from the response JSON
      String content = response.data['content'].toString();
      return content;
    } else {
      print('Error: ${response.statusCode}');
      return null;
    }
  } catch (e) {
    print('Error: $e');
    return null;
  }
}


class _DetailsPageState extends State<DetailsPage> {
  final FlutterTts flutterTts = FlutterTts();

  String result = "";

  @override
  void initState() {
    super.initState();
    // Call a separate function to handle the asynchronous operation
    _initializeRequest();
  }

  Future<void> _initializeRequest() async {
    // Call your async function here
    String requestResult = await makeRequest(widget.imagePath);
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
                                  onTap: () => speak(result),
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
                        Padding(
                            padding: const EdgeInsets.only(right: 20),
                            child: Text(
                              result,
                              style: const TextStyle(
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
