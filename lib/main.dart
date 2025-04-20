import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'package:string_similarity/string_similarity.dart';

void main() {
  runApp(MentalHealthApp());
}

class MentalHealthApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Mental Illness',
      theme: ThemeData.dark(),
      home: MentalHealthHomePage(),
      debugShowCheckedModeBanner: false,
    );
  }
}

class MentalHealthHomePage extends StatefulWidget {
  @override
  _MentalHealthHomePageState createState() => _MentalHealthHomePageState();
}

class _MentalHealthHomePageState extends State<MentalHealthHomePage> {
  List<dynamic> _data = [];
  TextEditingController _controller = TextEditingController();
  String _response = "";

  @override
  void initState() {
    super.initState();
    loadJson();
  }

  Future<void> loadJson() async {
    String jsonString = await rootBundle.loadString('assets/mental_health_data.json');
    setState(() {
      _data = json.decode(jsonString);
    });
  }

  void analyzeQuestion(String userInput) {
  double bestScore = 0.0;
  String bestAnswer = "Sorry, I couldn't find a suitable answer.";

  for (var item in _data) {
    String question = item['Questions'];
    double score = StringSimilarity.compareTwoStrings(userInput.toLowerCase(), question.toLowerCase());

    if (score > bestScore && score > 0.3) { // adjust the threshold if needed
      bestScore = score;
      bestAnswer = item['Answers'];
    }
  }

  setState(() {
    _response = bestAnswer;
  });
}

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('      Mental Illness')),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          children: [
            TextField(
              controller: _controller,
              decoration: InputDecoration( 
                labelText: "Ask a question....",
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 40),
            ElevatedButton(
              onPressed: () => analyzeQuestion(_controller.text),
              child: Text("Get Answer"),
            ),
            SizedBox(height: 20),
            Expanded(
              child: SingleChildScrollView(
                child: Text(
                  _response,
                  style: TextStyle(fontSize: 16),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}