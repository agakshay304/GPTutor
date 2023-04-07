/*
 Imagine an AI tutor who wants to teach a particular topic/concept where they would want to ask basic questions to lead the student to learn that concept in a conversational manner.
 There can be 2 separate prompts and a list (or your preferred choice of Data structure. E.g. n-ary tree):
1. The list holds all the topics and subtopics.
2. Prompt1 holds the conversation with the student regarding a given subtopic and decides
between informing about the facts or asking related questions to lead to the concept.
3. Prompt2 checks if the student has engaged sufficiently in the conversation so far in
relation to the current topic/subtopic. Once this prompt decides “yes” to the question “has the student engaged sufficiently” then prompt1 goes to the next subtopic.
 */

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gptutor/landing_page.dart';
import 'package:gptutor/widgets/colors.dart';

import 'home_page.dart';

void main() {
  runApp(
    const ProviderScope(
      child: MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'GPTutor',
      theme: ThemeData.light(useMaterial3: true).copyWith(
        scaffoldBackgroundColor: Colors.white,
        appBarTheme: const AppBarTheme(
          backgroundColor: Colors.white,
        ),
        floatingActionButtonTheme: const FloatingActionButtonThemeData(
          backgroundColor: primaryColor,
        ),
      ),
      home: LandingPage(),
      // home: const Dummy(),
    );
  }
}
