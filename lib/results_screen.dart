import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/svg.dart';
import 'package:gptutor/topics.dart';
import 'package:gptutor/widgets/colors.dart';
import 'package:pie_chart/pie_chart.dart';

import 'gp_provider.dart';

class ResultScreen extends ConsumerStatefulWidget {
  const ResultScreen({Key? key}) : super(key: key);
  @override
  _ResultScreenState createState() => _ResultScreenState();
}

class _ResultScreenState extends ConsumerState<ResultScreen> {
  final colorList = const <Color>[
    Colors.red,
    Colors.green,
    Colors.blue,
    Colors.yellow,
    Colors.purple,
  ];
  @override
  Widget build(BuildContext context) {
    final gptRef = ref.watch(gptProvider);
    Map<String, double> dataMap = gptRef.topicWiseCorrectAnswers
        .map((key, value) => MapEntry(key, value.toDouble()));
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
      body: Padding(
        padding: const EdgeInsets.all(12),
        child: Stack(
          children: [
            Column(
              children: [
                Container(
                  height: 41,
                  decoration: BoxDecoration(
                    color: primaryColor,
                    borderRadius: BorderRadius.circular(5),
                  ),
                  child: const Center(
                    child: Text(
                      "Performance",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 17,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                Container(
                  height: MediaQuery.of(context).size.height * 0.75,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: const BorderRadius.all(
                      Radius.circular(15),
                    ),
                    border: Border.all(
                      color: const Color(0xFFE4E4E4),
                      width: 3,
                    ),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: Column(
                      children: [
                        const Text(
                          "Correct Answers",
                          style: TextStyle(
                            color: primaryColor,
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        //legends
                        const SizedBox(height: 20),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: SizedBox(
                            height: 125,
                            child: ListView.builder(
                              itemCount: gptRef.topicWiseCorrectAnswers.length,
                              itemBuilder: (context, index) {
                                return Row(
                                  children: [
                                    Container(
                                      height: 10,
                                      width: 10,
                                      decoration: BoxDecoration(
                                        color: colorList[index],
                                        shape: BoxShape.circle,
                                      ),
                                    ),
                                    const SizedBox(width: 10),
                                    Text(
                                      gptRef.topicWiseCorrectAnswers.keys
                                          .toList()[index],
                                      style: const TextStyle(
                                        color: primaryColor,
                                        fontSize: 17,
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                  ],
                                );
                              },
                            ),
                          ),
                        ),
                        Container(
                          height: 325,
                          decoration: const BoxDecoration(
                            // color: Colors.red,
                            image: DecorationImage(
                              image: AssetImage(
                                "assets/images/bg.png",
                              ),
                              alignment: Alignment.centerLeft,
                              fit: BoxFit.cover,
                              scale: 0.5,
                            ),
                          ),
                          child: dataMap.isNotEmpty? PieChart(
                            dataMap: dataMap,
                            animationDuration:
                                const Duration(seconds: 1),
                            chartLegendSpacing: 100,
                            chartRadius:
                                MediaQuery.of(context).size.width / 2.7,
                            colorList: colorList,
                            initialAngleInDegree: 0,
                            chartType: ChartType.ring,
                            ringStrokeWidth: 32,
                            legendOptions: const LegendOptions(
                              showLegendsInRow: false,
                              legendPosition: LegendPosition.top,
                              showLegends: false,
                              // legendShape: _BoxShape.circle,
                              legendTextStyle: TextStyle(
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            chartValuesOptions: const ChartValuesOptions(
                              showChartValues: false,
                              decimalPlaces: 0,
                            ),
                          ):Container(
                            height: 325,
                            decoration: const BoxDecoration(
                              // color: Colors.red,
                              image: DecorationImage(
                                image: AssetImage(
                                  "assets/images/bg.png",
                                ),
                                alignment: Alignment.centerLeft,
                                fit: BoxFit.cover,
                                scale: 0.5,
                              ),
                            ),
                            child: const Center(
                              child: Text(
                                "Complete few topics to see your performance",
                                style: TextStyle(
                                  color: primaryColor,
                                  fontSize: 14,
                                  // fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(height: 10),
                        SvgPicture.asset(
                          'assets/images/moto3.svg',
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
            Positioned(
              bottom: 0,
              right: 0,
              child: SvgPicture.asset(
                'assets/images/girl.svg',
                // width: 25,
                // height: 25,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
