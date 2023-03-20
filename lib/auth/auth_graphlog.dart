import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:syncfusion_flutter_charts/sparkcharts.dart';
import 'package:waterlevel/pages/nav.dart';
import 'package:collection/collection.dart';

class GraphLog extends StatefulWidget {
  const GraphLog({super.key});

  @override
  State<GraphLog> createState() => _GraphLogState();
}

class _GraphLogState extends State<GraphLog> {
  String dropdownvalue = 'มกราคม';
  int dropdownFirstDay = 1;
  int dropdownLastDay = 31;
  String month = '#เดือน';
  String timeDate = '';
  var selectMonth = [
    'มกราคม',
    'กุมภาพันธ์',
    'มีนาคม',
    'เมษายน',
    'พฤษภาคม',
    'มิถุนายน',
    'กรกฎาคม',
    'สิงหาคม',
    'กันยายน',
    'ตุลาคม',
    'พฤศจิกายน',
    'ธันวาคม'
  ];
  int selectDay = 31;
  var selectFirstDay = [
    1,
    2,
    3,
    4,
    5,
    6,
    7,
    8,
    9,
    10,
    11,
    12,
    13,
    14,
    15,
    16,
    17,
    18,
    19,
    20,
    21,
    22,
    23,
    24,
    25,
    26,
    27,
    28,
    29,
    30,
    31,
  ];
  var selectLastDay = [
    1,
    2,
    3,
    4,
    5,
    6,
    7,
    8,
    9,
    10,
    11,
    12,
    13,
    14,
    15,
    16,
    17,
    18,
    19,
    20,
    21,
    22,
    23,
    24,
    25,
    26,
    27,
    28,
    29,
    30,
    31,
  ];
  @override
  void initState() {
    super.initState();
  }

  Map<String, dynamic>? data;
  Map<String, dynamic>? time;

  List<dynamic> dataLog = [];
  List<dynamic> dataTime = [];
  List<_DataLog> dataLogGrap = [];
  List<dynamic> dataTimeShow = [];

  void getDate() async {
    final result = await FirebaseFirestore.instance
        .collection('node_log')
        .doc('node1')
        .get();
    for (int i = 0; i < result.data()!.length; i++) {
      String forSubstring = result.data()!.keys.elementAt(i);
      String substring = forSubstring.substring(0, 2);
      dataTimeShow.add(result.data()!.keys.elementAt(i));
      dataTime.add(result.data()!.keys.elementAt(i).replaceAll(substring, ''));
    }
    dataTime.sort();
  }

  // void searchData(String timeDate, String monthTopic) async {
  //   String day;

  //   setState(() {
  //     timeDate = timeDate;
  //   });
  //   try {
  //     await Future.delayed(Duration(seconds: 1));
  //     await FirebaseFirestore.instance
  //         .collection('node_log')
  //         .doc('node1')
  //         .get(const GetOptions(source: Source.server))
  //         .then((value) {
  //       for (int i = 0; i < 31; i++) {
  //         day = i.toString();
  //         day = day.padLeft(2, '0');

  //         setState(() {
  //           data = value.data()?['${timeDate}_$day'];
  //         });
  //         String key2;
  //         if (data == null) {
  //         } else {
  //           data?.forEach((key, value) {
  //             value = int.parse(value);
  //             if (value > 100) {
  //               value = null;
  //             } else {
  //               setState(() {
  //                 key2 = "วันที่ ${day} ${key.substring(2)}:00";
  //                 print(key2);
  //                 dataLog.add(_DataLog(key2, value));
  //               });
  //             }
  //           });
  //           dataLog.sort((a, b) => a.time.compareTo(b.time));
  //           dataLogGrap = dataLog.cast<_DataLog>();
  //         }
  //         EasyLoading.dismiss();
  //       }
  //     });
  //     setState(() {
  //       month = monthTopic;
  //     });
  //   } on FirebaseException catch (e) {
  //     print(e);
  //   }
  // }

  // Future<List<DocumentSnapshot>>  searchData(String timeDate, String monthTopic) async {
  //   String day;

  //   setState(() {
  //     timeDate = timeDate;
  //   });
  //   var data = await FirebaseFirestore.instance.collection('node_log_node1')
  //   .doc('2023_02_18')
  //   .get();
  //   print(data.data());
  //   return data.data()?['data'];
  // }

  final CollectionReference _collectionRef =
      FirebaseFirestore.instance.collection('node_log_node1');

