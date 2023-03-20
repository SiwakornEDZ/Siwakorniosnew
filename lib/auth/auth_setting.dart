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
import 'package:waterlevel/pages/nav.dart';

class Setting extends StatefulWidget {
  const Setting({super.key});
  @override
  State<Setting> createState() => _SettingState();
}

class _SettingState extends State<Setting> {
  String? fullScreen;
  bool isFB = false;
  String? notification;
  String? name = '#Name';
  String? avatar = 'https://cdn-icons-png.flaticon.com/512/149/149071.png';
  String? loginWith;
  bool switchValue = false;
  @override
  void initState() {
    checkInfo();
    checkOptionDbFirebase();
    super.initState();
  }

  void checkInfo() async {
    if (FirebaseAuth.instance.currentUser != null) {
      await FirebaseFirestore.instance
          .collection('users')
          .where('email', isEqualTo: FirebaseAuth.instance.currentUser!.email)
          //.where('avatar')
          .get()
          .then((value) => value.docs.forEach((element) {
                setState(() {
                  name = element.data()['name'];
                  avatar = element.data()['avatar'];
                  loginWith = element.data()['loginwith'];
                });
              }));
      checkImageNull();
      checkFbLogin();
    } else {}
  }

  void checkImageNull() {
    if (avatar == null) {
      setState(() {
        avatar = 'https://cdn-icons-png.flaticon.com/512/149/149071.png';
      });
    }
  }

  void checkFbLogin() async {
    if (loginWith == 'Facebook') {
      setState(() {
        isFB = true;
      });
    }
  }


    void checkOptionDbFirebase() async {
    await FirebaseFirestore.instance
        .collection('users_option')
        .where('email', isEqualTo: FirebaseAuth.instance.currentUser!.email)
        .get()
          .then((value) => value.docs.forEach((element) {
                setState(() {
                  notification = element.data()['notification'];
                  fullScreen = element.data()['fullscreen'];
                });
              }
              )
              );
              if (notification == 'true') {
                setState(() {
                  switchValue = true;
                });
              }
              else{
                setState(() {
                  switchValue = false;
                });
              }
  }

  void subscribeTopic() async {
    await FirebaseFirestore.instance
        .collection('users_option')
        .where('email', isEqualTo: FirebaseAuth.instance.currentUser!.email)
        .get()
        .then((value) => value.docs.forEach((element) {
              FirebaseFirestore.instance
                  .collection('users_option')
                  .doc(element.id)
                  .update({'notification': 'true'});
            }));
                print('subscribing to topic');
                await FirebaseMessaging.instance.subscribeToTopic('all');
  }

