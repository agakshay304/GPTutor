import 'dart:convert';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:http/http.dart' as http;
import 'package:gptutor/openai_model.dart';
import 'package:gptutor/config.dart';

final openAIServiceProvider =
    StateNotifierProvider<OpenAIService, OpenAI>((ref) {
  return OpenAIService();
});

class OpenAIService extends StateNotifier<OpenAI> {
  var temp =
      'Give answer in one word that is whether the given answer is correct or incorrect. If correct then type Yes and if incorrect then type No.';
  OpenAIService()
      : super(
          const OpenAI(
            messages: [],
            isLoading: false,
          ),
        );

  Future<String> isArtPromptAPI(String question, String answer) async {
    // can use `completions` api only but the responses are not smart
    // sometimes wont be able to identify
    try {
        final content = await getAnswer(question, answer);
        state = state.copyWith(
          isLoading: false,
        );
        return content;
      }
     catch (e) {
      state = state.copyWith(
        isLoading: false,
      );
      print(e.toString());
    }
    return 'Some Error Ocurred';
  }

  Future<String> getAnswer(String question, String answer) async {
    state = state.copyWith(
      messages: [
        ...state.messages,
        {
          'role': 'user',
          'content': '$temp $question Answer: $answer',
        },
      ],
    );

    try {
      final res = await http.post(
        Uri.parse('https://api.openai.com/v1/chat/completions'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $openAIKey',
        },
        body: jsonEncode({
          'model': 'gpt-3.5-turbo',
          'messages': state.messages,
        }),
      );

      if (res.statusCode == 200) {
        String content =
            jsonDecode(res.body)['choices'][0]['message']['content'];
        content = content.trim();
        state = state.copyWith(
          messages: [
            ...state.messages,
            {
              'role': 'assistant',
              'content': content,
            },
          ],
        );
        return content;
      }
      // this error might occur because status code is not 200
      // maybe because we have exhausted the api meaning gone
      // over the limits
      return 'An internal error occurred';
    } catch (e) {
      print(e.toString());
    }
    return 'Some unexpected error occurred';
  }

  //A function which takes a topic and returns a string which has the explaination of the topic
  Future<String> isTopicAPI(String topic) async {
    try {
      final topicContent = await getTopicExplanation(topic);
      state = state.copyWith(
        isLoading: false,
      );
      return topicContent;
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
      );
      print(e.toString());
    }
    return 'Some Error Ocurred';
  }

  Future<String> getTopicExplanation(String topic) async {
    state = state.copyWith(
      messages: [
        ...state.messages,
        {
          'role': 'user',
          'content': topic,
        },
      ],
    );

    try {
      final res = await http.post(
        Uri.parse('https://api.openai.com/v1/chat/completions'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $openAIKey',
        },
        body: jsonEncode({
          'model': 'gpt-3.5-turbo',
          'messages': state.messages,
        }),
      );

      if (res.statusCode == 200) {
        String content =
            jsonDecode(res.body)['choices'][0]['message']['content'];
        content = content.trim();
        state = state.copyWith(
          messages: [
            ...state.messages,
            {
              'role': 'assistant',
              'content': content,
            },
          ],
        );
        return content;
      }
      return 'An internal error occurred';
    } catch (e) {
      print(e.toString());
    }
    return 'Some unexpected error occurred';
  }
}
