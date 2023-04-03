import 'dart:convert';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:http/http.dart' as http;
import 'package:gptutor/openai_model.dart';
import 'package:gptutor/secrets.dart';

final openAIServiceProvider =
    StateNotifierProvider<OpenAIService, OpenAI>((ref) {
  return OpenAIService();
});

class OpenAIService extends StateNotifier<OpenAI> {
  var temp = 'Give answer in one word that is whether the given answer is correct or incorrect.';
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
      final res = await http.post(
        Uri.parse('https://api.openai.com/v1/chat/completions'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $openAIKey',
        },
        body: jsonEncode({
          'model': 'gpt-3.5-turbo',
          'messages': [
            {
              'role': 'user',
              'content':
                  'Does this message want to generate an AI picture, image, art or anything similar? $question .Simply answer with yes or no.',
            },
          ],
        }),
      );
      if (res.statusCode == 200) {
        final content = await getAnswer(question, answer);
        state = state.copyWith(
          isLoading: false,
        );
        return content;
      }
      return 'An internal error occurred';
    } catch (e) {
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
}



  // final topics = [
  //   {
  //     'name': 'Topic 1',
  //     'questions': {
  //       "What does CUDA do?",
  //       "What is the difference between ML and AI?",
  //       "What is the capital of France?",
  //       "Why Engineering at MIT Manipal?",
  //       "Explain ML to me?",
  //     }
  //   },
  //   {
  //     'name': 'Topic 2',
  //     'questions': {
  //       "What are steps in ML?",
  //       "What is the difference between ML and AI?",
  //       "How to train a model?",
  //     },
  //   },
  // ];