  void unSubscribeTopic() async {
    await FirebaseFirestore.instance
        .collection('users_option')
        .where('email', isEqualTo: FirebaseAuth.instance.currentUser!.email)
        .get()
        .then((value) => value.docs.forEach((element) {
              FirebaseFirestore.instance
                  .collection('users_option')
                  .doc(element.id)
                  .update({'notification': 'false'});
            }));
                print('unsubscribing to topic');
                await FirebaseMessaging.instance.unsubscribeFromTopic('all');
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
            physics: const BouncingScrollPhysics(),
            children: [
              // user card
              Stack(
                children: [
                  Column(children: [
                    BigUserCard(
                      userProfilePic:
                          const AssetImage("assets/images/grey.png"),
                      cardRadius: 20,
                      // cardColor: Colors.black54,
                      userName: name.toString(),
                      cardActionWidget: SettingsItem(
                        icons: Icons.edit,
                        iconStyle: IconStyle(
                          withBackground: true,
                          borderRadius: 50,
                          backgroundColor: Colors.yellow[600],
                        ),
                        title: "แก้ไขชื่อแสดงผล",
                        titleStyle: GoogleFonts.kanit(
                          color: Colors.black87,
                          fontSize: 18,
                        ),
                        subtitle: "",
                        subtitleStyle: GoogleFonts.kanit(
                          color: Colors.black87,
                          fontSize: 13,
                        ),
                        onTap: () {
                          Navigator.pushReplacement(context,
                            CupertinoPageRoute(builder: (_) => AvatarUpload()));
                        },
                      ),
                    ),
                  ]),
                  // Positioned(
                  //     // top: 15,
                  //     // left: 50,
                  //     top: 15,
                  //     left: 50,
                  //     child: ClipRRect(
                  //       borderRadius: BorderRadius.circular(35.0),
                  //       child: Image.network(avatar.toString(),
                  //           width: 85, height: 85, fit: BoxFit.cover),
                  //     )),
                ],
              ),
              const SizedBox(height: 20),
              SettingsGroup(
                settingsGroupTitle: "การตั้งค่า",
                settingsGroupTitleStyle: GoogleFonts.kanit(
                  fontSize: 22,
                  color: Colors.black87,
                ),
                items: [
                  // SettingsItem(
                  //   onTap: () {
                  //    Navigator.pushReplacement(context,
                  //           CupertinoPageRoute(builder: (_) => ChangeName()));
                  //   },
                  //   icons: Icons.display_settings_outlined,
                  //   iconStyle: IconStyle(
                  //     withBackground: true,
                  //     borderRadius: 50,
                  //     backgroundColor: Colors.blue[400],
                  //   ),
                  //   title: "เปลี่ยนชื่อแสดงผล",
                  //   titleStyle: GoogleFonts.kanit(
                  //     fontSize: 18,
                  //     color: Colors.black87,
                  //   ),
                  // ),
                  SettingsItem(
                    onTap: () {
                      Navigator.pushReplacement(context,
                       CupertinoPageRoute(builder: (_) => ForgotPassword()));
                    },
                    icons: Icons.password,
                    iconStyle: IconStyle(
                      withBackground: true,
                      borderRadius: 50,
                      backgroundColor: Colors.red[400],
                    ),
                    title: "ลืมรหัสผ่าน",
                    titleStyle: GoogleFonts.kanit(
                      fontSize: 18,
                      color: Colors.black87,
                    ),
                  ),
                  isFB == false
                      ? SettingsItem(
                          onTap: () {
                           Navigator.pushReplacement(context,
                            CupertinoPageRoute(builder: (_) => ChangePassword()));
                          },
                          icons: Icons.lock,
                          iconStyle: IconStyle(
                            withBackground: true,
                            borderRadius: 50,
                            backgroundColor: Colors.red[400],
                          ),
                          title: "เปลี่ยนรหัสผ่าน",
                          titleStyle: GoogleFonts.kanit(
                            fontSize: 18,
                            color: Colors.black87,
                          ),
                        )
                      : SettingsItem(
                          trailing: Icon(Icons.lock),
                          onTap: () {
                            EasyLoading.showInfo('ไม่สามารถเปลี่ยนรหัสผ่านได้');
                          },
                          icons: Icons.lock,
                          iconStyle: IconStyle(
                            withBackground: true,
                            borderRadius: 50,
                            backgroundColor: Colors.red[400],
                          ),
                          title: "เปลี่ยนรหัสผ่าน",
                          titleStyle: GoogleFonts.kanit(
                            fontSize: 18,
                            color: Colors.black87,
                          ),
                        ),
                          SettingsItem(
                     
                          onTap: () {
                            EasyLoading.showInfo('รับการแจ้งเตือนจาก');
                          },
                          icons: Icons.area_chart,
                          iconStyle: IconStyle(
                            withBackground: true,
                            borderRadius: 50,
                            backgroundColor: Colors.red[400],
                          ),
                          title: "รับการแจ้งเตือนจาก",
                          subtitle: "Node1",
                          titleStyle: GoogleFonts.kanit(
                            fontSize: 18,
                            color: Colors.black87,
                          ),
                        ),
                         SettingsItem(
                        onTap: () {
                           
                        },
                        icons: Icons.notifications,
                        trailing: Switch.adaptive(
                          value: switchValue,
                          onChanged: (value) {
                            setState(() {
                              switchValue = value;
                            });
                            if (switchValue == true) {
                              EasyLoading.showSuccess('เปิดการแจ้งเตือน');
                              subscribeTopic();

                            } else {
                              EasyLoading.showInfo('ปิดการแจ้งเตือน');
                              unSubscribeTopic();
                            }
                          },
                          activeTrackColor: Colors.lightGreenAccent,
                          activeColor: Colors.green,
                        ),
                        iconStyle: IconStyle(
                          withBackground: true,
                          borderRadius: 50,
                          backgroundColor: Colors.red[400],
                        ),
                        title: "การแจ้งเตือน",
                        titleStyle: GoogleFonts.kanit(
                          fontSize: 18,
                          color: Colors.black87,
                    ),
                  ),
                  // SettingsItem(
                  //   onTap: () {},
                  //   icons: Icons.settings,
                  //   title: "Delete account",
                  //   titleStyle: TextStyle(
                  //     color: Colors.red,
                  //     fontWeight: FontWeight.bold,
                  //   ),
                  // ),
                ],
              ),
            ],
          ),
        ),
        
      ),
    );
  }

  screen() async {
    if (fullScreen == false) {
      setState(() {
        fullScreen = 'true';
      });
      SystemChrome.setEnabledSystemUIMode(SystemUiMode.manual,
          overlays: [SystemUiOverlay.bottom]);
    } else if (fullScreen == true) {
      setState(() {
        fullScreen = 'false';
      });
      SystemChrome.setEnabledSystemUIMode(SystemUiMode.manual,
          overlays: SystemUiOverlay.values);
    }
  }

 


}

 