import 'dart:async';
import 'package:animate_do/animate_do.dart';
import "package:flutter/material.dart";
import 'package:flutter_animated_dialog/flutter_animated_dialog.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:gptutor/openai_service.dart';
import 'package:gptutor/results_screen.dart';
import 'package:gptutor/topics.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'widgets/progress_bar.dart';

class HomePage extends ConsumerStatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  ConsumerState<HomePage> createState() => _HomePageState();
}

class _HomePageState extends ConsumerState<HomePage> {
  FlutterTts flutterTts = FlutterTts();

  int correctAnswersCount = 0;
  int currentTopicIndex = 0;
  int currentQuestionIndex = 0;
  bool completed = false;
  bool _isLoading = false;
  bool _isLoadingScreen = false;
  String? _speech;
  String? _explaination;

  final TextEditingController _answer = TextEditingController();

  Map<String, int> topicWiseCorrectAnswers = {};

  @override
  void initState() {
    super.initState();

    if (currentQuestionIndex == 0) {
      callexplain();
    }
  }

  //call explaination
  void callexplain() {
    Future.delayed(const Duration(seconds: 1), () {
      _explain();
    });
  }

  @override
  void dispose() {
    super.dispose();
    _answer.dispose();
  }

  Future<void> _submit() async {
    setState(() {
      _isLoading = true;
    });

    try {
      print("CurrentQuestionIndex: $currentQuestionIndex");
      print("CurrentTopicIndex: $currentTopicIndex");
      final currentQuestion =
          topics[currentTopicIndex].questions[currentQuestionIndex];
      final speech = await ref
          .read(openAIServiceProvider.notifier)
          .isArtPromptAPI(currentQuestion, _answer.text);
      setState(() {
        _speech = speech;
      });
      print(_speech);

      if (_speech?.toLowerCase().contains("yes") == true) {
        _speak("Correct answer");
        if (currentQuestionIndex !=
            topics[currentTopicIndex].questions.length - 1) {
          _correctDialog();
        }
        correctAnswersCount++;
        topicWiseCorrectAnswers[topics[currentTopicIndex].name] =
            correctAnswersCount;
      } else {
        _speak("Incorrect answer");
        if (currentQuestionIndex !=
            topics[currentTopicIndex].questions.length - 1) {
          _incorrectDialog();
        }
      }

      print("Correct answers count: $correctAnswersCount");

      if (currentQuestionIndex ==
              topics[currentTopicIndex].questions.length - 1 &&
          !completed) {
        // Check if the user has answered at least 2 out of 3 questions correctly for the current topic
        if (correctAnswersCount >= 2 && !completed) {
          if (currentTopicIndex == topics.length - 1) {
            print("You have completed all the topicssssss!");
            completed = true;
            print("Topic wise correct answers: $topicWiseCorrectAnswers");
            Navigator.push(context, MaterialPageRoute(builder: (context) {
              return ResultScreen(
                  topicWiseCorrectAnswers: topicWiseCorrectAnswers);
            }));
          } else {
            currentTopicIndex++;
          }
          // Reset the current question index and correct answer count for the new topic
          currentQuestionIndex = 0;
          correctAnswersCount = 0;
        } else {
          // Repeat the topic from the first question
          currentQuestionIndex = 0;
          correctAnswersCount = 0;
          print(
              "You did not answer at least 2 out of 3 questions correctly for the current topic. Please try again.");
          _showFailureDialog();
        }

        if (currentQuestionIndex == 0 && currentTopicIndex != 0 && !completed) {
          callexplain();
        }
      } else {
        currentQuestionIndex++;
      }
    } finally {
      setState(() {
        _isLoading = false;
        _answer.clear();
      });
    }
  }

  void _correctDialog() {
    showAnimatedDialog(
      context: context,
      animationType: DialogTransitionType.size,
      curve: Curves.fastOutSlowIn,
      duration: const Duration(milliseconds: 500),
      builder: (BuildContext context) {
        Future.delayed(const Duration(seconds: 1), () {
          Navigator.of(context).pop(); // Dismiss the dialog after 1 second
        });
        return const Center(
          child: SizedBox(
            width: 100,
            height: 100,
            child: Icon(
              Icons.check_circle_outline,
              color: Colors.green,
              size: 80,
            ),
          ),
        );
      },
    );
  }

