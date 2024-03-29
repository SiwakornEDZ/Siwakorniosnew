import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:waterlevel/auth/auth_datalog.dart';
import 'package:waterlevel/main.dart';
import 'package:waterlevel/pages/home.dart';
import 'package:waterlevel/pages/login.dart';
import 'package:waterlevel/pages/signup.dart';

class Feature extends StatefulWidget {
  const Feature({super.key});

  @override
  State<Feature> createState() => _FeatureState();
}

class _FeatureState extends State<Feature> {
  @override
  Widget build(BuildContext context) {
    return Padding(
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
                        MaterialPageRoute(builder: (context) => const MyHomePage()),
                      );
                    },
                    child: GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => const GraphLog()),
                        );
                      },
                      child: Container(
                        width: 210,
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
                            Text('ประวัติระยะน้ำท่วม',
                                style: TextStyle(
                                  fontSize: 20,
                                  fontStyle: GoogleFonts.roboto().fontStyle,
                                  color: Color.fromARGB(255, 46, 66, 110),
                                )),
                          ],
                        ),
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
                        MaterialPageRoute(builder: (context) => const MyHomePage()),
                      );
                    },
                    child: Container(
                      width: 210,
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
                          Text('กราฟระดับน้ำท่วม',
                              style: TextStyle(
                                fontSize: 20,
                                fontStyle: GoogleFonts.roboto().fontStyle,
                                color: Color.fromARGB(255, 46, 66, 110),
                              )),
                        ],
                      ),
                    ),
                  ),
                ]
                ),
          ),
        );
  }
}