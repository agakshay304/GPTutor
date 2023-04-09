import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

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
        automaticallyImplyLeading: false,
      ),
      body: ListView.builder(
        itemCount: widget.topicWiseCorrectAnswers.length,
        itemBuilder: (context, index) {
          return ListTile(
            title: Text(widget.topicWiseCorrectAnswers.keys.elementAt(index)),
            subtitle: Text(widget.topicWiseCorrectAnswers.values
                .elementAt(index)
                .toString()),
          );
        },
      ),
    );
  }
}
