import 'dart:async';
import 'package:animate_do/animate_do.dart';
import "package:flutter/material.dart";
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gptutor/openai_service.dart';
import 'package:gptutor/topics.dart';

class HomePage extends ConsumerStatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  ConsumerState<HomePage> createState() => _HomePageState();
}

class _HomePageState extends ConsumerState<HomePage> {
  int correctAnswersCount = 0;
  int currentTopicIndex = 0;
  int currentQuestionIndex = 0;
  final TextEditingController _answer = TextEditingController();
  bool _isLoading = false;
  String? _speech;

  Future<void> _submit() async {
    setState(() {
      _isLoading = true;
    });

    try {
      final currentQuestion =
          topics[currentTopicIndex].questions[currentQuestionIndex];
      final speech = await ref
          .read(openAIServiceProvider.notifier)
          .isArtPromptAPI(currentQuestion, _answer.text);
      setState(() {
        _speech = speech;
      });
      print(speech);

      if (_speech?.toLowerCase().contains("correct.") == true) {
        correctAnswersCount++;
      }

      currentQuestionIndex++;

      // TODO: implement logic to only change the topic when 3 questions are answered correctly of the current topic.
    } finally {
      setState(() {
        _isLoading = false;
        _answer.clear();
      });
    }
  }

  void _showSuccessDialog() {
    showDialog(
      context: context,
      builder: (_) {
        return AlertDialog(
          title: const Text("Congratulations!"),
          content: const Text("You have successfully completed all topics."),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: const Text("OK"),
            ),
          ],
        );
      },
    );
  }

  void _showFailureDialog() {
    showDialog(
      context: context,
      builder: (_) {
        return AlertDialog(
          title: const Text("Try again!"),
          content: const Text("You did not pass this topic. Please try again."),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: const Text("OK"),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          elevation: 0,
          leading: IconButton(
            color: Colors.black,
            onPressed: () {},
            icon: const Icon(Icons.menu),
          ),
          centerTitle: true,
          title: BounceInDown(
            child: const Text(
              "GPTutor",
              style: TextStyle(color: Colors.black),
            ),
          ),
        ),
        body: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              Container(
                width: 500,
                height: 150,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(10),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.5),
                      spreadRadius: 5,
                      blurRadius: 7,
                      offset: const Offset(0, 3), // changes position of shadow
                    ),
                  ],
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Text(
                      "Topic: ${topics[currentTopicIndex].name}",
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(
                        topics[currentTopicIndex]
                            .questions[currentQuestionIndex],
                        style: const TextStyle(
                          fontSize: 15,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(
                height: 20,
              ),
              IntrinsicWidth(
                child: TextFormField(
                  controller: _answer,
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.all(
                        Radius.circular(10),
                      ),
                    ),
                    hintText: "Enter your answer here",
                  ),
                ),
              ),
              const SizedBox(
                height: 10,
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: SizedBox(
                  width: 200,
                  height: 50,
                  child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        shape: const RoundedRectangleBorder(
                          borderRadius: BorderRadius.all(
                            Radius.circular(10),
                          ),
                        ),
                      ),
                      onPressed: _isLoading ? null : _submit,
                      child: _isLoading
                          ? const CircularProgressIndicator(
                              strokeWidth: 1,
                            )
                          : const Text('Submit')),
                ),
              ),
              const SizedBox(
                height: 10,
              ),
              Text(
                _speech ?? "",
                style: const TextStyle(
                  fontSize: 15,
                ),
              ),
            ],
          ),
        ));
  }
}
