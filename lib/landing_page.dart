import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/svg.dart';
import 'package:gptutor/results_screen.dart';
import 'package:gptutor/topics.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'gp_provider.dart';
import 'home_page.dart';
import 'widgets/colors.dart';

class LandingPage extends ConsumerStatefulWidget {
  const LandingPage({Key? key}) : super(key: key);

  @override
  ConsumerState<LandingPage> createState() => _LandingPageState();
}

class _LandingPageState extends ConsumerState<LandingPage> {
  FlutterTts flutterTts = FlutterTts();

  @override
  void initState() {
    super.initState();
    _speak("Welcome to GPTutor");
  }

  Future _speak(String texttospeech) async {
    await flutterTts.setLanguage("en-US");
    await flutterTts.setPitch(1);
    await flutterTts.speak(texttospeech);
  }

  @override
  Widget build(BuildContext context) {
    final gptRef = ref.watch(gptProvider);
    return Scaffold(
      appBar: AppBar(
        actions: [
          PopupMenuButton(
            icon: SvgPicture.asset('assets/images/avatar.svg', height: 40),
            onSelected: (value) {
              if (value == 1) {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) {
                    return const ResultScreen();
                  }),
                );
              }
              if (value == 2) {
                SystemNavigator.pop();
              }
            },
            itemBuilder: (context) => const [
              const PopupMenuItem(value: 1, child: Text('Performance')),
              const PopupMenuItem(value: 2, child: Text('Exit')),
            ],
          ),
        ],
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
          ],
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 20),
              Center(
                  child:
                      SvgPicture.asset('assets/images/moto.svg', height: 25)),
              const SizedBox(height: 20),
              SizedBox(
                height: MediaQuery.of(context).size.height * 0.49,
                child: ListView(
                  children: [
                    for (var i = 0; i < topics.length; i++)
                      Card(
                        child: ListTile(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                          textColor: Colors.white,
                          tileColor: (gptRef.unlockedTopics.contains(i))
                              ? primaryColor
                              : secondaryColor,
                          trailing: (gptRef.unlockedTopics.contains(i))
                              ? const Icon(Icons.lock_open, color: Colors.white)
                              : const Icon(Icons.lock, color: Colors.white),
                          title: Center(child: Text(topics[i].name)),
                          onTap: () {
                            if ((gptRef.unlockedTopics.contains(i))) {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => HomePage(index: i),
                                ),
                              );
                            } else {
                              showDialog(
                                context: context,
                                builder: (context) {
                                  return AlertDialog(
                                    title: const Text('Alert'),
                                    content: const Text(
                                        'This Topic is not unlocked'),
                                    actions: [
                                      TextButton(
                                        onPressed: () {
                                          Navigator.pop(context);
                                        },
                                        child: const Text('OK'),
                                      ),
                                    ],
                                  );
                                },
                              );
                            }
                          },
                        ),
                      ),
                  ],
                ),
              ),
              const SizedBox(height: 20),
              SizedBox(
                height: MediaQuery.of(context).size.height * 0.2,
                child: Center(
                  child: SvgPicture.asset(
                    'assets/images/developer.svg',
                    height: 100,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
