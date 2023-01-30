import 'dart:async';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:waterlevel/auth/auth_features.dart';
import 'package:waterlevel/main.dart';
import 'package:waterlevel/pages/login.dart';
import 'package:waterlevel/pages/nav_bottom.dart';
import 'package:waterlevel/pages/signup.dart';

String? distance = '0';
FirebaseAuth auth = FirebaseAuth.instance;

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
 

  @override
  void initState() {
    super.initState();
    checkUserInfo();
    dataReceive();
  }

  Widget build(BuildContext context) {
      
    return Stack(
      children: <Widget>[ ListView(
        scrollDirection: Axis.vertical,
        physics:
            const BouncingScrollPhysics(parent: AlwaysScrollableScrollPhysics()),
        children: [
          Column(
            children: [
              Container(
                margin: const EdgeInsets.only(top: 20),
                width: 330,
                height: 150,
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(30),
                    color: Color.fromARGB(255, 69, 179, 244)),
                child: Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(top: 20),
                      child: Text("ระยะห่างพื้นผิวน้ำ",
                          style: TextStyle(
                            fontSize: 30,
                            fontStyle: GoogleFonts.roboto().fontStyle,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          )),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 10),
                      child: Text("$distance",
                          style: TextStyle(
                            fontSize: 30,
                            fontStyle: GoogleFonts.roboto().fontStyle,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          )),
                    ),
                  ],
                ),
              ),
            ],
          ),
          Container(
              child: Padding(
            padding: const EdgeInsets.only(top: 20, left: 40, right: 40),
            child: Text("Nodes",
                style: TextStyle(
                  fontSize: 30,
                  fontStyle: GoogleFonts.roboto().fontStyle,
                  fontWeight: FontWeight.bold,
                  color: Color.fromARGB(255, 46, 66, 110),
                )),
          )),
          Padding(
            padding: const EdgeInsets.only(left: 40, right: 40),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  children: [
                    Container(
                      margin: const EdgeInsets.only(top: 10),
                      width: 150,
                      height: 200,
                      decoration: BoxDecoration(
                        image: const DecorationImage(
                          image: AssetImage('assets/images/japan2.jpg'),
                          fit: BoxFit.fitWidth,
                        ),
                        borderRadius: BorderRadius.circular(30),
                        color: Colors.blue,
                      ),
                      child: Center(
                        child: Text("$distance",
                            style: TextStyle(
                              fontSize: 30,
                              fontStyle: GoogleFonts.roboto().fontStyle,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            )),
                      ),
                    ),
                    Text('Node 1')
                  ],
                ),
                Column(
                  children: [
                    Container(
                      margin: const EdgeInsets.only(top: 10),
                      width: 150,
                      height: 200,
                      decoration: BoxDecoration(
                        image: const DecorationImage(
                          image: AssetImage('assets/images/japan1.jpg'),
                          fit: BoxFit.fitWidth,
                        ),
                        borderRadius: BorderRadius.circular(30),
                        color: Colors.blue,
                      ),
                      child: Center(
                        child: Text("$distance",
                            style: TextStyle(
                              fontSize: 30,
                              fontStyle: GoogleFonts.roboto().fontStyle,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            )),
                      ),
                    ),
                    Text('Node 2')
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
                          MaterialPageRoute(builder: (context) => const Login()),
                        );
                      },
                      child: Container(
                        width: 145,
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(30),
                            color: Color.fromARGB(255, 238, 225, 233)),
                        child: Row(
                          children: [
                            Padding(
                              padding: const EdgeInsets.only(left: 3.0, right: 8.0),
                              child: Container(
                                width: 40,
                                height: 40,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(30),
                                  color: Color.fromARGB(255, 244, 123, 160),
                                ),
                                child: const Icon(
                                  Icons.person,
                                  size: 30,
                                  color: Color.fromARGB(255, 255, 255, 255),
                                ),
                              ),
                            ),
                            Text('เข้าสู่ระบบ',
                                style: TextStyle(
                                  fontSize: 20,
                                  fontStyle: GoogleFonts.roboto().fontStyle,
                                  fontWeight: FontWeight.bold,
                                  color: Color.fromARGB(255, 46, 66, 110),
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
                          MaterialPageRoute(builder: (context) => const Signup()),
                        );
                      },
                      child: Container(
                        width: 185,
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(30),
                            color: Color.fromARGB(255, 223, 222, 241)),
                        child: Row(
                          children: [
                            Padding(
                              padding: const EdgeInsets.only(left: 3.0, right: 8.0),
                              child: Container(
                                width: 40,
                                height: 40,
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(30),
                                    color: Color.fromARGB(255, 119, 55, 204)),
                                child: const Icon(Icons.app_registration_rounded,
                                    size: 30,
                                    color: Color.fromARGB(255, 255, 255, 255)),
                              ),
                            ),
                            Text('สร้างบัญชีผู้ใช้',
                                style: TextStyle(
                                  fontSize: 20,
                                  fontStyle: GoogleFonts.roboto().fontStyle,
                                  fontWeight: FontWeight.bold,
                                  color: Color.fromARGB(255, 46, 66, 110),
                                )),
                          ],
                        ),
                      ),
                    ),
                  ]
                  ),
            ),
          )
          : Feature(),
    
               
      
         ],
         
    
      ),
       Align(
         alignment: Alignment.bottomCenter,
         child: Container(
           child: DrawerBottom() ,
         ),
       ),
      ]
      
    );
  }

  void dataReceive() async {
    DatabaseReference ref = FirebaseDatabase.instance
        .ref("UsersData/Node1/Distance");
    DatabaseEvent event = await ref.once();
    if (event.snapshot.value != null) {
      // print(event.snapshot.value);
      distance = event.snapshot.value?.toString();
      if (this.mounted) {
      setState(() {
        distance = distance;
      });
      }
      await Future.delayed(const Duration(seconds: 2));
      dataReceive2();
    } else {
      print("No data");
    }
  }

  void dataReceive2() async {
    DatabaseReference ref = FirebaseDatabase.instance
        .ref("UsersData/Node1/Distance");
    DatabaseEvent event = await ref.once();
    if (event.snapshot.value != null) {
      distance = event.snapshot.value?.toString();
      if (this.mounted) {
      setState(() {
        distance = distance;
      });
      }
      await Future.delayed(const Duration(seconds: 2));
      dataReceive();
    } else {
      print("No data");
    }
  }
  void checkUserInfo() {
      if(FirebaseAuth.instance.currentUser != null){
    FirebaseAuth.instance.currentUser !.email == null
        ? print('User is null')
        : print(FirebaseAuth.instance.currentUser!.email);
  }
  }
  // void checkLogin() async {
  //   FirebaseAuth.instance.currentUser == null
  //       ? Navigator.push(
  //           context,
  //           MaterialPageRoute(builder: (context) => const Login()),
  //         )
  //       :  Navigator.push(
  //           context,
  //           MaterialPageRoute(builder: (context) => const MyHomePage()),
  //         );
  // }

  Future signOut() async {
    await FirebaseAuth.instance.signOut();
  }

}
