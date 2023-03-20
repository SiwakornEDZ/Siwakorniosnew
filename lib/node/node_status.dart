import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:babstrap_settings_screen/babstrap_settings_screen.dart';
import 'package:waterlevel/auth/auth_changeavatar.dart';
import 'package:waterlevel/auth/auth_changename.dart';
import 'package:waterlevel/auth/auth_changepassword.dart';
import 'package:waterlevel/auth/auth_forgotpassword.dart';
import 'package:waterlevel/pages/nav.dart';
import 'package:percent_indicator/percent_indicator.dart';

class NodeStatus extends StatefulWidget {
  const NodeStatus({super.key});
  @override
  State<NodeStatus> createState() => _NodeStatusState();
}

class _NodeStatusState extends State<NodeStatus> {
  bool switchValueSetting = false;
  String fingerPrint = "#fingerprint_api";
  String messageDelay = "#MessageDelay";
  String uploadDelay = "#UploadDelay";
  String settingDelay = "#SettingDelay";

  String valueDate = "#Date";
  String valueTime = "#Time";

  String valueFingerprint = "";
  String valueMessage = "";
  String valueSystem = "";
  String valueSetting = "";
  String nodeStatus = "OFF";
  var colorNodeStatus = Colors.red;

  final _textFieldFingerprint = TextEditingController();
  final _textFieldMessage = TextEditingController();
  final _textFieldSensor = TextEditingController();
  final _textFieldSetting = TextEditingController();

  final timenow = DateTime.now().toUtc().add(Duration(hours: 7));

  @override
  void initState() {
    checkConfigNode1();
    getFingerprint();
    getTime();
    super.initState();
  }

  Future<void> getTime() async {
    await FirebaseFirestore.instance
        .collection('node_time')
        .doc('node1')
        .get()
        .then(((value) {
      setState(() {
        valueDate = value.data()!['currentDate'];
        valueTime = '19:00';
      });
    }));
    String timeConvert = valueDate+" "+valueTime;
    DateTime timeFromFirebase = DateTime.parse(timeConvert);
    var difference = timenow.difference(timeFromFirebase).inMinutes;
    if (difference > 5) {
      setState(() {
        colorNodeStatus = Colors.green;
        nodeStatus = "ON";
      });
    } else {
      setState(() {
        colorNodeStatus = Colors.green;
        nodeStatus = "ON";
      });
    }
  }


  void checkConfigNode1() async {
    await FirebaseFirestore.instance
        .collection('node_setting')
        .doc('node1')
        .get()
        .then((value) => setState(() {
              switchValueSetting = value.data()!['setting'];
              valueMessage = value.data()!['message_delay'];
              valueSetting = value.data()!['setting_delay'];
              valueSystem = value.data()!['system_delay'];
            }));
  }

  void openConfigNode1() async {
    await FirebaseFirestore.instance
        .collection('node_setting')
        .doc('node1')
        .get()
        .then(((value) {
      FirebaseFirestore.instance
          .collection('node_setting')
          .doc('node1')
          .update({'setting': true});
    }));
    print('Open Config Node1');
  }

  void stopConfigNode1() async {
    await FirebaseFirestore.instance
        .collection('node_setting')
        .doc('node1')
        .get()
        .then(((value) {
      FirebaseFirestore.instance
          .collection('node_setting')
          .doc('node1')
          .update({'setting': false});
    }));
    print('Stop Config Node1');
  }

  Future<void> getFingerprint() async {
    await FirebaseFirestore.instance
        .collection('node_setting')
        .doc('node1')
        .get()
        .then(((value) {
      setState(() {
        fingerPrint = value.data()!['fingerprint_api'];
        _textFieldFingerprint.text = fingerPrint;
      });
    }));
  }

  Future<void> setFingerprint() async {
    await FirebaseFirestore.instance
        .collection('node_setting')
        .doc('node1')
        .get()
        .then(((value) {
      FirebaseFirestore.instance
          .collection('node_setting')
          .doc('node1')
          .update({'fingerprint_api': valueFingerprint});
    }));
    print('Stop Config Node1');
  }

