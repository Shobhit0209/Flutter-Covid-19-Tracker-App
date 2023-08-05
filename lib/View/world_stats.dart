// ignore_for_file: must_be_immutable

import 'package:covid_tracker/Services/stats_sevices.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:pie_chart/pie_chart.dart';

import '../Models/world_stats_model.dart';
import 'countries_list.dart';

class WorldStats extends StatefulWidget {
  const WorldStats({Key? key}) : super(key: key);

  @override
  State<WorldStats> createState() => _WorldStatsState();
}

class _WorldStatsState extends State<WorldStats> with TickerProviderStateMixin {
  late final AnimationController _controller =
      AnimationController(duration: const Duration(seconds: 3), vsync: this)
        ..repeat();

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    _controller.dispose();
  }

  final colorlist = const <Color>[
    Color(0xff4285F4),
    Color(0xff1aa260),
    Color(0xffde5246)
  ];

  @override
  Widget build(BuildContext context) {
    StatsServices statsServices = StatsServices();
    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.white,
        body: Padding(
          padding: const EdgeInsets.all(15.0),
          child: Column(
            children: [
              SizedBox(height: MediaQuery.of(context).size.height * .01),
              FutureBuilder(
                  future: statsServices.fetchWorldStatsRecord(),
                  builder: (context, AsyncSnapshot<WorldStatsModel> snapshot) {
                    if (!snapshot.hasData) {
                      return Expanded(
                          flex: 1,
                          child: SpinKitCircle(
                            color: Colors.green,
                            controller: _controller,
                            size: 50.0,
                          ));
                    } else {
                      return Column(
                        children: [
                          PieChart(
                            dataMap: {
                              "Total": snapshot.data!.cases!.toDouble(),
                              "Recovered": snapshot.data!.recovered!.toDouble(),
                              "Deaths": snapshot.data!.todayDeaths!.toDouble()
                            },
                            animationDuration:
                                const Duration(milliseconds: 1200),
                            chartRadius:
                                MediaQuery.of(context).size.width / 2.8,
                            chartType: ChartType.ring,
                            chartLegendSpacing: 48,
                            colorList: colorlist,
                            legendOptions: const LegendOptions(
                              legendTextStyle: TextStyle(color: Colors.black),
                              legendPosition: LegendPosition.left,
                              legendShape: BoxShape.rectangle,
                            ),
                          ),
                          SizedBox(
                            height: MediaQuery.of(context).size.height * .03,
                          ),
                          Padding(
                            padding: EdgeInsets.symmetric(
                                vertical:
                                    MediaQuery.of(context).size.height * 0.01),
                            child: Card(
                              child: Column(
                                children: [
                                  ReusableRow(
                                      title: 'Total',
                                      value: snapshot.data!.cases.toString()),
                                  ReusableRow(
                                      title: 'Deaths',
                                      value: snapshot.data!.deaths.toString()),
                                  ReusableRow(
                                      title: 'Recovered',
                                      value:
                                          snapshot.data!.recovered.toString()),
                                  ReusableRow(
                                      title: 'Active',
                                      value: snapshot.data!.active.toString()),
                                  ReusableRow(
                                      title: 'Critical',
                                      value:
                                          snapshot.data!.critical.toString()),
                                  ReusableRow(
                                      title: 'Today deaths',
                                      value: snapshot.data!.todayDeaths
                                          .toString()),
                                  ReusableRow(
                                      title: 'Today Recovered',
                                      value: snapshot.data!.todayRecovered
                                          .toString()),
                                ],
                              ),
                            ),
                          ),
                          GestureDetector(
                            onTap: () {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) =>
                                          const CountriesListScreen()));
                            },
                            child: Container(
                              height: 50,
                              width: MediaQuery.of(context).size.width * 1.0,
                              child: Text(
                                'Track Countries',
                                style: TextStyle(fontSize: 17),
                              ),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(10),
                                color: const Color.fromARGB(255, 67, 209, 72),
                              ),
                              alignment: Alignment.center,
                            ),
                          )
                        ],
                      );
                    }
                    //return const CircularProgressIndicator();
                  }),
            ],
          ),
        ),
      ),
    );
  }
}

class ReusableRow extends StatelessWidget {
  String title, value;
  ReusableRow({Key? key, required this.title, required this.value})
      : super(key: key);

  @override
  Widget build(BuildContext context)
   {
    return Padding(
      padding: const EdgeInsets.only(left: 10, right: 10, bottom: 10, top: 10),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [Text(title), Text(value)],
          ),
          SizedBox(
            height: 10,
          ),
          Divider(
            thickness: 1,
          )
        ],
      ),
    );
  }
}
