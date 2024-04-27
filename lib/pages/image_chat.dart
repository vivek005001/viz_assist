import 'dart:convert';
import 'dart:io';
import 'package:dash_chat_2/dash_chat_2.dart';
import 'package:flutter/material.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:http/http.dart' as http;
import 'package:speech_to_text/speech_to_text.dart' as stt;
import 'package:loading_animation_widget/loading_animation_widget.dart';

speak(String text) async {
  final FlutterTts flutterTts = FlutterTts();
  await flutterTts.setLanguage("en-US");
  await flutterTts.setPitch(1.25);
  await flutterTts.speak(text);
}

class ChatPage extends StatefulWidget {
  const ChatPage(
      {Key? key, required this.imageFile, required this.initialMessage})
      : super(key: key);
  final File imageFile;
  final String initialMessage;

  @override
  State<ChatPage> createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  List<ChatMessage> messages = [];

  final stt.SpeechToText _speech = stt.SpeechToText();
  bool isListening = false;
  String _text = 'Press the button and start speaking';
  double _confidence = 1.0;

  void _listen() async {
    if (!isListening) {
      bool available = await _speech.initialize(
        onStatus: (val) => print('onStatus: $val'),
        onError: (val) => print('onError: $val'),
      );
      if (available) {
        setState(() => isListening = true);
        String recognizedText = '';
        _speech.listen(
          onResult: (val) {
            setState(() {
              recognizedText = val.recognizedWords;
              print("RECOGNIZED: $recognizedText");
              if (val.finalResult) {
                ChatMessage newMessage = ChatMessage(
                  text: recognizedText,
                  user: currentUser,
                  createdAt: DateTime.now(),
                );
                _sendMessage(newMessage);
                setState(() => isListening = false);
                recognizedText = ''; // Reset the recognized text
                if (val.hasConfidenceRating && val.confidence > 0) {
                  _confidence = val.confidence;
                }
              }
            });
          },
        );
      }
    } else {
      setState(() => isListening = false);
      _speech.stop();
    }
  }

  ChatUser currentUser = ChatUser(
    id: '0',
    firstName: 'Me',
  );
  ChatUser queryBot = ChatUser(
      id: '1',
      firstName: 'VizAssist',
      profileImage:
          'https://w1.pngwing.com/pngs/278/853/png-transparent-line-art-nose-chatbot-internet-bot-artificial-intelligence-snout-head-smile-black-and-white.png'); // Add a profile image
  ChatMessage initialChatMessage = ChatMessage(
    text: 'Hello! How can I help you today?',
    user: ChatUser(id: '1', firstName: 'VizAssist'),
    createdAt: DateTime.now(),
  );

  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    _speech.initialize(
      onStatus: (val) => print('onStatus: $val'),
      onError: (val) => print('onError: $val'),
    );
    _listen();
  }

  @override
  Widget build(BuildContext context) {
    ThemeData darkTheme = ThemeData(
      appBarTheme: AppBarTheme(
        backgroundColor: Colors.grey[900],
        foregroundColor: Colors.white,
      ),
      colorScheme: ColorScheme.fromSwatch(
              primarySwatch: getMaterialColor(const Color(0xFF4D96AF)))
          .copyWith(background: Colors.grey[900]),
    );

    return GestureDetector(
      onPanUpdate: (details) {
        // Swiping in right direction.
        if (details.delta.dx > 0) {
          Navigator.pop(context);
        }

        // Swiping in left direction.
        if (details.delta.dx < 0) {
          _listen();
        }
      },
      child: MaterialApp(
      title: 'VizAssist',
      debugShowCheckedModeBanner: false,
      theme: darkTheme, // Apply the dark theme
      home: Scaffold(
        appBar: AppBar(
          centerTitle: true,
          title: const Text('VizAssist: Chat'),
        ),
        body: isListening
            ? Center(
                child:
                LoadingAnimationWidget.waveDots(
                  color: Colors.white,
                  size: 100,
                ), // Replace with your desired animation
              )
            : _buildUI(),
      ),
    ),
    );
  }

  Widget _buildUI() {
    if (isLoading) {
      return Center(
        child: LoadingAnimationWidget.beat(
          color: Colors.white,
          size: 100,
        ),
      );
    }
    return DashChat(
      inputOptions: InputOptions(
        trailing: [
          IconButton(
            icon: Icon(isListening ? Icons.mic : Icons.mic_none,
                color: Colors.white),
            onPressed: _listen,
          ),
        ],
      ),
      currentUser: currentUser,
      onSend: _sendMessage,
      messages: messages,
    );
  }

  void _sendMessage(ChatMessage message) async {
    // Get the current user's message
    ChatMessage userMessage = ChatMessage(
      text: message.text,
      user: currentUser,
      createdAt: DateTime.now(),
    );

    // Add the user's message to the list
    setState(() {
      isLoading = true; // Set loading state to true before sending API request
      messages.insert(0, userMessage);
    });

    // Check if the message contains a file
    File? file = widget.imageFile;

    // Send the API request with the message and file (if any)
    String? responseText;
    responseText = await _sendApiRequest(userMessage, file);
    print("responseText: $responseText");
    speak(responseText);

    // Create a response message and add it to the list
    ChatMessage responseMessage = ChatMessage(
      text: responseText,
      user: queryBot, // Assuming the API response is from a bot user with id 0
      createdAt: DateTime.now(),
    );

    setState(() {
      isLoading =
          false; // Set loading state to false after API request is completed
      messages.insert(0, responseMessage);
    });
  }

  Future<String> _sendApiRequest(ChatMessage chatMessage, File file) async {
    var uri = Uri.parse('https://27d1-34-141-232-103.ngrok-free.app/chat');
    uri = uri.replace(queryParameters: {
      'prompt': chatMessage.text,
    });
    var request = http.MultipartRequest('POST', uri);
    request.files.add(http.MultipartFile.fromBytes(
        'file', file.readAsBytesSync(),
        filename: file.path.split('/').last));
    var streamedResponse = await request.send();
    var res = await http.Response.fromStream(streamedResponse);
    var responseBody = json.decode(res.body);
    String text = responseBody['content'];
    if (res.statusCode == 200) {
      print("Uploaded!");
      print("Response: $text");
      return text;
    } else {
      print("Failed to upload");
      // print error
      print("Server response: $res");
    }
    return 'text';
  }
}

MaterialColor getMaterialColor(Color color) {
  final int red = color.red;
  final int green = color.green;
  final int blue = color.blue;
  final int alpha = color.alpha;

  final Map<int, Color> shades = {
    50: Color.fromARGB(alpha, red, green, blue),
    100: Color.fromARGB(alpha, red, green, blue),
    200: Color.fromARGB(alpha, red, green, blue),
    300: Color.fromARGB(alpha, red, green, blue),
    400: Color.fromARGB(alpha, red, green, blue),
    500: Color.fromARGB(alpha, red, green, blue),
    600: Color.fromARGB(alpha, red, green, blue),
    700: Color.fromARGB(alpha, red, green, blue),
    800: Color.fromARGB(alpha, red, green, blue),
    900: Color.fromARGB(alpha, red, green, blue),
  };

  return MaterialColor(color.value, shades);
}
