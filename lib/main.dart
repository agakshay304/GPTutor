import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gptutor/landing_page.dart';
import 'package:gptutor/results_screen.dart';
import 'package:gptutor/widgets/colors.dart';

void main() {
  runApp(
    const ProviderScope(
      child: MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
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
      home: const LandingPage(),
      // home: const ResultScreen(),
      //  topicWiseCorrectAnswers: {
      //    "Intro to ML Training": 1,
      //    "Steps in Training":2,
      //    "Data Collection":3,
      //    "Preprocessing":2,
      //    "Preprocessin":2,
      //  },
      // ),
    );
  }
}
