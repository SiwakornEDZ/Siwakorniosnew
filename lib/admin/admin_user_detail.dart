import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:waterlevel/admin/admin_function.dart';
import 'package:waterlevel/pages/nav.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class UserDetail extends StatefulWidget {
  final DocumentSnapshot docs;
  const UserDetail({Key? key, required this.docs}) : super(key: key);

  @override
  State<UserDetail> createState() => _UserDetailState();
}

class _UserDetailState extends State<UserDetail> {
  String status = 'User';
  @override
  void initState() {
    getStatus();
    super.initState();
  }

  void getStatus() {
    if (widget.docs['admin'] == 'true') {
      setState(() {
        status = 'Admin';
      });
    } else if (widget.docs['admin'] == 'false') {
      setState(() {
        status = 'User';
      });
    }
    else {
      setState(() {
        status = 'Unknown';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      drawer: const DrawerWidget(),
      appBar: AppBar(
        backgroundColor: Colors.white,
        title:
            const Text(' จัดการผู้ใช้', style: TextStyle(color: Colors.black87)),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_outlined),
          color: Colors.black87,
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        actions: [
          //delete button
          IconButton(
            icon: const Icon(Icons.delete),
            color: Colors.black87,
            onPressed: () {
              showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    return AlertDialog(
                      title: const Text('การลบข้อมูล'),
                      content: const Text('คุณต้องการลบบัญชีผู้ใช้งานนี้ใช่หรือไม่ ?'),
                      actions: <Widget>[
                        ElevatedButton(
                          child: const Text('ยกเลิก'),
                          onPressed: () {
                            Navigator.pop(context);
                          },
                        ),
                        ElevatedButton(
                          child: const Text('ยืนยัน'),
                          onPressed: () {
                            FirebaseFirestore.instance
                                .collection('users')
                                .doc(widget.docs.id)
                                .delete();
                            Navigator.pop(context);
                            Navigator.pop(context);
                          },
                        ),
                      ],
                    );
                  });
            },
          ),
          IconButton(
            icon: const Icon(Icons.miscellaneous_services_sharp),
            color: Colors.black87,
            onPressed: () {
              showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    return AlertDialog(
                      title: const Text('สถานะผู้ใช้งาน'),
                      content: const Text('เปลี่ยนสถานะผู้ใช้งาน'),
                      actions: <Widget>[
                        ElevatedButton(
                          child: const Text('Admin'),
                          onPressed: () {
                            FirebaseFirestore.instance
                                .collection('users')
                                .doc(widget.docs.id)
                                .update({'admin': 'true'});
                            setState(() {
                              status = 'Admin';
                            });
                            Navigator.pop(context);
                          },
                        ),
                        ElevatedButton(
                          child: const Text('User'),
                          onPressed: () {
                            FirebaseFirestore.instance
                                .collection('users')
                                .doc(widget.docs.id)
                                .update({'admin': 'false'});
                            setState(() {
                              status = 'User';
                            });
                            Navigator.pop(context);
                          },
                        ),
                      ],
                    );
                  });
            },
          ),
        ],
      ),
      body: ListView(
          physics: const AlwaysScrollableScrollPhysics(
            parent: BouncingScrollPhysics(),
          ),
          children: [
            Column(
              children: [
                ListTile(
                  title: const Text('ID'),
                  subtitle: Text(widget.docs['id']),
                ),
                ListTile(
                  title: const Text('UID'),
                  subtitle: Text(widget.docs['uid']),
                ),
                ListTile(
                  title: const Text('อีเมลล์'),
                  subtitle: Text(widget.docs['email']),
                ),
                ListTile(
                  title: const Text('ชื่อ'),
                  subtitle: Text(widget.docs['name']),
                ),
                ListTile(
                  title: const Text('เข้าสู่ระบบด้วย'),
                  subtitle: Text(widget.docs['loginwith']),
                ),
                ListTile(
                  title: const Text('วันที่'),
                  subtitle: Text(widget.docs['created_at'].toString()),
                ),
                const SizedBox(
                  height: 30,
                ),
              ],
            ),
          ]
          ),
    );
  }
}
