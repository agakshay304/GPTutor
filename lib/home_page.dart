import 'dart:async';
import "package:flutter/material.dart";
import 'package:flutter_animated_dialog/flutter_animated_dialog.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/svg.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:gptutor/openai_service.dart';
import 'package:gptutor/results_screen.dart';
import 'package:gptutor/topics.dart';
import 'package:lottie/lottie.dart';
import 'gp_provider.dart';
import 'widgets/colors.dart';

class HomePage extends ConsumerStatefulWidget {
  final int index;
  const HomePage({Key? key, required this.index}) : super(key: key);

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
  bool _btnactive = false;
  bool _isLoadingScreen = false;
  String? _speech;
  String? _explaination;

  StepState ss1 = StepState.indexed;
  StepState ss2 = StepState.indexed;
  StepState ss3 = StepState.indexed;

  final TextEditingController _answer = TextEditingController();

  Map<String, int> topicWiseCorrectAnswers = {};

  @override
  void initState() {
    super.initState();

    currentTopicIndex = widget.index;
    callexplain();
  }

  //call explaination
  void callexplain() {
    Future.delayed(const Duration(milliseconds: 30), () {
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
          switch (currentQuestionIndex) {
            case 0:
              ss1 = StepState.complete;
              break;
            case 1:
              ss2 = StepState.complete;
              break;
            case 2:
              ss3 = StepState.complete;
              break;
            default:
          }
          setState(() {});
          _correctDialog();
        }
        correctAnswersCount++;
        topicWiseCorrectAnswers[topics[currentTopicIndex].name] =
            correctAnswersCount;
      } else {
        _speak("Incorrect answer");
        if (currentQuestionIndex !=
            topics[currentTopicIndex].questions.length - 1) {
          switch (currentQuestionIndex) {
            case 0:
              ss1 = StepState.error;
              break;
            case 1:
              ss2 = StepState.error;
              break;
            case 2:
              ss3 = StepState.error;
              break;
            default:
          }
          setState(() {});
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
            // ignore: use_build_context_synchronously
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) {
                return ResultScreen(
                    topicWiseCorrectAnswers: topicWiseCorrectAnswers);
              }),
            );
          } else {
            currentTopicIndex++;
            // ignore: use_build_context_synchronously
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) {
                return HomePage(index: currentTopicIndex);
              }),
            );
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
          ss1 = StepState.indexed;
          ss2 = StepState.indexed;
          ss3 = StepState.indexed;
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
      print("Explain CurrentTopicIndex: $currentTopicIndex");
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
          content: const Text(
              "You did not answer at least 2 out of 3 questions correctly for the current topic. Please try again."),
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
    Navigator.of(context).push(
      PageRouteBuilder(
          barrierColor: Colors.white,
          pageBuilder: (context, _, __) => Scaffold(
                appBar: AppBar(
                  automaticallyImplyLeading: false,
                  title: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          Image.asset(
                            'assets/images/logo.png',
                            height: 40,
                            width: 40,
                          ),
                          SvgPicture.asset(
                            'assets/images/title.svg',
                            height: 40,
                            width: 40,
                            allowDrawingOutsideViewBox: true,
                          ),
                        ],
                      ),
                      SvgPicture.asset('assets/images/avatar.svg', height: 40),
                    ],
                  ),
                  centerTitle: true,
                ),
                body: Column(
                  children: [
                    AlertDialog(
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10)),
                      backgroundColor: primaryColor,
                      title: Center(
                        child: Text(
                          topics[currentTopicIndex].name,
                          style: const TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      content: SizedBox(
                        height: MediaQuery.of(context).size.height * 0.5,
                        child: SingleChildScrollView(
                          child: Text(
                            _explaination!,
                            style: const TextStyle(color: Colors.white),
                            textAlign: TextAlign.justify,
                          ),
                        ),
                      ),
                      actionsPadding: const EdgeInsets.all(0),
                      actions: [
                        Container(
                          decoration: const BoxDecoration(
                            borderRadius: BorderRadius.only(
                              bottomLeft: Radius.circular(10),
                              bottomRight: Radius.circular(10),
                            ),
                            color: secondaryColor,
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              TextButton(
                                onPressed: () {
                                  Navigator.pop(context);
                                  flutterTts.stop();
                                  _explain();
                                },
                                child: const Text("Explain again",
                                    style: TextStyle(color: Colors.white)),
                              ),
                              TextButton(
                                onPressed: () {
                                  flutterTts.stop();
                                  Navigator.pop(context);
                                },
                                child: const Text("Proceed",
                                    style: TextStyle(color: Colors.white)),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
          opaque: true),
    );
  }

  @override
  Widget build(BuildContext context) {
    final gptRef = ref.watch(gptProvider);
    int current_step = 0;
    List<Step> steps = [
      Step(
        title: Text(''),
        content: Text(''),
        isActive: true,
        state: ss1,
      ),
      Step(
        title: Text(''),
        content: Text(''),
        isActive: true,
        state: ss2,
      ),
      Step(
        title: Text(''),
        content: Text(''),
        // state: StepState.editing,
        isActive: true,
        state: ss3,
      ),
    ];
    return _isLoadingScreen && !completed
        ? Scaffold(
            body: Center(
              child: Lottie.asset(
                'assets/lottie/test.json',
                width: 100,
                height: 100,
              ),
            ),
          )
        : Scaffold(
            appBar: AppBar(
              automaticallyImplyLeading: false,
              title: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      Image.asset(
                        'assets/images/logo.png',
                        height: 40,
                        width: 40,
                      ),
                      SvgPicture.asset(
                        'assets/images/title.svg',
                        height: 40,
                        width: 40,
                        allowDrawingOutsideViewBox: true,
                      ),
                    ],
                  ),
                  SvgPicture.asset('assets/images/avatar.svg', height: 40),
                ],
              ),
              centerTitle: true,
            ),
            body: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      height: 41,
                      decoration: BoxDecoration(
                        color: primaryColor,
                        borderRadius: BorderRadius.circular(5),
                      ),
                      child: Center(
                        child: Text(
                          topics[currentTopicIndex].name,
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 17,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 80,
                      child: Theme(
                        data: ThemeData(
                            colorScheme: Theme.of(context)
                                .colorScheme
                                .copyWith(primary: primaryColor)),
                        child: Stepper(
                          elevation: 0,
                          controlsBuilder: (context, controller) {
                            return const SizedBox.shrink();
                          },
                          currentStep: current_step,
                          steps: steps,
                          type: StepperType.horizontal,
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8.0,
                      ),
                      child: Text(
                        "${currentQuestionIndex + 1}. ${topics[currentTopicIndex].questions[currentQuestionIndex]}",
                        style: const TextStyle(
                          fontSize: 17,
                          color: primaryColor,
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    Material(
                      elevation: 5,
                      borderRadius: BorderRadius.circular(5),
                      child: TextFormField(
                        style: const TextStyle(
                          color: secondaryColor,
                        ),
                        controller: _answer,
                        onChanged: (value) => setState(() {
                          _btnactive = true;
                        }),
                        keyboardType: TextInputType.multiline,
                        maxLines: 7,
                        cursorColor: primaryColor,
                        decoration: InputDecoration(
                          filled: true,
                          fillColor: Colors.white,
                          border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10),
                              borderSide: BorderSide.none),
                          contentPadding: const EdgeInsets.all(10),
                          hintText: "Enter your answer here",
                          hintStyle: const TextStyle(
                            color: secondaryColor,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(
                      height: 40,
                    ),
                    Center(
                      child: SizedBox(
                        width: 200,
                        height: 50,
                        child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              primary: primaryColor,
                              shape: const RoundedRectangleBorder(
                                borderRadius: BorderRadius.all(
                                  Radius.circular(10),
                                ),
                              ),
                            ),
                            onPressed: _btnactive == false
                                ? null
                                : _isLoading
                                    ? null
                                    : () {
                                        var prevTopic = currentTopicIndex;
                                        _submit().then((value) {
                                          gptRef.setCurrentTopicIndex(
                                            currentTopicIndex,
                                          );
                                          var newTopic =
                                              gptRef.currentTopicIndex;
                                          if (prevTopic != newTopic) {
                                            gptRef.setUnlockedTopics(newTopic);
                                          }
                                        });
                                      },
                            child: _isLoading
                                ? const CircularProgressIndicator(
                                    strokeWidth: 1,
                                  )
                                : const Text('Submit',
                                    style: TextStyle(color: Colors.white))),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
  }
}