  Future<void> setRestart() async {
    await FirebaseFirestore.instance
        .collection('node_setting')
        .doc('node1')
        .get()
        .then(((value) {
      FirebaseFirestore.instance
          .collection('node_setting')
          .doc('node1')
          .update({'restart': true});
    }));
    print('Restart system Node1');
  }

  Future<void> setMessageDelay() async {
    await FirebaseFirestore.instance
        .collection('node_setting')
        .doc('node1')
        .get()
        .then(((value) {
      FirebaseFirestore.instance
          .collection('node_setting')
          .doc('node1')
          .update({'message_delay': valueMessage});
    }));
    print('Change Message Delay Node1');
  }

  Future<void> setSystemDelay() async {
    await FirebaseFirestore.instance
        .collection('node_setting')
        .doc('node1')
        .get()
        .then(((value) {
      FirebaseFirestore.instance
          .collection('node_setting')
          .doc('node1')
          .update({'system_delay': valueSystem});
    }));
    print('Change System Delay Node1');
  }

  Future<void> setSettingDelay() async {
    await FirebaseFirestore.instance
        .collection('node_setting')
        .doc('node1')
        .get()
        .then(((value) {
      FirebaseFirestore.instance
          .collection('node_setting')
          .doc('node1')
          .update({'setting_delay': valueSetting});
    }));
    print('Change Setting Delay Node1');
  }

