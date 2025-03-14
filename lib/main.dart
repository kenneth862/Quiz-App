import 'package:flutter/material.dart';
import 'dart:async';
import 'abous_us.dart';

void main() {
  runApp(const QuizApp());
}

class QuizApp extends StatelessWidget {
  const QuizApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Quiz App',
      theme: ThemeData(
        primarySwatch: Colors.pink,
      ),
      home: const NameScreen(),
    );
  }
}

class NameScreen extends StatefulWidget {
  const NameScreen({super.key});

  @override
  _NameScreenState createState() => _NameScreenState();
}

class _NameScreenState extends State<NameScreen> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _sectionController = TextEditingController();

  Color currentColor = Colors.pink; // Define currentColor

  // Define a function to update the theme color
  void updateThemeColor(Color color) {
    setState(() {
      currentColor = color;
    });
  }

  void _startQuiz() {
    if (_nameController.text.isNotEmpty && _sectionController.text.isNotEmpty) {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => QuizScreen(
            userName: _nameController.text,
            userSection: _sectionController.text,
          ),
        ),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please enter your name and section')),
      );
    }
  }

  void _showLeaderBoard(BuildContext context) {
    List<Map<String, dynamic>> history = History.getQuizHistory();

    if (history.isEmpty) {
      // Show message if no history exists
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: const Text('Leaderboard'),
          content: const Text('No quiz history available.'),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('OK'),
            ),
          ],
        ),
      );
      return;
    }

    // Sort players based on score in descending order
    history.sort((a, b) => b['score'].compareTo(a['score']));

    showDialog(
      context: context,
      builder: (context) => Dialog(
        backgroundColor: Colors.transparent,
        child: Stack(
          alignment: Alignment.center,
          children: [
            // Background image
            Container(
              width: 475,
              height: 500,
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: AssetImage('images/fl.jpg'),
                  fit: BoxFit.cover,
                ),
                borderRadius: BorderRadius.circular(8.0),
              ),
            ),
            // Content of the dialog
            Container(
              width: 475,
              padding: const EdgeInsets.all(8.0),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(8.0),
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Text(
                    'Leaderboard',
                    style: TextStyle(
                      fontSize: 35,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                  ),
                  const SizedBox(height: 15),
                  SizedBox(
                    height: 400,
                    child: ListView(
                      shrinkWrap: true,
                      children: history.map((entry) {
                        return Padding(
                          padding: const EdgeInsets.symmetric(vertical: 10.0),
                          child: Column(
                            children: [
                              Text(
                                '${entry['name']} (${entry['section']})',
                                style: const TextStyle(fontSize: 25, fontWeight: FontWeight.bold, color: Colors.black),
                              ),
                              Text(
                                'Score: ${entry['score']} / ${entry['totalQuestions']}',
                                style: const TextStyle(fontSize: 20, color: Colors.black),
                              ),
                            ],
                          ),
                        );
                      }).toList(),
                    ),
                  ),
                  TextButton(
                    onPressed: () => Navigator.pop(context),
                    child: const Text(
                      'Close',
                      style: TextStyle(fontSize: 20),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Welcome to the Quiz!'),
        centerTitle: true,
        backgroundColor: currentColor, // Use currentColor for AppBar color
      ),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
          DrawerHeader(
            decoration: BoxDecoration(color: Colors.pink),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(40), 
                  child: Image.asset(
                    'images/dadas.jpg', 
                    width: 80, // Adjust as needed
                    height: 80,
                    fit: BoxFit.cover, // Ensures the image fills the shape
                  ),
                ),
                SizedBox(height: 10),
                Text(
                  'Quiz App Menu',
                  style: TextStyle(fontSize: 24, color: Colors.white),
                ),
              ],
            ),
          ),
            ListTile(
              leading: const Icon(Icons.history),
              title: const Text('Leaderboard'),
              onTap: () {
                _showLeaderBoard(context);
              },
            ),
            ListTile(
              leading: const Icon(Icons.settings),
              title: const Text('Settings'),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => SettingsScreen(
                      updateThemeColor: updateThemeColor, // Pass updateThemeColor function
                      currentColor: currentColor, // Pass currentColor
                    ),
                  ),
                );
              },
            ),
            ListTile(
              leading: Icon(Icons.info),
              title: Text("About Us"),
              onTap: () {
                Navigator.pop(context); // Close the drawer first
                AboutUs.showAboutUsDialog(context); // Show the About Us pop-up
              },
            ),
          ],
        ),
      ),
      body: Stack(
        children: [
          // Background image
          Positioned.fill(
            child: Image.asset(
              'images/school.jpg',
              fit: BoxFit.cover,
            ),
          ),
          Center(
            child: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text(
                      'Enter Your Details!',
                      style: TextStyle(
                        fontSize: 40,
                        fontWeight: FontWeight.bold,
                        color: Colors.red,
                      ),
                    ),
                    const SizedBox(height: 40),
                    SizedBox(
                      width: 500,
                      child: TextField(
                        controller: _nameController,
                        decoration: const InputDecoration(
                          labelText: 'First Name',
                          border: OutlineInputBorder(),
                          prefixIcon: Icon(Icons.person, color: Colors.blue),
                          filled: true,
                          fillColor: Colors.white,
                        ),
                        style: const TextStyle(color: Colors.black),
                        textCapitalization: TextCapitalization.words,
                      ),
                    ),
                    const SizedBox(height: 40),
                    SizedBox(
                      width: 500,
                      child: TextField(
                        controller: _sectionController,
                        decoration: const InputDecoration(
                          labelText: 'Section',
                          border: OutlineInputBorder(),
                          prefixIcon: Icon(Icons.school, color: Colors.blue),
                          filled: true,
                          fillColor: Colors.white,
                        ),
                        style: const TextStyle(color: Colors.black),
                        textCapitalization: TextCapitalization.words,
                      ),
                    ),
                    const SizedBox(height: 20),
                    ElevatedButton(
                      onPressed: _startQuiz,
                      style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 15),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                        backgroundColor: const Color.fromARGB(255, 201, 13, 38),
                        elevation: 5,
                      ),
                      child: const Text(
                        'Start Quiz',
                        style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class SettingsScreen extends StatelessWidget {
  final Function(Color) updateThemeColor;
  final Color currentColor;

  SettingsScreen({
    super.key,
    required this.updateThemeColor,
    required this.currentColor,
  });
  final List<Color> _colors = [
    Colors.pink,
    Colors.blue,
    Colors.green,
    Colors.orange,
    Colors.purple,
    Colors.red,
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Settings'),
        backgroundColor: currentColor,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            const Text(
              'Choose App Theme Color:',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            Wrap(
              spacing: 10,
              children: _colors.map((color) {
                return GestureDetector(
                  onTap: () {
                    updateThemeColor(color);
                    Navigator.pop(context);
                  },
                  child: Container(
                    width: 50,
                    height: 50,
                    decoration: BoxDecoration(
                      color: color,
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: currentColor == color ? Colors.black : Colors.transparent,
                        width: 3,
                      ),
                    ),
                  ),
                );
              }).toList(),
            ),
          ],
        ),
      ),
    );
  }
}


