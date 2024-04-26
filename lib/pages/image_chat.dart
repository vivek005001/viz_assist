import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';
import 'package:dash_chat_2/dash_chat_2.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:http/http.dart' as http;
import 'package:http_parser/http_parser.dart' as http_parser;

class ChatPage extends StatefulWidget {
  const ChatPage({Key? key, required this.imageFile, required String message}) : super(key: key);
  final File imageFile;

  @override
  State<ChatPage> createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  List<ChatMessage> messages = [];

  ChatUser currentUser = ChatUser(id: '0', firstName: 'Me');
  ChatUser queryBot = ChatUser(id: '1', firstName: 'VizAssist', profileImage: 'https://w1.pngwing.com/pngs/278/853/png-transparent-line-art-nose-chatbot-internet-bot-artificial-intelligence-snout-head-smile-black-and-white.png');
  ChatMessage testMessage = ChatMessage(
    text: "message.text",
    user: ChatUser(id: '2', firstName: 'Test'),
    createdAt: DateTime.now(),
  );
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text('Image Chat'),
      ),
      body:
      _buildUI(),
    );
  }
  Widget _buildUI() {
    return DashChat(
        inputOptions: InputOptions(trailing: [IconButton(onPressed: _sendMediaMessage, icon: const Icon(Icons.image),)]),
        currentUser: currentUser,
        onSend: _sendMessage,
        messages: messages);
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
      messages.insert(0, userMessage);
    });

    // Check if the message contains a file
    File? file = widget.imageFile;

    // Send the API request with the message and file (if any)
    String? responseText;
    responseText = await _sendApiRequest(userMessage, file);
    print("responseText: $responseText");

    // Create a response message and add it to the list
    ChatMessage responseMessage = ChatMessage(
      text: responseText,
      user: queryBot, // Assuming the API response is from a bot user with id 0
      createdAt: DateTime.now(),
    );

    setState(() {
      messages.insert(0, responseMessage);
    });
  }

  Future<String> _sendApiRequest(ChatMessage chatMessage, File file) async {
    var uri = Uri.parse('https://dfa9-34-139-66-56.ngrok-free.app/chat');
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
    }
    else {
      print("Failed to upload");
      // print error
      print("Server response: $res");
    }
    return 'text';
  }

  void _sendMediaMessage() async {
    ImagePicker picker = ImagePicker();
    XFile? file = await picker.pickImage(source: ImageSource.gallery);
    if(file != null) {
      ChatMessage chatMessage = ChatMessage(user: currentUser, createdAt: DateTime.now(), text: "Describe this image", medias: [
        ChatMedia(url: file.path, fileName: "", type: MediaType.image)
      ]);
      _sendMessage(chatMessage);
    }
  }

}

