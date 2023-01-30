import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:syncfusion_flutter_charts/sparkcharts.dart';
import 'package:waterlevel/pages/nav.dart';

class GraphLog extends StatefulWidget {
  const GraphLog({super.key});

  @override
  State<GraphLog> createState() => _GraphLogState();
}

class _GraphLogState extends State<GraphLog> {
  List<_SalesData> node1 = [
    _SalesData('Jan', 35),
    _SalesData('Feb', 28),
    _SalesData('Mar', 34),
    _SalesData('Apr', 32),
    _SalesData('May', 40)
  ];
  List<_SalesData> node2 = [
    _SalesData('Jan', 15),
    _SalesData('Feb', 24),
    _SalesData('Mar', 34),
    _SalesData('Apr', 62),
    _SalesData('May', 41)
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('ประวัติระยะน้ำท่วม'),
          backgroundColor: Color.fromARGB(255, 69, 179, 244),
        ),
        body: ListView(
            physics: BouncingScrollPhysics(
              parent: AlwaysScrollableScrollPhysics(),
            ),
            children: [
              Column(children: [
                SfCartesianChart(
                    primaryXAxis: CategoryAxis(),
                    // Chart title
                    title: ChartTitle(
                        text: 'ปริมาณระดับน้ำ',
                        textStyle: GoogleFonts.kanit(
                          fontSize: 17,
                        )),
                    // Enable legend
                    legend: Legend(isVisible: true),
                    // Enable tooltip
                    tooltipBehavior: TooltipBehavior(enable: true),
                    series: <ChartSeries<_SalesData, String>>[
                      LineSeries<_SalesData, String>(
                          dataSource: node1,
                          xValueMapper: (_SalesData sales, _) => sales.year,
                          yValueMapper: (_SalesData sales, _) => sales.sales,
                          name: 'Node 1',
                          // Enable data label
                          dataLabelSettings:
                              DataLabelSettings(isVisible: true)),
                      LineSeries<_SalesData, String>(
                          dataSource: node2,
                          xValueMapper: (_SalesData sales, _) => sales.year,
                          yValueMapper: (_SalesData sales, _) => sales.sales,
                          name: 'Node 2',
                          // Enable data label
                          dataLabelSettings: DataLabelSettings(isVisible: true))
                    ]),
              ]),
            ]));
  }
}

class _SalesData {
  _SalesData(this.year, this.sales);

  final String year;
  final double sales;
}