class QuizScreen extends StatefulWidget {
  final String userName;
  final String userSection;

  const QuizScreen({super.key, required this.userName, required this.userSection});

  @override
  _QuizScreenState createState() => _QuizScreenState();
}

class _QuizScreenState extends State<QuizScreen> {
  final List<Map<String, dynamic>> _questions = [
    {'question': 'Which planet is known as the Red Planet?', 'options': ['Earth', 'Venus', 'Mars', 'Jupiter'], 'answer': 'Mars'},
    {'question': 'Which is the largest ocean on Earth?', 'options': ['Atlantic', 'Indian', 'Arctic', 'Pacific'], 'answer': 'Pacific'},
    {'question': 'What is H2O commonly known as?', 'options': ['Oxygen', 'Hydrogen', 'Water', 'Carbon Dioxide'], 'answer': 'Water'},
    {'question': 'Which animal is known as the king of the jungle?', 'options': ['Elephant', 'Tiger', 'Lion', 'Bear'], 'answer': 'Lion'},
    {'question': 'How many continents are there on Earth?', 'options': ['5', '6', '7', '8'], 'answer': '7'},
    {'question': 'What is the capital of France?', 'options': ['London', 'Berlin', 'Paris', 'Madrid'], 'answer': 'Paris'},
    {'question': 'What color is a banana?', 'options': ['Red', 'Yellow', 'Green', 'Blue'], 'answer': 'Yellow'},
    {'question': 'What is 5 + 7?', 'options': ['10', '11', '12', '13'], 'answer': '12'},
    {'question': 'Which is the smallest continent?', 'options': ['Africa', 'Europe', 'Australia', 'Antarctica'], 'answer': 'Australia'},
    {'question': 'What is the opposite of hot?', 'options': ['Cold', 'Warm', 'Cool', 'Heat'], 'answer': 'Cold'},
    {'question': 'How many legs does a spider have?', 'options': ['6', '8', '10', '12'], 'answer': '8'},
    {'question': 'What does a caterpillar turn into?', 'options': ['Bee', 'Butterfly', 'Spider', 'Worm'], 'answer': 'Butterfly'},
    {'question': 'How many sides does a triangle have?', 'options': ['2', '3', '4', '5'], 'answer': '3'},
    {'question': 'What is 20 - 5?', 'options': ['10', '12', '15', '18'], 'answer': '15'},
    {'question': 'Flutter is developed by?', 'options': ['Apple', 'Google', 'Microsoft', 'Amazon'], 'answer': 'Google'},
  ];
  int _currentQuestionIndex = 0;
  int _score = 0;
  int _timeLeft = 30;
  Timer? _timer;