  Future<void> searchData(String timeDate, String monthTopic) async {
    setState(() {
      month = monthTopic;
      timeDate = timeDate;
    });
    QuerySnapshot querySnapshot = await _collectionRef.get();

    List allData = querySnapshot.docs.map((doc) => doc.data()).toList();
    for (var element in allData) {
      for (int i = 0; i < 31; i++) {
        String timeDateSearch = '${timeDate}_${i.toString().padLeft(2, '0')}';
        String timeDateGraph = '${i.toString().padLeft(2, '0')} ';
        if (element[timeDateSearch] != null) {
          for (int i = 1; i < 25; i++) {
            String timeSearch = i.toString().padLeft(2, '0');
            if (element[timeDateSearch]['H_$timeSearch'] != null) {
              String vauleTime = 'วันที่ $timeDateGraph$timeSearch:00';
              int valueDistance =
                  int.parse(element[timeDateSearch]['H_$timeSearch']);
              dataLog.add(_DataLog(vauleTime, valueDistance));
            } else {}
          }
        } else {}
      }
      updaeGraph();
    }

    EasyLoading.dismiss();
    //print(allData);
  }

  Future<void> searchDataWithDay() async {
    QuerySnapshot querySnapshot = await _collectionRef.get();

    List allData = querySnapshot.docs.map((doc) => doc.data()).toList();
    for (int i = 0; i < allData.length; i++) {}
    for (var element in allData) {
      for (int i = dropdownFirstDay; i <= dropdownLastDay; i++) {
        String timeDateSearch = '${timeDate}_${i.toString().padLeft(2, '0')}';
        String timeDateGraph = '${i.toString().padLeft(2, '0')} ';
        if (element[timeDateSearch] != null) {
          for (int i = 1; i < 25; i++) {
            String timeSearch = i.toString().padLeft(2, '0');
            if (element[timeDateSearch]['H_$timeSearch'] != null) {
              String vauleTime = 'วันที่ $timeDateGraph $timeSearch:00';
              int valueDistance =
                  int.parse(element[timeDateSearch]['H_$timeSearch']);

              dataLog.add(_DataLog(vauleTime, valueDistance));
            } else {}
          }
        } else {}
      }
      updaeGraph();
    }

    EasyLoading.dismiss();
    //print(allData);
  }

  void updaeGraph() {
    setState(() {
      dataLog.sort((a, b) => a.time.compareTo(b.time));
      dataLogGrap = dataLog.cast<_DataLog>();
    });
    if (dataLogGrap.length == 0) {
      EasyLoading.showError('ไม่พบข้อมูล');
    } else {
      EasyLoading.showSuccess('โหลดข้อมูลเรียบร้อย');
    }
  }

  DropdownButton<String> topicMonth() {
    return DropdownButton(
      value: dropdownvalue,
      icon: const Icon(Icons.keyboard_arrow_down),
      items: selectMonth.map((String selectMonth) {
        return DropdownMenuItem(
          value: selectMonth,
          child: Text(selectMonth),
        );
      }).toList(),
      onChanged: (String? newValue) {
        EasyLoading.show(status: 'กำลังโหลด...');
        dataLog.clear();
        print('Change Value = $newValue');
        if (newValue == 'มกราคม') {
          setState(() {
            timeDate = 'D_2023_01';
            dropdownFirstDay = 1;
            dropdownLastDay = 31;
          });
          searchData('D_2023_01', 'มกราคม');
        } else if (newValue == 'กุมภาพันธ์') {
          setState(() {
            timeDate = 'D_2023_02';
            dropdownFirstDay = 1;
            dropdownLastDay = 31;
          });
          searchData('D_2023_02', 'กุมภาพันธ์');
        } else if (newValue == 'มีนาคม') {
          setState(() {
            timeDate = 'D_2023_03';
            dropdownFirstDay = 1;
            dropdownLastDay = 31;
          });
          searchData('D_2023_03', 'มีนาคม');
        } else if (newValue == 'เมษายน') {
          setState(() {
            timeDate = 'D_2023_04';
            dropdownFirstDay = 1;
            dropdownLastDay = 31;
          });
          searchData('D_2023_04', 'เมษายน');
        } else if (newValue == 'พฤษภาคม') {
          setState(() {
            timeDate = 'D_2023_05';
            dropdownFirstDay = 1;
            dropdownLastDay = 31;
          });
          searchData('D_2023_05', 'พฤษภาคม');
        } else if (newValue == 'มิถุนายน') {
          setState(() {
            timeDate = 'D_2023_06';
            dropdownFirstDay = 1;
            dropdownLastDay = 31;
          });
          searchData('D_2023_06', 'มิถุนายน');
        } else if (newValue == 'กรกฎาคม') {
          setState(() {
            timeDate = 'D_2023_07';
            dropdownFirstDay = 1;
            dropdownLastDay = 31;
          });
          searchData('D_2023_07', 'กรกฎาคม');
        } else if (newValue == 'สิงหาคม') {
          setState(() {
            timeDate = 'D_2023_08';
            dropdownFirstDay = 1;
            dropdownLastDay = 31;
          });
          searchData('D_2023_08', 'สิงหาคม');
        } else if (newValue == 'กันยายน') {
          setState(() {
            timeDate = 'D_2023_09';
            dropdownFirstDay = 1;
            dropdownLastDay = 31;
          });
          searchData('D_2023_09', 'กันยายน');
        } else if (newValue == 'ตุลาคม') {
          setState(() {
            timeDate = 'D_2023_10';
            dropdownFirstDay = 1;
            dropdownLastDay = 31;
          });
          searchData('D_2023_10', 'ตุลาคม');
        } else if (newValue == 'พฤศจิกายน') {
          setState(() {
            timeDate = 'D_2023_11';
            dropdownFirstDay = 1;
            dropdownLastDay = 31;
          });
          searchData('D_2023_11', 'พฤศจิกายน');
        } else if (newValue == 'ธันวาคม') {
          setState(() {
            timeDate = 'D_2023_12';
            dropdownFirstDay = 1;
            dropdownLastDay = 31;
          });
          searchData('D_2023_12', 'ธันวาคม');
        }
        setState(() {
          dropdownvalue = newValue!;
        });
      },
    );
  }

