import 'package:flutter/material.dart';
import 'dart:async';

class Game2 extends StatefulWidget {
  const Game2({super.key});
  @override
  State<Game2> createState() => _Game2State();
}

class _Game2State extends State<Game2> {
  final TextEditingController _controller = TextEditingController();
  List<Map<String, String>> levels = [
    {
      'code': '''
function calculateSum(a, b) {
  let sum = a + b;
  console.log("The sum is: " + sum);
}
calculateSum(5, 10);
''',
      'correctAnswer': 'console.log("The sum is: " + sum);',
      'hint': 'Look closely at how strings are concatenated in JavaScript!',
    },
    {
      'code': '''
function multiply(a, b) {
  return a * b;
}
let result = multiply(5, 10);
console.log(result);
''',
      'correctAnswer': 'let result = multiply(5, 10);',
      'hint': 'Make sure to provide both arguments when calling the function!',
    },
    {
      'code': '''
const person = {
  name: "Alice",
  age: 25,
};
console.log("Name: " + person.name + " Age: " + person.age);
''',
      'correctAnswer':
          'console.log("Name: " + person.name + " Age: " + person.age);',
      'hint': 'Check how you are concatenating the age property!',
    },
  ];

  int currentLevel = 0;
  String feedback = '';
  int remainingTime = 120; // 2 minutes in seconds
  Timer? timer;

  @override
  void initState() {
    super.initState();
    startTimer();
  }

  void startTimer() {
    timer = Timer.periodic(Duration(seconds: 1), (Timer timer) {
      if (remainingTime > 0) {
        setState(() {
          remainingTime--;
        });
      } else {
        timer.cancel();
        setState(() {
          feedback =
              'Time is up! The correct answer was:\n${levels[currentLevel]['correctAnswer']}';
          _controller.clear();
        });
      }
    });
  }

  void checkAnswer() {
    if (_controller.text.trim() == levels[currentLevel]['correctAnswer']) {
      setState(() {
        feedback =
            'Correct! The correct line is:\n${levels[currentLevel]['correctAnswer']}';
        timer?.cancel();
        currentLevel++;
        remainingTime = 120; // Reset timer for next level
        _controller.clear();
        if (currentLevel < levels.length) {
          startTimer();
        } else {
          feedback = 'Congratulations! You completed all levels!';
        }
      });
    } else {
      setState(() {
        feedback = 'That\'s not quite right. Try again!';
      });
    }
  }

  void showHint() {
    setState(() {
      feedback += '\nHint: ${levels[currentLevel]['hint']}';
    });
  }

  @override
  void dispose() {
    timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Find the Error Game'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Level ${currentLevel + 1}',
                style:
                    const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 10),
              const Text(
                'Identify and fix the error in the Node.js code below:',
                style: TextStyle(fontSize: 16),
              ),
              const SizedBox(height: 10),
              SelectableText(
                levels[currentLevel]['code']!,
                style: const TextStyle(fontFamily: 'monospace', fontSize: 16),
              ),
              const SizedBox(height: 20),
              TextField(
                controller: _controller,
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: 'Type your correction here',
                ),
                maxLines: 1,
              ),
              const SizedBox(height: 10),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  ElevatedButton(
                    onPressed: checkAnswer,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blue,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(
                          horizontal: 20, vertical: 10),
                      textStyle: const TextStyle(fontSize: 16),
                    ),
                    child: const Text('Submit'),
                  ),
                  ElevatedButton(
                    onPressed: showHint,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.orange,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(
                          horizontal: 20, vertical: 10),
                      textStyle: const TextStyle(fontSize: 16),
                    ),
                    child: const Text('Hint'),
                  ),
                ],
              ),
              const SizedBox(height: 20),
              Text(
                feedback,
                style: const TextStyle(fontSize: 16, color: Colors.green),
              ),
              const SizedBox(height: 20),
              Text(
                'Time Remaining: ${remainingTime ~/ 60}:${(remainingTime % 60).toString().padLeft(2, '0')}',
                style: const TextStyle(fontSize: 16, color: Colors.red),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
