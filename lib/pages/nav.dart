import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:waterlevel/admin/admin_gps_distance.dart';
import 'package:waterlevel/admin/admin_problem.dart';
import 'package:waterlevel/admin/admin_user_management.dart';
import 'package:waterlevel/auth/auth_graphlog.dart';
import 'package:waterlevel/auth/auth_report.dart';
import 'package:waterlevel/auth/auth_setting.dart';
import 'package:waterlevel/main.dart';
import 'package:waterlevel/node/node_config.dart';
import 'package:waterlevel/node/node_status.dart';
import 'package:waterlevel/node/node_management.dart';
import 'package:waterlevel/pages/login.dart';
import 'package:waterlevel/pages/signup.dart';

class DrawerWidget extends StatefulWidget {
  const DrawerWidget({super.key});

  @override
  State<DrawerWidget> createState() => _DrawerWidgetState();
}

class _DrawerWidgetState extends State<DrawerWidget> {
  String? name = '#Name';
  String? avatar = 'https://cdn-icons-png.flaticon.com/512/149/149071.png';
  String? userEmail = 'กรุณาเข้าสู่ระบบ';

  @override
  void initState() {
    checkNameWhoCreated();
    super.initState();
    if (FirebaseAuth.instance.currentUser != null) {
      userEmail = FirebaseAuth.instance.currentUser?.email;
    }
  }

