import 'package:flutter/material.dart';
import 'package:translator/translator.dart';

class LanguageTranslationPage extends StatefulWidget {
  const LanguageTranslationPage({Key? key}) : super(key: key);

  @override
  _LanguageTranslationPageState createState() => _LanguageTranslationPageState();
}

class _LanguageTranslationPageState extends State<LanguageTranslationPage> {
  var languages = ['Hindi', 'English', 'Japanese'];
  var originLanguage = "From";
  var destinationLanguage = "To";
  String output = "";
  TextEditingController languageController = TextEditingController();

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
    }
    return "--";
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black, // Set the background color to black
      appBar: AppBar(
        backgroundColor: Colors.black, // Set the app bar color to black
        title: Text('Language Translation'),
        actions: [
          // You can add your menu icon and language dropdown here
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Translate Text',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Colors.white, // Set the text color to white
              ),
            ),
            SizedBox(height: 16),
            TextField(
              controller: languageController,
              style: TextStyle(color: Colors.white), // Set the text color to white
              decoration: InputDecoration(
                hintText: 'Enter text',
                hintStyle: TextStyle(color: Colors.grey), // Set the hint text color to grey
                border: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.grey), // Set the border color to grey
                ),
                enabledBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.grey), // Set the enabled border color to grey
                ),
              ),
            ),
            SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: DropdownButton<String>(
                    focusColor: Colors.black, // Set the focus color to black
                    iconDisabledColor: Colors.grey, // Set the disabled icon color to grey
                    iconEnabledColor: Colors.white, // Set the enabled icon color to white
                    hint: Text(
                      originLanguage,
                      style: TextStyle(color: Colors.white), // Set the hint text color to white
                    ),
                    dropdownColor: Colors.black, // Set the dropdown background color to black
                    icon: Icon(Icons.keyboard_arrow_down, color: Colors.white), // Set the icon color to white
                    items: languages.map((String dropDownStringItem) {
                      return DropdownMenuItem<String>(
                        value: dropDownStringItem,
                        child: Text(
                          dropDownStringItem,
                          style: TextStyle(color: Colors.white), // Set the dropdown item text color to white
                        ),
                      );
                    }).toList(),
                    onChanged: (String? value) {
                      setState(() {
                        originLanguage = value!;
                      });
                    },
                  ),
                ),
                SizedBox(width: 40),
                Icon(Icons.arrow_right_alt_outlined, color: Colors.white, size: 40), // Set the icon color to white
                SizedBox(width: 40),
                Expanded(
                  child: DropdownButton<String>(
                    focusColor: Colors.black,
                    iconDisabledColor: Colors.grey,
                    iconEnabledColor: Colors.white,
                    hint: Text(
                      destinationLanguage,
                      style: TextStyle(color: Colors.white),
                    ),
                    dropdownColor: Colors.black,
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
            SizedBox(height: 40),
            Padding(
              padding: EdgeInsets.all(8),
              child: TextFormField(
                cursorColor: Colors.white, // Set the cursor color to white
                autofocus: false,
                style: TextStyle(color: Colors.white), // Set the text color to white
                decoration: InputDecoration(
                  labelText: 'Please Enter your text...',
                  labelStyle: TextStyle(fontSize: 15, color: Colors.white), // Set the label text color to white
                  border: OutlineInputBorder(
                    borderSide: BorderSide(
                      color: Colors.white, // Set the border color to white
                      width: 1,
                    ),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(
                      color: Colors.white, // Set the enabled border color to white
                      width: 1,
                    ),
                  ),
                  errorStyle: TextStyle(color: Colors.red, fontSize: 15), // Set the error text color to red
                ),
                controller: languageController,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please Enter text';
                  }
                  return null;
                },
              ),
            ),
            Padding(padding: EdgeInsets.all(8)),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Color(0xff2b3c5a),
                foregroundColor: Colors.white, // Set the text color of the ElevatedButton to white
              ),
              onPressed: () {
                String src = getLanguageCode(originLanguage);
                String dest = getLanguageCode(destinationLanguage);
                String input = languageController.text;
                translate(src, dest, input);
              },
              child: Text("Translate"),
            ),
            SizedBox(height: 16),
            Text(
              'Output:',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.white, // Set the text color to white
              ),
            ),
            SizedBox(height: 8),
            Text(
              output,
              style: TextStyle(color: Colors.white), // Set the text color to white
            ),
          ],
        ),
      ),
    );
  }
}