  void _incorrectDialog() {
    showAnimatedDialog(
      context: context,
      animationType: DialogTransitionType.size,
      curve: Curves.fastOutSlowIn,
      duration: const Duration(milliseconds: 500),
      builder: (BuildContext context) {
        Future.delayed(const Duration(seconds: 1), () {
          Navigator.of(context).pop(); // Dismiss the dialog after 1 second
        });
        return const Center(
          child: SizedBox(
            width: 100,
            height: 100,
            child: Icon(
              Icons.cancel_outlined,
              color: Colors.red,
              size: 80,
            ),
          ),
        );
      },
    );
  }

  Future _speak(String texttospeech) async {
    //change voice
    await flutterTts.setLanguage("en-US");
    await flutterTts.setPitch(1);
    await flutterTts.speak(texttospeech);
  }

  Future<void> _explain() async {
    setState(() {
      _isLoadingScreen = true;
    });

    try {
      print("Explainnnnn CurrentTopicIndex: $currentTopicIndex");
      final currentTopic = topics[currentTopicIndex].name;
      print(currentTopic);
      final explaination = await ref
          .read(openAIServiceProvider.notifier)
          .isTopicAPI(currentTopic);
      setState(() {
        _explaination = explaination;
      });
      print("Explaination $_explaination");
      _showExplainDialog();
      _speak(_explaination!);
    } finally {
      setState(() {
        _isLoadingScreen = false;
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

  void _showExplainDialog() {
    showDialog(
      context: context,
      builder: (_) {
        return AlertDialog(
          title: Text(topics[currentTopicIndex].name),
          content: SingleChildScrollView(child: Text(_explaination!)),
          actions: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                TextButton(
                  onPressed: () {
                    flutterTts.stop();
                    Navigator.pop(context);
                  },
                  child: const Text("OK"),
                ),
                TextButton(
                  onPressed: () {
                    Navigator.pop(context);
                    flutterTts.stop();
                    _explain();
                  },
                  child: const Text("Explain again"),
                ),
              ],
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return _isLoadingScreen && !completed
        ? Scaffold(
            body: Center(
              child: LoadingAnimationWidget.dotsTriangle(
                color: ThemeData.light(useMaterial3: true).primaryColor,
                size: 50,
              ),
            ),
          )
        : Scaffold(
            floatingActionButton: currentQuestionIndex == 0 && !completed
                ? FloatingActionButton(
                    onPressed: () {
                      _explain();
                    },
                    child: const Icon(Icons.help_outline),
                  )
                : null,
            appBar: AppBar(
              automaticallyImplyLeading: false,
              elevation: 0,
              centerTitle: true,
              title: BounceInDown(
                child: Text(
                  topics[currentTopicIndex].name,
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: ThemeData.light(useMaterial3: true).primaryColor,
                  ),
                ),
              ),
            ),
            body: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  children: [
                    ProgressBar(
                        stepNumber: currentQuestionIndex,
                        stepTotal: topics[currentTopicIndex].questions.length),
                    const SizedBox(
                      height: 20,
                    ),
                    SizedBox(
                      width: double.infinity,
                      child: Text(
                        "${currentQuestionIndex + 1}. ${topics[currentTopicIndex].questions[currentQuestionIndex]}",
                        style: const TextStyle(
                          fontSize: 17,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    TextFormField(
                      controller: _answer,
                      maxLines: 10,
                      decoration: InputDecoration(
                        fillColor:
                            ThemeData.light(useMaterial3: true).primaryColor,
                        border: const OutlineInputBorder(
                          borderRadius: BorderRadius.all(
                            Radius.circular(10),
                          ),
                        ),
                        contentPadding: const EdgeInsets.all(10),
                        hintText: "Enter your answer here",
                      ),
                    ),
                    const SizedBox(
                      height: 40,
                    ),
                    SizedBox(
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
                  ],
                ),
              ),
            ),
          );
  }
}