  Future<void> _inputDialogMessage(BuildContext context) async {
    return showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text('แก้ไข Message Delay'),
            content: TextField(
              onChanged: (value) {
                setState(() {
                  valueMessage = value;
                });
              },
              controller: _textFieldMessage,
              decoration: InputDecoration(hintText: "2xxxx"),
            ),
            actions: <Widget>[
              ElevatedButton(
                child: Text('CANCEL'),
                onPressed: () {
                  setState(() {
                    Navigator.pop(context);
                  });
                },
              ),
              ElevatedButton(
                child: Text('OK'),
                onPressed: () {
                  setState(() {
                    setMessageDelay();
                    Navigator.pop(context);
                  });
                },
              ),
            ],
          );
        });
  }

  Future<void> _inputDialogSensor(BuildContext context) async {
    return showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text('แก้ไข Upload Delay'),
            content: TextField(
              onChanged: (value) {
                setState(() {
                  valueSystem = value;
                });
              },
              controller: _textFieldSensor,
              decoration: InputDecoration(hintText: "2xxxx"),
            ),
            actions: <Widget>[
              ElevatedButton(
                child: Text('CANCEL'),
                onPressed: () {
                  setState(() {
                    Navigator.pop(context);
                  });
                },
              ),
              ElevatedButton(
                child: Text('OK'),
                onPressed: () {
                  setState(() {
                    setSystemDelay();
                    Navigator.pop(context);
                  });
                },
              ),
            ],
          );
        });
  }

  Future<void> _inputDialogSetting(BuildContext context) async {
    return showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text('แก้ไข Setting Delay'),
            content: TextField(
              onChanged: (value) {
                setState(() {
                  valueSetting = value;
                });
              },
              controller: _textFieldSetting,
              decoration: InputDecoration(hintText: "2xxxx"),
            ),
            actions: <Widget>[
              ElevatedButton(
                child: Text('CANCEL'),
                onPressed: () {
                  setState(() {
                    Navigator.pop(context);
                  });
                },
              ),
              ElevatedButton(
                child: Text('OK'),
                onPressed: () {
                  setState(() {
                    setSettingDelay();
                    Navigator.pop(context);
                  });
                },
              ),
            ],
          );
        });
  }

  Future<void> _displayTextInputDialog(BuildContext context) async {
    return showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text('แก้ไข Fingerprint API'),
            content: TextField(
              onChanged: (value) {
                setState(() {
                  valueFingerprint = value;
                });
              },
              controller: _textFieldFingerprint,
              decoration: InputDecoration(hintText: "xx xx xx xx xx xx xx xx"),
            ),
            actions: <Widget>[
              ElevatedButton(
                child: Text('CANCEL'),
                onPressed: () {
                  setState(() {
                    Navigator.pop(context);
                  });
                },
              ),
              ElevatedButton(
                child: Text('OK'),
                onPressed: () {
                  setState(() {
                    fingerPrint = valueFingerprint;
                    valueFingerprint = valueFingerprint;
                    setFingerprint();
                    Navigator.pop(context);
                  });
                },
              ),
            ],
          );
        });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        drawer: DrawerWidget(),
        backgroundColor: Colors.white,
        appBar: AppBar(
          backgroundColor: Colors.white,
          title: Text(
            'สถานะการใช้งาน',
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
        body: Padding(
          padding: const EdgeInsets.all(10),
          child: ListView(
            physics: BouncingScrollPhysics(
              parent: AlwaysScrollableScrollPhysics(),
            ),
            children: [
              const SizedBox(height: 20),
              Text('  Node 1',
                  style: GoogleFonts.kanit(
                    color: Colors.black87,
                    fontSize: 20,
                  )),
              const SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Container(
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(10),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.grey.withOpacity(0.5),
                            spreadRadius: 2,
                            blurRadius: 7,
                            offset: Offset(0, 3),
                          ),
                        ],
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            Text('วันที่ปัจจุบัน : ',
                                style: GoogleFonts.kanit(
                                  color: Colors.black87,
                                  fontSize: 17,
                                  fontWeight: FontWeight.w500,
                                )),
                            Text(valueDate,
                                style: GoogleFonts.kanit(
                                  color: Colors.green,
                                  fontSize: 17,
                                  fontWeight: FontWeight.w500,
                                )),
                          ],
                        ),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Container(
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(10),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.grey.withOpacity(0.5),
                            spreadRadius: 2,
                            blurRadius: 7,
                            offset: Offset(0, 3),
                          ),
                        ],
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            Text('เวลา : ',
                                style: GoogleFonts.kanit(
                                  color: Colors.black87,
                                  fontSize: 17,
                                  fontWeight: FontWeight.w500,
                                )),
                            Text(valueTime,
                                style: GoogleFonts.kanit(
                                  color: Colors.green,
                                  fontSize: 17,
                                  fontWeight: FontWeight.w500,
                                )),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Container(
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(10),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.grey.withOpacity(0.5),
                            spreadRadius: 2,
                            blurRadius: 7,
                            offset: Offset(0, 3),
                          ),
                        ],
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            Text('แรงดันไฟฟ้า',
                                style: GoogleFonts.kanit(
                                  color: Colors.black87,
                                  fontSize: 20,
                                  fontWeight: FontWeight.w500,
                                )),
                            CircularPercentIndicator(
                              radius: 50.0,
                              lineWidth: 11.0,
                              percent: 0.5,
                              center: Text("3.3 V",
                                  style: GoogleFonts.kanit(
                                    color: Colors.black87,
                                    fontSize: 15,
                                  )),
                              progressColor: Colors.green,
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  Row(
                    
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Container(
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(10),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.grey.withOpacity(0.5),
                                spreadRadius: 2,
                                blurRadius: 7,
                                offset: Offset(0, 3),
                              ),
                            ],
                          ),
                          child: Padding(
                            padding: const EdgeInsets.all(16.0),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                Text('สถานะการเชื่อมต่อ : ',
                                    style: GoogleFonts.kanit(
                                      color: Colors.black87,
                                      fontSize: 17,
                                      fontWeight: FontWeight.w500,
                                    )),
                                Text(nodeStatus,
                                    style: GoogleFonts.kanit(
                                      color: colorNodeStatus,
                                      fontSize: 17,
                                      fontWeight: FontWeight.w500,
                                    )),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ],
                  )
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
