 
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:waterlevel/auth/auth_function.dart';
import 'package:waterlevel/auth/auth_setting.dart';
import 'package:waterlevel/main.dart';
import 'package:waterlevel/pages/home.dart';
import 'package:waterlevel/pages/nav.dart';
import 'dart:math' as Math;

class Report extends StatefulWidget {
  const Report({super.key});
  @override
  State<Report> createState() => _ReportState();
}

class _ReportState extends State<Report> {
  final formKey = GlobalKey<FormState>();
  final nameController = TextEditingController();
  final FirebaseAuth auth = FirebaseAuth.instance;
  String? name;
  String? topicDescript;
  String topic = 'เลือกหัวข้อที่ต้องการติดต่อ';
  bool _isChecked = false;
  String _currText = '';
  Map<String, dynamic>? location;
  // List of items in our dropdown menu
  var items = [
    'เลือกหัวข้อที่ต้องการติดต่อ',
    'ติดต่อผู้ดูแลระบบ',
    'ปัญหาการใช้งาน',
    'ข้อเสนอแนะ',
  ];

  @override
  void initState() {
    getName();
    super.initState();
  }

  Future<void> getPosision() async {
    determinePosition();
  }

  Future getName() async {
    await FirebaseFirestore.instance
        .collection('users')
        .doc(auth.currentUser!.email)
        .get()
        .then((DocumentSnapshot documentSnapshot) {
      if (documentSnapshot.exists) {
        name = documentSnapshot['name'];
      } else {
        Navigator.push(context, MaterialPageRoute(builder: (context) {
          return const MyApp();
        }));
      }
    });
  }

  void checkInformation() {
    if (topic == 'เลือกหัวข้อที่ต้องการติดต่อ') {
      EasyLoading.showError('กรุณาเลือกหัวข้อที่ต้องการติดต่อ');
    } else if (topicDescript == null) {
      EasyLoading.showError('กรุณากรอกรายละเอียด');
    } else {
      createReport();
    }
  }

  Future createReport() async {
    String latitude = '0';
    String longitude = '0';
    EasyLoading.show(status: 'กำลังโหลด...');
    if (_isChecked == true) {
      try {
        Position position = await determinePosition();
        latitude = position.latitude.toString();
        longitude = position.longitude.toString();
      } catch (e) {
        if (e == 'NoPermission') {
          EasyLoading.showError('กรุณาเปิด GPS');
          return;
        }
      }
      location = {
        "latitude": latitude,
        "longitude": longitude,
      };
    } else {
      location = {
        "latitude": latitude,
        "longitude": longitude,
      };
    }
    final User? user = auth.currentUser;
    final email = user!.email;
    final dateTimeNow = DateTime.now();
    await FirebaseFirestore.instance.collection('user_report').doc().set({
      'email': email,
      'name': name,
      'topic': topic,
      'descript': topicDescript,
      'location': location,
      'date': dateTimeNow,
      'solve': 'false',
    });
    EasyLoading.showSuccess('ส่งข้อมูลสำเร็จ');
    Future.delayed(const Duration(seconds: 1), () {
      EasyLoading.dismiss();
      Navigator.push(context, MaterialPageRoute(builder: (context) {
        return const MyHomePage();
      }));
    });

    await FirebaseFirestore.instance
        .collection('user_report')
        .where('date', isEqualTo: dateTimeNow)
        .get()
        .then((QuerySnapshot querySnapshot) {
      querySnapshot.docs.forEach((doc) async {
        FirebaseFirestore.instance
            .collection('user_report')
            .doc(doc.id)
            .update({
          'docid': doc.id,
        });
        await FirebaseMessaging.instance.subscribeToTopic(doc.id);
      });
    });
  }

