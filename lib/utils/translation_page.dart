import 'package:flutter/material.dart';
import 'package:translator/translator.dart';

class LanguageTranslationPage extends StatefulWidget {
  @override
  _LanguageTranslationPageState createState() => _LanguageTranslationPageState();
}

class _LanguageTranslationPageState extends State<LanguageTranslationPage> {
  final List<String> languages = ['Select Language', 'Hindi', 'English', 'Japanese'];
  String originLanguage = 'English';
  String destinationLanguage = 'Select Language';
  String output = "";
  final TextEditingController inputController = TextEditingController();

  void translate(String src, String dest, String input) async {
    GoogleTranslator translator = GoogleTranslator();
    var translation = await translator.translate(input, from: src, to: dest);
    setState(() {
      output = translation.text.toString();
    });
    if (src == '--' || dest == '--') {
      setState(() {
        output = 'Fail to translate';
      });
    }
  }

  String getLanguageCode(String language) {
    if (language == "English") {
      return 'en';
    } else if (language == "Hindi") {
      return 'hi';
    } else if (language == "Japanese") {
      return 'ja';
    } else if (language == "Select Language") {
      return '--';
    }
    return "--";
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[900],
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: 16),
            // TextField(
            //   controller: inputController,
            //   style: TextStyle(color: Colors.white),
            //   decoration: InputDecoration(
            //     hintText: 'Enter text',
            //     hintStyle: TextStyle(color: Colors.grey),
            //     border: OutlineInputBorder(
            //       borderSide: BorderSide(color: Colors.grey),
            //     ),
            //     enabledBorder: OutlineInputBorder(
            //       borderSide: BorderSide(color: Colors.grey),
            //     ),
            //   ),
            // ),
            SizedBox(height: 16),
            Row(
              children: [
                SizedBox(width: 40),
                Expanded(
                  child: DropdownButtonFormField<String>(
                    focusColor: Colors.grey[900],
                    iconDisabledColor: Colors.grey,
                    iconEnabledColor: Colors.white,
                    hint: Text(
                      destinationLanguage,
                      style: TextStyle(color: Colors.white),
                    ),
                    dropdownColor: Colors.grey[800],
                    icon: Icon(Icons.keyboard_arrow_down, color: Colors.white),
                    items: languages.map((String dropDownStringItem) {
                      return DropdownMenuItem<String>(
                        value: dropDownStringItem,
                        child: Text(
                          dropDownStringItem,
                          style: TextStyle(color: Colors.white),
                        ),
                      );
                    }).toList(),
                    onChanged: (String? value) {
                      setState(() {
                        destinationLanguage = value!;
                      });
                    },
                  ),
                ),
              ],
            ),
            SizedBox(height: 16),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.grey[800],
                foregroundColor: Colors.white,
              ),
              onPressed: () {
                String src = getLanguageCode(originLanguage);
                String dest = getLanguageCode(destinationLanguage);
                String input = inputController.text;

                // Initiate translation
                translate(src, dest, input);

                // Navigate back to the home page
                Navigator.pop(context);
              },
              child: Text("Done"),
            ),


            SizedBox(height: 16),
            // Text(
            //   'Output:',
            //   style: TextStyle(
            //     fontSize: 18,
            //     fontWeight: FontWeight.bold,
            //     color: Colors.white,
            //   ),
            // ),
            SizedBox(height: 8),
            // Text(
            //   output,
            //   style: TextStyle(color: Colors.white),
            // ),
          ],
        ),
      ),
    );
  }
}