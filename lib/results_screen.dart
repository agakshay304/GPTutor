import 'package:flutter/material.dart';

class ResultScreen extends StatefulWidget {
  final Map<String, int> topicWiseCorrectAnswers;

  const ResultScreen({required this.topicWiseCorrectAnswers});

  @override
  _ResultScreenState createState() => _ResultScreenState();
}

class _ResultScreenState extends State<ResultScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text('Result'),
      ),
      body: //print topicWiseCorrectAnswers,
          ListView.builder(
        itemCount: widget.topicWiseCorrectAnswers.length,
        itemBuilder: (context, index) {
          return ListTile(
            title: Text(widget.topicWiseCorrectAnswers.keys.elementAt(index)),
            subtitle: Text(
                widget.topicWiseCorrectAnswers.values.elementAt(index).toString()),
          );
        },
      ),
    );
  }
}