  void checkNameWhoCreated() async {
    if (FirebaseAuth.instance.currentUser != null) {
      final users = await FirebaseFirestore.instance
          .collection('users')
          .where('email', isEqualTo: FirebaseAuth.instance.currentUser!.email)
          .where('avatar')
          .get();
      if (users.docs.isNotEmpty) {
        if (mounted) {
          setState(() {
            name = users.docs[0].data()['name'];
            avatar = users.docs[0].data()['avatar'];
          });
        }
        if (avatar == null) {
          setState(() {
            avatar = 'https://cdn-icons-png.flaticon.com/512/149/149071.png';
          });
        } else {

        }
      } else if (users.docs.isEmpty) {
        setState(() {
          name = '#Name';
        });
      }
    } else {
      setState(() {
        name = '#Name';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: const BorderRadius.only(
 
          bottomRight: Radius.circular(70),
        ),
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.5),
            spreadRadius: 5,
            blurRadius: 7,
            offset: const Offset(0, 3), // changes position of shadow
          ),
        ],
      ),
      width: MediaQuery.of(context).size.width / 1.3,
      // color: Colors.white,
      child: ListView(
        children: <Widget>[
          Container(
            margin: const EdgeInsets.only(top: 0),
            decoration: const BoxDecoration(
              borderRadius: BorderRadius.only(
              bottomLeft: Radius.circular(20),
              ),
              color: Color.fromARGB(255, 38, 46, 91),
 
              boxShadow: <BoxShadow>[
                
              ],
            ),
            child: Column(
              children: <Widget>[
                Container(
                  
                  child: Row(
                    children: <Widget>[
                      Container(
                        width: 50,
                        height: 100,
                        margin: const EdgeInsets.only(left: 10,right: 10),
                      ),
                      FirebaseAuth.instance.currentUser != null
                          ? Column(
                            children: <Widget>[
                              Container(
                                child: Center(
                                  child: Text(
                                    name.toString(),
                                    style: GoogleFonts.kanit(
                                      fontSize: 14,
                                      color: Color.fromARGB(221, 255, 255, 255),
                                    ),
                                  ),
                                ),
                              ),
                              Container(
                                child: Center(
                                  child: Text(
                                    userEmail.toString().length > 28
                                        ? userEmail
                                                .toString()
                                                .substring(0, 20) +
                                            '...'
                                        : userEmail.toString(),
                                    overflow: TextOverflow.fade,
                                    //  userEmail.toString().substring(0, userEmail.toString().indexOf('@')),
                                    style: GoogleFonts.kanit(
                                      fontSize: 14,
                                      color: Color.fromARGB(221, 255, 255, 255),
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          )
                          : Container(
                              child: Column(
                                children: <Widget>[
                                  Container(
                                    margin: const EdgeInsets.only(left: 10),
                                    child: Text(
                                      'กรุณาเข้าสู่ระบบ',
                                      style: GoogleFonts.kanit(
                                        fontSize: 18,
                                        color: Colors.white,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            )
                    ],
                  ),
                ),
              ],
            ),
          ),
          FirebaseAuth.instance.currentUser != null
              ? Column(
                  children: [
                    ListTile(
                      title: Text('หน้าแรก',
                          style: GoogleFonts.kanit(
                              fontSize: 14, color: Colors.black)),
                      leading: Image.asset(
                        'assets/images/house.png',
                        width: 25,
                        height: 25,
                      ),
                      onTap: () {
                        Navigator.pushReplacement(context,
                            CupertinoPageRoute(builder: (_) => const MyApp()));
                      },
                    ),
                    ListTile(
                      title: Text('ตั้งค่า',
                          style: GoogleFonts.kanit(
                              fontSize: 14, color: Colors.black)),
                      leading: Image.asset(
                        'assets/setting.png',
                        width: 25,
                        height: 25,
                      ),
                      onTap: () {
                        Navigator.push(context,
                            CupertinoPageRoute(builder: (_) => const Setting()));
                      },
                    ),
                     ListTile(
                      title: Text('ตั้งค่า Node',
                          style: GoogleFonts.kanit(
                              fontSize: 14, color: Colors.black)),
                      leading: Image.asset(
                        'assets/setting.png',
                        width: 25,
                        height: 25,
                      ),
                      onTap: () {
                        Navigator.push(context,
                            CupertinoPageRoute(builder: (_) => const NodeConfig()));
                      },
                    ),
                     ListTile(
                      title: Text('แจ้งปัญหา',
                          style: GoogleFonts.kanit(
                              fontSize: 14, color: Colors.black)),
                      leading: Image.asset(
                        'assets/register.png',
                        width: 25,
                        height: 25,
                      ),
                      onTap: () {
                        Navigator.push(context,
                            CupertinoPageRoute(builder: (_) => const Report()));
                      },
                    ),
                     ListTile(
                      title: Text('รายงานปัญหา',
                          style: GoogleFonts.kanit(
                              fontSize: 14, color: Colors.black)),
                      leading: Image.asset(
                        'assets/register.png',
                        width: 25,
                        height: 25,
                      ),
                      onTap: () {
                        Navigator.push(context,
                            CupertinoPageRoute(builder: (_) => const Problem()));
                      },
                    ),
                     ListTile(
                      title: Text('สเตตัสของโหนด',
                          style: GoogleFonts.kanit(
                              fontSize: 14, color: Colors.black)),
                      leading: Image.asset(
                        'assets/images/signal.png',
                        width: 25,
                        height: 25,
                      ),
                      onTap: () {
                        Navigator.push(context,
                            CupertinoPageRoute(builder: (_) => const NodeStatus()));
                      },
                    ),
                     ListTile(
                      title: Text('กราฟระดับน้ำ',
                          style: GoogleFonts.kanit(
                              fontSize: 14, color: Colors.black)),
                      leading: Image.asset(
                        'assets/images/signal.png',
                        width: 25,
                        height: 25,
                      ),
                      onTap: () {
                        Navigator.push(context,
                            CupertinoPageRoute(builder: (_) => const GraphLog()));
                      },
                    ),
                    //  ListTile(
                    //   title: Text('GPS',
                    //       style: GoogleFonts.kanit(
                    //           fontSize: 14, color: Colors.black)),
                    //   leading: Image.asset(
                    //     'assets/images/signal.png',
                    //     width: 25,
                    //     height: 25,
                    //   ),
                    //   onTap: () {
                    //     Navigator.push(context,
                    //         CupertinoPageRoute(builder: (_) => GPSDistance(isShowingMainData: true,)));
                    //   },
                    // ),
                     ListTile(
                      title: Text('จัดการผู้ใช้งาน',
                          style: GoogleFonts.kanit(
                              fontSize: 14, color: Colors.black)),
                      leading: Image.asset(
                        'assets/images/signal.png',
                        width: 25,
                        height: 25,
                      ),
                      onTap: () {
                        Navigator.push(context,
                            CupertinoPageRoute(builder: (_) => const UserManagement()));
                      },
                    ),
                     ListTile(
                      title: Text('จัดการโหนด',
                          style: GoogleFonts.kanit(
                              fontSize: 14, color: Colors.black)),
                      leading: Image.asset(
                        'assets/images/signal.png',
                        width: 25,
                        height: 25,
                      ),
                      onTap: () {
                        Navigator.push(context,
                            CupertinoPageRoute(builder: (_) => const NodeManagement()));
                      },
                    ),
                    ListTile(
                      title: Text('ออกจากระบบ',
                          style: GoogleFonts.kanit(
                              fontSize: 14, color: Colors.black)),
                      leading: Image.asset(
                        'assets/logout.png',
                        width: 25,
                        height: 25,
                      ),
                      onTap: () {
                        _signOut();
                        //  Navigator.pushNamed(context, '/');
                      },
                    ),
                  ],
                )
              : Column(
                  children: [
                    Container(
                      child: ListTile(
                        title: Text(
                          'เข้าสู่ระบบ',
                          style: GoogleFonts.kanit(
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                            color: Colors.black87,
                          ),
                        ),
                        leading: Image.asset(
                          'assets/login.png',
                          width: 25,
                          height: 25,
                        ),
                        onTap: () {
                          Navigator.push(context,
                              MaterialPageRoute(builder: (context) => const Login()));
                        },
                      ),
                    ),
                    ListTile(
                      title: Text(
                        'สมัครสมาชิก',
                        style: GoogleFonts.kanit(
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                          color: Colors.black87,
                        ),
                      ),
                      leading: Image.asset(
                        'assets/register.png',
                        width: 25,
                        height: 25,
                      ),
                      onTap: () {
                          Navigator.push(context,
                              MaterialPageRoute(builder: (context) => const Signup()));
                      },
                    ),
                  ],
                ),
        ],
      ),
    );
  }

  Future _signOut() async {
    EasyLoading.showInfo('ออกจากระบบ...');
    await FirebaseAuth.instance.signOut();
    Navigator.pop(context);
    _doOpenPage();
  }

  void _doOpenPage() {
    Navigator.pushAndRemoveUntil(
        context, MaterialPageRoute(builder: (context) => const Login()), (route) => false);
    Future.delayed(const Duration(milliseconds: 2000), () {
      EasyLoading.dismiss();
    });
  }
}