  // void searchDataWithDay() async {
  //   String day;
  //   try {
  //     await Future.delayed(Duration(seconds: 1));
  //     await FirebaseFirestore.instance
  //         .collection('node_log')
  //         .doc('node1')
  //         .get(const GetOptions(source: Source.server))
  //         .then((value) {
  //       for (int i = dropdownFirstDay; i <= dropdownLastDay; i++) {
  //         day = i.toString();
  //         day = day.padLeft(2, '0');
  //         setState(() {
  //           data = value.data()?['${timeDate}_$day'];
  //         });
  //         String key2;
  //         if (data == null) {
  //           print('data is null');
  //         } else {
  //           data?.forEach((key, value) {
  //             value = int.parse(value);
  //             if (value > 100) {
  //               value = null;
  //             } else {
  //               setState(() {
  //                 key2 = "วันที่ ${day} ${key.substring(2)}:00";
  //                 print(key2);
  //                 dataLog.add(_DataLog(key2, value));
  //               });
  //             }
  //           });
  //           dataLog.sort((a, b) => a.time.compareTo(b.time));
  //           dataLogGrap = dataLog.cast<_DataLog>();
  //         }
  //         EasyLoading.dismiss();
  //       }
  //     });
  //     setState(() {
  //       month = dropdownvalue;
  //     });
  //   } on FirebaseException catch (e) {
  //     print(e);
  //   }
  // }

  DropdownButton<int> topicFirstDay() {
    return DropdownButton(
      value: dropdownFirstDay,
      icon: const Icon(Icons.keyboard_arrow_down),
      items: selectFirstDay.map((int value) {
        return DropdownMenuItem<int>(
          value: value,
          child: Text(value.toString()),
        );
      }).toList(),
      onChanged: (int? newValue) {
        dataLog.clear();
        print('Change Value = $newValue');
        setState(() {
          dropdownFirstDay = newValue!;
        });
        searchDataWithDay();
      },
    );
  }

