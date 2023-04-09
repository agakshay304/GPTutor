import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final gptProvider = ChangeNotifierProvider.autoDispose((ref) => GPTProvider());

class GPTProvider extends ChangeNotifier {
  int currentTopicIndex = 0;

  List<int> unlockedTopics = [0];



  void setCurrentTopicIndex(int index) {
    currentTopicIndex = index;
    print("Current topic index from provider: $currentTopicIndex");
    notifyListeners();
  }

  void setUnlockedTopics(int index) {
    unlockedTopics.add(index);
    print("Unlocked topics from provider: $unlockedTopics");
    notifyListeners();
  }


  Map<String, int> topicWiseCorrectAnswers = {};

  void setTopicWiseCorrectAnswers(String topic, int correctAnswers) {
    topicWiseCorrectAnswers[topic] = correctAnswers;
    print("Topic wise correct answers from provider: $topicWiseCorrectAnswers");
    notifyListeners();
  }
}
