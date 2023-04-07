import 'package:flutter/material.dart';
import 'package:gptutor/widgets/colors.dart';

class ProgressBar extends StatelessWidget {
  const ProgressBar({
    Key? key,
    required this.stepNumber,
    required this.stepTotal,
  }) : super(key: key);
  final int stepNumber;
  final int stepTotal;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        ClipRRect(
          borderRadius: const BorderRadius.all(
            Radius.circular(
              20,
            ),
          ),
          child: LinearProgressIndicator(
            valueColor: const AlwaysStoppedAnimation<Color>(primaryColor),
            value: stepNumber / stepTotal,
            minHeight: 9,
          ),
        ),
        Align(
          alignment: AlignmentGeometry.lerp(
            const Alignment(-1.04, -1),
            const Alignment(1.04, -1),
            stepNumber / stepTotal,
          ) as AlignmentGeometry,
          child: Container(
            decoration: const BoxDecoration(
              borderRadius: BorderRadius.all(Radius.circular(4)),
              // color: ClickkedColors.primary500,
            ),
            width: 34,
            height: 28,
            child: Center(
              child: Text(
                '$stepNumber/$stepTotal',
                style: const TextStyle(
                  color: primaryColor,
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
