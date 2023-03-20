import 'dart:async';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';
import 'package:waterlevel/admin/admin_gps_distance.dart';
import 'package:waterlevel/auth/auth_features.dart';
import 'package:waterlevel/main.dart';
import 'package:waterlevel/mysql/function.dart';
import 'package:waterlevel/pages/login.dart';
import 'package:waterlevel/pages/nav.dart';
import 'package:waterlevel/pages/nav_bottom.dart';
import 'package:waterlevel/pages/signup.dart';

String distance = '0';
double distancePercent = 0;
FirebaseAuth auth = FirebaseAuth.instance;

String distanceTopic = 'อยู่ในเกณฑ์ปลอดภัย';
String distanceDescription = 'รถทุกประเภทสามารถผ่านได้';
Color carColor = Colors.green;

class Home extends StatefulWidget {
  const Home({super.key, required Container drawer});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  @override
  void initState() {
    Timer.periodic(const Duration(seconds: 5), (timer) {
      dataReceive1();
    });
    super.initState();
  }

  var scaffoldKey = GlobalKey<ScaffoldState>();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Color.fromARGB(255, 240, 241, 245),
        drawer: DrawerWidget(),
        key: scaffoldKey,
        body: Stack(children: <Widget>[
          ListView(
            scrollDirection: Axis.vertical,
            physics: const BouncingScrollPhysics(
                parent: AlwaysScrollableScrollPhysics()),
            children: [
              SizedBox(
                height: 30,
              ),
              Column(
                children: [
                  Row(
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(left: 40),
                        child: Text("แอพพลิเคชั่นตรวจวัดระดับน้ำ",
                            style: TextStyle(
                              fontSize: 20,
                              fontStyle: GoogleFonts.roboto().fontStyle,
                              fontWeight: FontWeight.bold,
                              color: Color.fromARGB(255, 46, 66, 110),
                            )),
                      ),
                      GestureDetector(
                        onTap: () => scaffoldKey.currentState?.openDrawer(),
                        child: Container(
                          margin: const EdgeInsets.only(left: 80),
                          child: Icon(
                            Icons.grid_view_sharp,
                            size: 30,
                            color: Color.fromARGB(255, 36, 45, 89),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              SizedBox(
                height: 40,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Column(
                    children: [
                      Container(
                          height: 200,
                          width: 170,
                          decoration: BoxDecoration(
                            boxShadow: [
                              BoxShadow(
                                color: Colors.grey.withOpacity(0.7),
                                spreadRadius: 5,
                                blurRadius: 7,
                                offset: const Offset(0, 3),
                              ),
                            ],
                            borderRadius: BorderRadius.circular(15),
                            color: Color.fromARGB(255, 38, 46, 91),
                          ),
                          child: Column(
                            children: [
                              Padding(
                                padding:
                                    const EdgeInsets.fromLTRB(0, 10, 0, 10),
                                child: Text("ระดับน้ำ",
                                    style: TextStyle(
                                      fontSize: 25,
                                      fontStyle: GoogleFonts.roboto().fontStyle,
                                      color: Color.fromARGB(255, 221, 223, 234),
                                    )),
                              ),
                              CircularPercentIndicator(
                                radius: 50.0,
                                lineWidth: 9.0,
                                percent: distancePercent,
                                widgetIndicator: Center(
                                    child: Container(
                                  width: 10,
                                  height: 10,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(50),
                                    color: Color.fromARGB(255, 255, 242, 255),
                                  ),
                                )),
                                animation: true,
                                animationDuration: 1000,
                                animateFromLastPercent: true,
                                circularStrokeCap: CircularStrokeCap.round,
                                curve: Curves.easeInOut,
                                center: Column(
                                  children: [
                                    Padding(
                                      padding: const EdgeInsets.fromLTRB(
                                          0, 25, 0, 0),
                                      child: Text("$distance",
                                          style: GoogleFonts.kanit(
                                            color: Color.fromARGB(
                                                255, 233, 233, 243),
                                            fontSize: 18,
                                          )),
                                    ),
                                    Text("cm",
                                        style: GoogleFonts.kanit(
                                          color: Color.fromARGB(
                                              255, 233, 233, 243),
                                          fontSize: 17,
                                        )),
                                  ],
                                ),
                                progressColor:
                                    Color.fromARGB(255, 255, 28, 146),
                                backgroundColor:
                                    Color.fromARGB(255, 60, 67, 108),
                              ),
                            ],
                          )),
                      SizedBox(
                        height: 20,
                      ),
                      Container(
                          height: 180,
                          width: 170,
                          decoration: BoxDecoration(
                            boxShadow: [
                              BoxShadow(
                                color: Colors.grey.withOpacity(0.2),
                                spreadRadius: 3,
                                blurRadius: 9,
                                offset: const Offset(0, 3),
                              ),
                            ],
                            borderRadius: BorderRadius.circular(15),
                            color: Color.fromARGB(255, 255, 255, 255),
                          ),
                          child: Column(
                            children: [
                              Row(
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.fromLTRB(
                                        60, 10, 0, 10),
                                    child: Text("ข้อมูล",
                                        style: TextStyle(
                                          fontSize: 25,
                                          fontStyle:
                                              GoogleFonts.roboto().fontStyle,
                                          color:
                                              Color.fromARGB(255, 36, 36, 36),
                                        )),
                                  ),
                                ],
                              ),
                              Icon(
                                Icons.car_crash_rounded,
                                size: 40,
                                //half of the color size of the parent
                                color: carColor,
                              ),
                              Text(distanceTopic,
                                  style: GoogleFonts.kanit(
                                    color: Color.fromARGB(255, 36, 36, 36),
                                    fontSize: 17,
                                  )),
                              Padding(
                                padding: const EdgeInsets.fromLTRB(3, 0, 3, 0),
                                child: Text(distanceDescription,
                                    overflow: TextOverflow.clip,
                                    textAlign: TextAlign.center,
                                    style: GoogleFonts.kanit(
                                      color: Color.fromARGB(255, 36, 36, 36),
                                      fontSize: 15,
                                    )),
                              ),
                            ],
                          )),
                    ],
                  ),
                  Column(
                    children: [
                      Container(
                          height: 150,
                          width: 170,
                          decoration: BoxDecoration(
                            boxShadow: [
                              BoxShadow(
                                color: Colors.grey.withOpacity(0.1),
                                spreadRadius: 5,
                                blurRadius: 7,
                                offset:
                                    Offset(0, 3), // changes position of shadow
                              ),
                            ],
                            borderRadius: BorderRadius.circular(15),
                            color: Color.fromARGB(255, 255, 255, 255),
                          ),
                          child: Column(
                            children: [
                              Padding(
                                padding:
                                    const EdgeInsets.fromLTRB(0, 10, 0, 10),
                                child: Column(
                                  children: [
                                    Row(
                                      children: [
                                        Padding(
                                          padding: const EdgeInsets.fromLTRB(
                                              20, 0, 0, 0),
                                          child: Text("วันเวลาที่วัดล่าสุด",
                                              style: TextStyle(
                                                fontSize: 19,
                                                fontStyle: GoogleFonts.roboto()
                                                    .fontStyle,
                                                color: Color.fromARGB(
                                                    255, 1, 1, 1),
                                              )),
                                        ),
                                      ],
                                    ),
                                    SizedBox(
                                      height: 20,
                                    ),
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceEvenly,
                                      children: [
                                        Column(
                                          children: [
                                            Text('1 April',
                                                style: TextStyle(
                                                  fontSize: 20,
                                                  fontStyle:
                                                      GoogleFonts.roboto()
                                                          .fontStyle,
                                                  color: Color.fromARGB(
                                                      255, 54, 54, 54),
                                                )),
                                            Text('12:00 AM',
                                                style: TextStyle(
                                                  fontSize: 20,
                                                  fontStyle:
                                                      GoogleFonts.roboto()
                                                          .fontStyle,
                                                  color: Color.fromARGB(
                                                      255, 54, 54, 54),
                                                )),
                                          ],
                                        ),

                                        // day or night animation
                                        Column(
                                          children: [
                                            Container(
                                              margin: const EdgeInsets.only(
                                                  left: 20),
                                              child: Icon(
                                                Icons.wb_sunny,
                                                size: 30,
                                                color: Color.fromARGB(
                                                    255, 254, 111, 97),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          )),
                      SizedBox(
                        height: 20,
                      ),
                      Container(
                          height: 190,
                          width: 170,
                          decoration: BoxDecoration(
                            boxShadow: [
                              BoxShadow(
                                color: Colors.grey.withOpacity(0.2),
                                spreadRadius: 3,
                                blurRadius: 9,
                                offset: const Offset(0, 3),
                              ),
                            ],
                            borderRadius: BorderRadius.circular(15),
                            color: Color.fromARGB(255, 255, 255, 255),
                          ),
                          child: Column(
                            children: [
                              Row(
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.fromLTRB(
                                        25, 10, 0, 10),
                                    child: Text("ตำแหน่งที่ตั้ง",
                                        style: TextStyle(
                                          fontSize: 22,
                                          fontStyle:
                                              GoogleFonts.roboto().fontStyle,
                                          color: const Color.fromARGB(
                                              255, 36, 36, 36),
                                        )),
                                  ),
                                ],
                              ),
                              Padding(
                                padding: const EdgeInsets.fromLTRB(3, 0, 3, 0),
                                child: Text(
                                    'บริเวณสะพานกลับรถ มธร.ธัญบุรี คลองหก',
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                      fontSize: 15,
                                      fontStyle: GoogleFonts.roboto().fontStyle,
                                      color: Color.fromARGB(255, 36, 36, 36),
                                    )),
                              ),
                              SizedBox(
                                height: 20,
                              ),
                              Padding(
                                padding: const EdgeInsets.fromLTRB(3, 0, 3, 0),
                                child: ElevatedButton(
                                  style: ElevatedButton.styleFrom(
                                    primary: Color.fromARGB(255, 254, 111, 97),
                                    onPrimary: Colors.white,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(20.0),
                                    ),
                                  ),
                                  onPressed: () {
                                    // Navigator.push(
                                    //   context,
                                    //   MaterialPageRoute(
                                    //       builder: (context) => MapPage()),
                                    // );
                                  },
                                  child: Text('ดูแผนที่'),
                                ),
                              ),
                              // const SizedBox(
                              //   height: 140,
                              //   width: 155,
                              //   child: ClipRRect(
                              //     borderRadius: BorderRadius.only(
                              //       topLeft: Radius.circular(10),
                              //       topRight: Radius.circular(10),
                              //       bottomRight: Radius.circular(10),
                              //       bottomLeft: Radius.circular(10),
                              //     ),
                              //     child: Align(
                              //       alignment: Alignment.bottomRight,
                              //       heightFactor: 0.3,
                              //       widthFactor: 2.5,
                              //       // child:
                              //       //   GoogleMap(
                              //       //     mapType: MapType.normal,
                              //       //     initialCameraPosition: CameraPosition(
                              //       //       target: LatLng(13.736717, 100.523186),
                              //       //       zoom: 14.4746,
                              //       //     ),

                              //       //   ),
                              //     ),
                              //   ),
                              // ),
                            ],
                          )),
                    ],
                  ),
                ],
              ),
              Padding(
                padding: const EdgeInsets.only(left: 40, right: 40),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Column(
                      children: [
                        // Container(
                        //   margin: const EdgeInsets.only(top: 10),
                        //   width: 150,
                        //   height: 150,
                        //   decoration: BoxDecoration(
                        //     image: const DecorationImage(
                        //       image: AssetImage('assets/images/japan2.jpg'),
                        //       fit: BoxFit.fitWidth,
                        //     ),
                        //     borderRadius: BorderRadius.circular(90),
                        //     color: Colors.blue,
                        //   ),
                        //   child: Center(
                        //     child: Text("$distance",
                        //         style: TextStyle(
                        //           fontSize: 30,
                        //           fontStyle: GoogleFonts.roboto().fontStyle,
                        //           fontWeight: FontWeight.bold,
                        //           color: Colors.white,
                        //         )),
                        //   ),
                        // ),
                        // Text('Node 1')
                      ],
                    ),
                  ],
                ),
              ),
              Container(
                  child: Padding(
                padding: const EdgeInsets.only(top: 20, left: 40, right: 40),
                child: Text("Features",
                    style: TextStyle(
                      fontSize: 30,
                      fontStyle: GoogleFonts.roboto().fontStyle,
                      fontWeight: FontWeight.bold,
                      color: Color.fromARGB(255, 46, 66, 110),
                    )),
              )),
              FirebaseAuth.instance.currentUser == null
                  ? Padding(
                      padding: const EdgeInsets.only(top: 20),
                      child: SizedBox(
                        height: 50.0,
                        child: ListView(
                            physics: BouncingScrollPhysics(),
                            scrollDirection: Axis.horizontal,
                            children: [
                              SizedBox(
                                width: 20,
                              ),
                              GestureDetector(
                                onTap: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => const Login()),
                                  );
                                },
                                child: Container(
                                  width: 145,
                                  decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(30),
                                      color:
                                          Color.fromARGB(255, 238, 225, 233)),
                                  child: Row(
                                    children: [
                                      Padding(
                                        padding: const EdgeInsets.only(
                                            left: 3.0, right: 8.0),
                                        child: Container(
                                          width: 40,
                                          height: 40,
                                          decoration: BoxDecoration(
                                            borderRadius:
                                                BorderRadius.circular(30),
                                            color: Color.fromARGB(
                                                255, 244, 123, 160),
                                          ),
                                          child: const Icon(
                                            Icons.person,
                                            size: 30,
                                            color: Color.fromARGB(
                                                255, 255, 255, 255),
                                          ),
                                        ),
                                      ),
                                      Text('เข้าสู่ระบบ',
                                          style: TextStyle(
                                            fontSize: 20,
                                            fontStyle:
                                                GoogleFonts.roboto().fontStyle,
                                            fontWeight: FontWeight.bold,
                                            color: Color.fromARGB(
                                                255, 46, 66, 110),
                                          )),
                                    ],
                                  ),
                                ),
                              ),
                              SizedBox(
                                width: 10,
                              ),
                              GestureDetector(
                                onTap: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => const Signup()),
                                  );
                                },
                                child: Container(
                                  width: 185,
                                  decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(30),
                                      color:
                                          Color.fromARGB(255, 223, 222, 241)),
                                  child: Row(
                                    children: [
                                      Padding(
                                        padding: const EdgeInsets.only(
                                            left: 3.0, right: 8.0),
                                        child: Container(
                                          width: 40,
                                          height: 40,
                                          decoration: BoxDecoration(
                                              borderRadius:
                                                  BorderRadius.circular(30),
                                              color: Color.fromARGB(
                                                  255, 119, 55, 204)),
                                          child: const Icon(
                                              Icons.app_registration_rounded,
                                              size: 30,
                                              color: Color.fromARGB(
                                                  255, 255, 255, 255)),
                                        ),
                                      ),
                                      Text('สร้างบัญชีผู้ใช้',
                                          style: TextStyle(
                                            fontSize: 20,
                                            fontStyle:
                                                GoogleFonts.roboto().fontStyle,
                                            fontWeight: FontWeight.bold,
                                            color: Color.fromARGB(
                                                255, 46, 66, 110),
                                          )),
                                    ],
                                  ),
                                ),
                              ),
                            ]),
                      ),
                    )
                  : Feature(),
            ],
          ),
        ]));
  }

  void dataReceive1() async {
    DatabaseReference ref = FirebaseDatabase.instance.ref("Node1/Distance");
    DatabaseEvent event = await ref.once();
    int num_distance = 0;
    if (event.snapshot != null || !event.snapshot.exists) {
      if (mounted) {
        setState(() {
          distance = event.snapshot.value.toString();
          num_distance = int.parse(distance);
          distancePercent = (double.parse(distance) * 1.25) / 100;
          if (num_distance > 0 && num_distance < 10) {
            setState(() {
              carColor = Colors.green;
              distanceTopic = 'อยู่ในเกณฑ์ปลอดภัย';
              distanceDescription = 'รถทุกประเภทสามารถผ่านได้';
            });
          } else if (num_distance >= 11 && num_distance <= 20) {
            setState(() {
              carColor = Colors.yellow;
              distanceTopic = 'อยู่ในเกณฑ์เฝ้าระวัง';
              distanceDescription = 'รถเก๋งเริ่มมีความเสี่ยง';
            });
          } else if (num_distance >= 21 && num_distance <= 40) {
            setState(() {
              carColor = Colors.orange;
              distanceTopic = 'อยู่ในเกณฑ์สุ่มเสี่ยง';
              distanceDescription =
                  'รถกระบะเริ่มมีความเสี่ยง รถเก๋งควรหลีกเลี่ยง';
            });
          } else if (num_distance >= 41 && num_distance <= 60) {
            setState(() {
              carColor = Colors.red;
              distanceTopic = 'อยู่ในเกณฑ์อันตราย';
              distanceDescription = 'รถกระบะควรหลีกเลี่ยง';
            });
          } else if (num_distance >= 61) {
            setState(() {
              carColor = Colors.red[900]!;
              distanceTopic = 'อยู่ในเกณฑ์อันตรายมาก';
              distanceDescription = 'รถทุกชนิดควรหลีกเลี่ยงการขับผ่าน';
            });
          }
        });
      }
    } else {}
  }

  Future signOut() async {
    await FirebaseAuth.instance.signOut();
  }
}