  var distanceInMeter = 0.0;
  Future<double> getDistance(double lat2, double lon2) async {
    double PI = 3.141592653589793;
    double latitude = 0.0;
    double longitude = 0.0;
    try {
      Position position = await determinePosition();
      latitude = position.latitude;
      longitude = position.longitude;
      print('latitude: $latitude');
      print('longitude: $longitude');
    } catch (e) {
      if (e == 'NoPermission') {
        EasyLoading.showError('กรุณาเปิด GPS');
        return 0.0;
      }
    }
    var R = 6378.137; // Radius of earth in KM
    var dLat = lat2 * PI / 180 - latitude * PI / 180;
    var dLon = lon2 * PI / 180 - longitude * PI / 180;
    var a = Math.sin(dLat / 2) * Math.sin(dLat / 2) +
        Math.cos(latitude * PI / 180) *
            Math.cos(lat2 * PI / 180) *
            Math.sin(dLon / 2) *
            Math.sin(dLon / 2);
    var c = 2 * Math.atan2(Math.sqrt(a), Math.sqrt(1 - a));
    var d = R * c;
    return d * 1000; // meters
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      drawer: const DrawerWidget(),
      appBar: AppBar(
        backgroundColor: Colors.white,
        title:
            const Text(' แจ้งปัญหา', style: TextStyle(color: Colors.black87)),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_outlined),
          color: Colors.black87,
          onPressed: () {
            Navigator.push(context, MaterialPageRoute(builder: (context) {
              return const MyHomePage();
            }));
          },
        ),
      ),
      body: Form(
        key: formKey,
        child: ListView(
            physics: const AlwaysScrollableScrollPhysics(
              parent: BouncingScrollPhysics(),
            ),
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.only(top: 30.0),
                child: SizedBox(
                  height: 100,
                  child: Image.asset("assets/images/error.png"),
                ),
              ),
              const SizedBox(height: 20),
              Text(
                "          Report Problem",
                style: GoogleFonts.kanit(
                  fontSize: 20,
                  color: Colors.black,
                ),
              ),
              Text(
                "             กรอกปัญหาที่พบในการใช้งาน",
                style: GoogleFonts.kanit(
                  fontSize: 14,
                  color: Colors.black,
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 20.0),
                child: Container(
                    margin: const EdgeInsets.only(left: 20.0, right: 20.0),
                    child: topicProblem()),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 20.0),
                child: Container(
                    height: 200,
                    margin: const EdgeInsets.only(left: 20.0, right: 20.0),
                    child: problemText()),
              ),
              CheckboxListTile(
                title: const Text("ส่งตำแหน่งที่ตั้งปัจจุบัน"),
                value: _isChecked,
                onChanged: (bool? value) {
                  setState(() {
                    _isChecked = value!;
                  });
                },
                controlAffinity:
                    ListTileControlAffinity.leading, //  <-- leading Checkbox
              ),
              const SizedBox(height: 20),
              Container(
                  margin: const EdgeInsets.only(left: 100.0, right: 100.0),
                  child: buildButton()),
            ]),
      ),
    );
  }

  DropdownButton<String> topicProblem() {
    return DropdownButton(
      value: topic,
      icon: const Icon(Icons.keyboard_arrow_down),
      items: items.map((String items) {
        return DropdownMenuItem(
          value: items,
          child: Text(items),
        );
      }).toList(),
      onChanged: (String? newValue) {
        setState(() {
          topic = newValue!;
        });
      },
    );
  }

  TextFormField problemText() {
    return TextFormField(
      controller: nameController,
      minLines: 5,
      maxLines: 10,
      maxLength: 500,
      onChanged: (value) {
        topicDescript = value.trim();
      },
      validator: (value) {
        if (!validateUsername(value!)) {
          return 'กรุณากรอกปัญหาให้มากกว่า 6 ตัวอักษร';
        } else {
          setState(() {
            topicDescript = value;
          });
        }
        return null;
      },
      keyboardType: TextInputType.multiline,
      textInputAction: TextInputAction.newline,
      decoration: const InputDecoration(
        border: OutlineInputBorder(
          borderRadius: BorderRadius.all(Radius.circular(22.0)),
        ),
        labelText: 'ปัญหา',
        prefixIcon: Icon(Icons.sync_problem),
        hintText: 'Your Name',
      ),
    );
  }

  ElevatedButton buildButton() {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        primary: Colors.red[400],
        onPrimary: Colors.white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20.0),
        ),
      ),
      onPressed: () async {
        if( _isChecked == true){
          distanceInMeter = await getDistance(14.019865, 100.7320483);
          print(distanceInMeter);
          if (distanceInMeter > 30) {
            EasyLoading.showError('กรุณาเข้าพื้นที่ใกล้เคียงกับสถานที่ติดตั้งโหนด (30 เมตร)');
          } else {
            checkInformation();
          }
        }
        else {
        checkInformation();
      }
      },
      child: const Text('ส่งข้อมูล'),
    );
  }

  bool validateUsername(String value) {
    if (value.length < 6) {
      return false;
    } else {
      return true;
    }
  }
}