  void _startTimer() {
    _timeLeft = 30;
    _timer?.cancel();
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_timeLeft > 0) {
        setState(() {
          _timeLeft--;
        });
      } else {
        _nextQuestion();
      }
    });
  }

  void _nextQuestion() {
    if (_currentQuestionIndex < _questions.length - 1) {
      setState(() {
        _currentQuestionIndex++;
      });
      _startTimer();
    } else {
      _timer?.cancel();
      _showResult();
    }
  }

  void _checkAnswer(String selectedAnswer) {
    if (selectedAnswer == _questions[_currentQuestionIndex]['answer']) {
      setState(() {
        _score++;
      });
    }
    _nextQuestion();
  }

  void _showResult() {
    // Save the result to the history when the quiz is finished
    History.addQuizHistoryResult(
      name: widget.userName,
      section: widget.userSection,
      score: _score,
      totalQuestions: _questions.length,
    );

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        title: const Text('CONGRATS ! 🎉'),
        content: Text('You have completed the quiz!\nYour Score: $_score/${_questions.length}'),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.popUntil(context, ModalRoute.withName('/')); // Navigate back to NameScreen
            },
            child: const Text('Go to Input'),
          ),
        ],
      ),
    );
  }

  @override
  void initState() {
    super.initState();
    _startTimer();
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('${widget.userName}\'s Quiz'),
        centerTitle: true,
        backgroundColor: Colors.blue,
      ),
      body: Stack(
        children: [
          // Background image
          Positioned.fill(
            child: Image.asset(
              'images/school.jpg',
              fit: BoxFit.cover,
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                LinearProgressIndicator(
                  value: (_currentQuestionIndex + 1) / _questions.length,
                  color: const Color.fromARGB(255, 196, 22, 60),
                  backgroundColor: Colors.grey[300],
                ),
                const SizedBox(height: 20),
                Text(
                  'Time Left: $_timeLeft seconds',
                  style: const TextStyle(fontSize: 18, color: Color.fromARGB(255, 148, 8, 8), fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 20),
                Card(
                  elevation: 10,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(25)),
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Text(
                      _questions[_currentQuestionIndex]['question'],
                      style: const TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
                      textAlign: TextAlign.center,
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                ..._questions[_currentQuestionIndex]['options'].map((option) {
                  return Padding(
                    padding: const EdgeInsets.symmetric(vertical: 5.0),
                    child: ElevatedButton(
                      onPressed: () => _checkAnswer(option),
                      style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 15),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
                        backgroundColor: Colors.white,
                        shadowColor: Colors.black,
                        elevation: 5,
                      ),
                      child: Text(
                        option,
                        style: const TextStyle(fontSize: 25, color: Colors.blue, fontWeight: FontWeight.bold),
                      ),
                    ),
                  );
                }).toList(),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class History {
  static List<Map<String, dynamic>> _quizHistory = [];

  static List<Map<String, dynamic>> getQuizHistory() {
    return _quizHistory;
  }

  static void addQuizHistoryResult({
    required String name,
    required String section,
    required int score,
    required int totalQuestions,
  }) {
    _quizHistory.add({
      'name': name,
      'section': section,
      'score': score,
      'totalQuestions': totalQuestions,
    });
  }
}