import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:babstrap_settings_screen/babstrap_settings_screen.dart';
import 'package:waterlevel/auth/auth_changeavatar.dart';
import 'package:waterlevel/auth/auth_changename.dart';
import 'package:waterlevel/auth/auth_changepassword.dart';
import 'package:waterlevel/auth/auth_forgotpassword.dart';
import 'package:waterlevel/node/node_config_message.dart';
import 'package:waterlevel/pages/nav.dart';

class NodeConfig extends StatefulWidget {
  const NodeConfig({super.key});
  @override
  State<NodeConfig> createState() => _NodeConfigState();
}

class _NodeConfigState extends State<NodeConfig> {
  bool switchValueSetting = false;
  String fingerPrint = "#Fingerprint_API";
  String messageDelay = "#MessageDelay";
  String uploadDelay = "#UploadDelay";
  String settingDelay = "#SettingDelay";

  String valueFingerprint = "";
  String valueMessage = "";
  String valueSystem = "";
  String valueSetting = "";

  final _textFieldFingerprint = TextEditingController();
  final _textFieldMessage = TextEditingController();
  final _textFieldSensor = TextEditingController();
  final _textFieldSetting = TextEditingController();
  
  @override
  void initState() {
    checkConfigNode1();
    getFingerprint();
    super.initState();
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
    print('Change SystemDelay Node1');
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

  Future<void> _inputDialogSystem(BuildContext context) async {
    return showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text('แก้ไข System Delay'),
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
            'ตั้งค่า',
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
              SettingsGroup(
                settingsGroupTitle: "การตั้งค่า Node 1",
                settingsGroupTitleStyle: GoogleFonts.kanit(
                  fontSize: 22,
                  color: Colors.black87,
                ),
                items: [
                  SettingsItem(
                    onTap: () {},
                    icons: Icons.settings,
                    trailing: Switch.adaptive(
                      value: true,
                      onChanged: (value) {
                        // setState(() {
                        //   switchValueSetting = value;
                        // });
                        // if (switchValueSetting == true) {
                        //   EasyLoading.showSuccess('เปิดการตั้งค่า Node1');
                        //   openConfigNode1();
                        // } else {
                        //   EasyLoading.showInfo('ปิดการตั้งค่า Node1');
                        //   stopConfigNode1();
                        // }
                      },
                      activeTrackColor: Colors.redAccent,
                      activeColor: Colors.red[200],
                    ),
                    iconStyle: IconStyle(
                      withBackground: true,
                      borderRadius: 50,
                      backgroundColor: Colors.red[400],
                    ),
                    title: "เปิดใช้งาน",
                    subtitle: "",
                    titleStyle: GoogleFonts.kanit(
                      fontSize: 18,
                      color: Colors.black87,
                    ),
                    subtitleStyle: GoogleFonts.kanit(
                      fontSize: 14,
                    ),
                  ),
                  // SettingsItem(
                  //   onTap: () {
                  //     getFingerprint();
                  //     _displayTextInputDialog(context);
                  //   },
                  //   icons: Icons.display_settings_outlined,
                  //   iconStyle: IconStyle(
                  //     withBackground: true,
                  //     borderRadius: 50,
                  //     backgroundColor: Colors.blue[400],
                  //   ),
                  //   title: "เปลี่ยน Fingerprint API",
                  //   subtitle: fingerPrint,
                  //   titleStyle: GoogleFonts.kanit(
                  //     fontSize: 18,
                  //     color: Colors.black87,
                  //   ),
                  //   subtitleStyle: GoogleFonts.kanit(
                  //     fontSize: 14,
                  //   ),
                  // ),
                  SettingsItem(
                    onTap: () {
                    },
                    icons: Icons.display_settings_outlined,
                    iconStyle: IconStyle(
                      withBackground: true,
                      borderRadius: 50,
                      backgroundColor: Colors.blue[400],
                    ),
                    title: "ชื่อโหนด",
                    subtitle: 'node1',
                    titleStyle: GoogleFonts.kanit(
                      fontSize: 18,
                      color: Colors.black87,
                    ),
                    subtitleStyle: GoogleFonts.kanit(
                      fontSize: 14,
                    ),
                  ),
                  SettingsItem(
                    onTap: () {
                    },
                    icons: Icons.display_settings_outlined,
                    iconStyle: IconStyle(
                      withBackground: true,
                      borderRadius: 50,
                      backgroundColor: Colors.blue[400],
                    ),
                    title: "สถานที่ตั้งโหนด",
                    subtitle: 'Lagitude : 13.1234567, Longit...',
                    titleStyle: GoogleFonts.kanit(
                      fontSize: 18,
                      color: Colors.black87,
                    ),
                    subtitleStyle: GoogleFonts.kanit(
                      fontSize: 14,
                    ),
                  ),
                  SettingsItem(
                    onTap: () {
                    },
                    icons: Icons.display_settings_outlined,
                    iconStyle: IconStyle(
                      withBackground: true,
                      borderRadius: 50,
                      backgroundColor: Colors.blue[400],
                    ),
                    title: "ระดับน้ำที่ต้องการแจ้งเตือน",
                    subtitle: 'ทุกๆ 5 cm',
                    titleStyle: GoogleFonts.kanit(
                      fontSize: 18,
                      color: Colors.black87,
                    ),
                    subtitleStyle: GoogleFonts.kanit(
                      fontSize: 14,
                    ),
                  ),
                  SettingsItem(
                    onTap: () {
                       Navigator.pushReplacement(context,
                            CupertinoPageRoute(builder: (_) => NodeConfigMessage()));
                    },
                    icons: Icons.display_settings_outlined,
                    iconStyle: IconStyle(
                      withBackground: true,
                      borderRadius: 50,
                      backgroundColor: Colors.blue[400],
                    ),
                    title: "ข้อความการแจ้งเตือน",
                    subtitle: '',
                    titleStyle: GoogleFonts.kanit(
                      fontSize: 18,
                      color: Colors.black87,
                    ),
                    subtitleStyle: GoogleFonts.kanit(
                      fontSize: 14,
                    ),
                  ),
                  SettingsItem(
                    onTap: () {
                      checkConfigNode1();
                      _inputDialogMessage(context);
                    },
                    icons: Icons.display_settings_outlined,
                    iconStyle: IconStyle(
                      withBackground: true,
                      borderRadius: 50,
                      backgroundColor: Colors.blue[400],
                    ),
                    title: "เปลี่ยนค่าดีเลย์ข้อความแจ้งเตือน",
                    subtitle: '$valueMessage ms',
                    titleStyle: GoogleFonts.kanit(
                      fontSize: 18,
                      color: Colors.black87,
                    ),
                    subtitleStyle: GoogleFonts.kanit(
                      fontSize: 14,
                    ),
                  ),

                  SettingsItem(
                    onTap: () {
                        checkConfigNode1();
                      _inputDialogSystem(context);
                    },
                    icons: Icons.display_settings_outlined,
                    iconStyle: IconStyle(
                      withBackground: true,
                      borderRadius: 50,
                      backgroundColor: Colors.blue[400],
                    ),
                    title: "เปลี่ยนค่าดีเลย์เซ็นเซอร์",
                    subtitle: '$valueSystem ms',
                    titleStyle: GoogleFonts.kanit(
                      fontSize: 18,
                      color: Colors.black87,
                    ),
                    subtitleStyle: GoogleFonts.kanit(
                      fontSize: 14,
                    ),
                  ),

                  // SettingsItem(
                  //   onTap: () {
                  //     checkConfigNode1();
                  //     _inputDialogSetting(context);
                  //   },
                  //   icons: Icons.display_settings_outlined,
                  //   iconStyle: IconStyle(
                  //     withBackground: true,
                  //     borderRadius: 50,
                  //     backgroundColor: Colors.blue[400],
                  //   ),
                  //   title: "เปลี่ยนค่าดีเลย์เช็คการตั้งค่า",
                  //   subtitle: '$valueSetting ms',
                  //   titleStyle: GoogleFonts.kanit(
                  //     fontSize: 18,
                  //     color: Colors.black87,
                  //   ),
                  //   subtitleStyle: GoogleFonts.kanit(
                  //     fontSize: 14,
                  //   ),
                  // ),


                  SettingsItem(
                    onTap: () {
                      showDialog(
                          context: context,
                          builder: (BuildContext context) {
                            return AlertDialog(
                              title: Text('ยืนยันการรีสตาร์ทบอร์ด'),
                              content:
                                  Text('คุณต้องการรีสตาร์ทบอร์ดใช่หรือไม่'),
                              actions: <Widget>[
                                ElevatedButton(
                                  child: Text('ยกเลิก'),
                                  onPressed: () {
                                    setState(() {
                                      Navigator.pop(context);
                                    });
                                  },
                                ),
                                ElevatedButton(
                                  child: Text('ตกลง'),
                                  onPressed: () {
                                    setState(() {
                                      setRestart();
                                      Navigator.pop(context);
                                    });
                                  },
                                ),
                              ],
                            );
                          });
                    },
                    icons: Icons.system_security_update,
                    iconStyle: IconStyle(
                      withBackground: true,
                      borderRadius: 50,
                      backgroundColor: Colors.blue[400],
                    ),
                    title: "รีสตาร์ทบอร์ด",
                    subtitle: "",
                    titleStyle: GoogleFonts.kanit(
                      fontSize: 18,
                      color: Colors.black87,
                    ),
                    subtitleStyle: GoogleFonts.kanit(
                      fontSize: 14,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
