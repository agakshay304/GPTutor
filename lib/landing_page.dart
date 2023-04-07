import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:gptutor/topics.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'home_page.dart';
import 'widgets/colors.dart';

class LandingPage extends StatefulWidget {
  const LandingPage({Key? key}) : super(key: key);

  @override
  State<LandingPage> createState() => _LandingPageState();
}

class _LandingPageState extends State<LandingPage> {
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
    return Scaffold(
      appBar: AppBar(
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            SvgPicture.asset(
              'assets/images/logo.svg',
              height: 40,
            ),
            SvgPicture.asset('assets/images/avatar.svg', height: 40),
          ],
        ),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 30),
            Center(
                child: SvgPicture.asset('assets/images/moto.svg', height: 30)),
            const SizedBox(height: 30),
            SizedBox(
              height: MediaQuery.of(context).size.height * 0.55,
              child: ListView(
                children: [
                  for (var i = 0; i < topics.length; i++)
                    Card(
                      child: ListTile(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                        textColor: Colors.white,
                        tileColor: i == 0 ? primaryColor : secondaryColor,
                        trailing: i == 0
                            ? const Icon(Icons.lock_open, color: Colors.white)
                            : const Icon(Icons.lock, color: Colors.white),
                        title: Center(child: Text(topics[i].name)),
                        onTap: () {
                          if (i == 0) {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => const HomePage(),
                              ),
                            );
                          } else {
                            showDialog(
                              context: context,
                              builder: (context) {
                                return AlertDialog(
                                  title: const Text('Alert'),
                                  content:
                                      const Text('This Topic is not unlocked'),
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
            Center(
                child: SvgPicture.asset(
              'assets/images/developer.svg',
              height: 100,
            )),
          ],
        ),
      ),
    );
  }
}
