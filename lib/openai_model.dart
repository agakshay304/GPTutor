import 'dart:convert';

import 'package:flutter/foundation.dart';

@immutable
class OpenAI {
  final List<Map<String, String>> messages;
  final bool isLoading;
  const OpenAI({
    required this.messages,
    required this.isLoading,
  });

  OpenAI copyWith({
    List<Map<String, String>>? messages,
    bool? isLoading,
  }) {
    return OpenAI(
      messages: messages ?? this.messages,
      isLoading: isLoading ?? this.isLoading,
    );
  }

  Map<String, dynamic> toMap() {
    final result = <String, dynamic>{};

    result.addAll({'messages': messages});
    result.addAll({'isLoading': isLoading});

    return result;
  }

  factory OpenAI.fromMap(Map<String, dynamic> map) {
    return OpenAI(
      messages: List<Map<String, String>>.from(
          map['messages']?.map((x) => Map<String, String>.from(x))),
      isLoading: map['isLoading'] ?? false,
    );
  }

  String toJson() => json.encode(toMap());

  factory OpenAI.fromJson(String source) => OpenAI.fromMap(json.decode(source));

  @override
  String toString() => 'OpenAI(messages: $messages, isLoading: $isLoading)';

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is OpenAI &&
        listEquals(other.messages, messages) &&
        other.isLoading == isLoading;
  }

  @override
  int get hashCode => messages.hashCode ^ isLoading.hashCode;
}