  DropdownButton<int> topicLastDay() {
    return DropdownButton(
      value: dropdownLastDay,
      icon: const Icon(Icons.keyboard_arrow_down),
      items: selectLastDay.map((int value) {
        return DropdownMenuItem<int>(
          value: value,
          child: Text(value.toString()),
        );
      }).toList(),
      onChanged: (int? newValue) {
        dataLog.clear();
        print('Change Value = $newValue');
        setState(() {
          dropdownLastDay = newValue!;
        });
        searchDataWithDay();
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: DrawerWidget(),
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: Text(
          'ประวัติระยะน้ำท่วม',
          style: GoogleFonts.kanit(
            color: Colors.black87,
            fontSize: 20,
            fontWeight: FontWeight.w500,
          ),
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_outlined),
          color: Colors.black87,
          onPressed: () {
            //   Navigator.pop(context);
            Navigator.pushNamed(context, '/');
          },
        ),
        // backgroundColor: Colors.transparent,
        // elevation: 0,
      ),
      body: ListView(
        physics: const BouncingScrollPhysics(
          parent: AlwaysScrollableScrollPhysics(),
        ),
        children: [
          Column(
            children: [
              Row(
                children: [
                  Stack(
                    children: [
                      Container(
                          margin: const EdgeInsets.only(top: 180),
                          child: RotationTransition(
                            turns: const AlwaysStoppedAnimation(270 / 360),
                            child: Text("ระดับน้ำ",
                                style: GoogleFonts.kanit(
                                  fontSize: 15,
                                  fontWeight: FontWeight.w300,
                                )),
                          )),
                      Container(
                        margin: const EdgeInsets.only(left: 25),
                        width: 365,
                        height: 350,
                        child: SfCartesianChart(
                            plotAreaBorderWidth: 2,
                            trackballBehavior: TrackballBehavior(
                                enable: true,
                                activationMode: ActivationMode.singleTap,
                                tooltipSettings: InteractiveTooltip(
                                    enable: true,
                                    color: Colors.white,
                                    textStyle: GoogleFonts.kanit(
                                      fontSize: 15,
                                    ))),
                            enableAxisAnimation: true,
                            zoomPanBehavior: ZoomPanBehavior(
                                enablePinching: true,
                                enablePanning: true,
                                enableDoubleTapZooming: true,
                                enableSelectionZooming: true,
                                enableMouseWheelZooming: true),
                            primaryXAxis: CategoryAxis(),
                            title: ChartTitle(
                                text: 'ปริมาณระดับน้ำเดือน ${month} 2566',
                                textStyle: GoogleFonts.kanit(
                                  fontSize: 17,
                                )),
                            legend: Legend(isVisible: false),
                            tooltipBehavior: TooltipBehavior(
                              enable: true,
                              header: 'ปริมาณระดับน้ำ',
                              format: 'point.x point.y cm',
                              textStyle: GoogleFonts.kanit(
                                fontSize: 12,
                              ),
                              duration: 4000,
                              elevation: 10,
                            ),
                            series: <ChartSeries<_DataLog, String>>[
                              LineSeries<_DataLog, String>(
                                markerSettings: const MarkerSettings(
                                  isVisible: true,
                                  shape: DataMarkerType.circle,
                                  borderWidth: 2,
                                  borderColor:
                                      Color.fromARGB(179, 228, 228, 228),
                                  color: Colors.blue,
                                ),
                                xAxisName: 'Time',
                                yAxisName: 'Value',
                                dataSource: dataLogGrap,
                                xValueMapper: (_DataLog data, _) =>
                                    '   ${data.time} น.',
                                yValueMapper: (_DataLog data, _) => data.value,
                                name: 'Node 1',
                                dataLabelSettings: DataLabelSettings(
                                  textStyle: GoogleFonts.kanit(
                                    fontSize: 12,
                                  ),
                                  isVisible: true,
                                ),
                                color: Colors.blue,
                                width: 2,
                              ),
                            ]),
                      ),
                      Container(
                        margin: const EdgeInsets.only(top: 340, left: 200),
                        child: Text('วันเวลา',
                            style: GoogleFonts.kanit(
                              fontSize: 15,
                              fontWeight: FontWeight.w300,
                            )),
                      ),
                    ],
                  ),
                ],
              ),
            ],
          ),
          Container(
            height: 250,
            margin: const EdgeInsets.only(top: 20.0, left: 20.0, right: 20.0),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(10),
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.withOpacity(0.2),
                  spreadRadius: 5,
                  blurRadius: 7,
                  offset: const Offset(0, 3), // changes position of shadow
                ),
              ],
            ),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(top: 10.0),
                      child: Text('เลือกเดือน',
                          style: GoogleFonts.kanit(
                            fontSize: 20,
                          )),
                    ),
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(top: 5.0),
                      child: Container(
                          width: 200,
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(10),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.grey.withOpacity(0.2),
                                spreadRadius: 5,
                                blurRadius: 7,
                                offset: const Offset(
                                    0, 3), // changes position of shadow
                              ),
                            ],
                          ),
                          margin:
                              const EdgeInsets.only(left: 20.0, right: 20.0),
                          child: Center(child: topicMonth())),
                    ),
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(top: 10.0),
                      child: Text('เลือกวันที่',
                          style: GoogleFonts.kanit(
                            fontSize: 20,
                          )),
                    ),
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(top: 5.0),
                      child: Container(
                          width: 100,
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(10),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.grey.withOpacity(0.2),
                                spreadRadius: 5,
                                blurRadius: 7,
                                offset: const Offset(
                                    0, 3), // changes position of shadow
                              ),
                            ],
                          ),
                          margin:
                              const EdgeInsets.only(left: 20.0, right: 20.0),
                          child: Center(child: topicFirstDay())),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 5.0),
                      child: Text('ถึง',
                          style: GoogleFonts.kanit(
                            fontSize: 20,
                          )),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 5.0),
                      child: Container(
                          width: 100,
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(10),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.grey.withOpacity(0.2),
                                spreadRadius: 5,
                                blurRadius: 7,
                                offset: const Offset(
                                    0, 3), // changes position of shadow
                              ),
                            ],
                          ),
                          margin:
                              const EdgeInsets.only(left: 20.0, right: 20.0),
                          child: Center(child: topicLastDay())),
                    ),
                  ],
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}

class _DataLog {
  _DataLog(this.time, this.value);
  final String time;
  final int value;
}
