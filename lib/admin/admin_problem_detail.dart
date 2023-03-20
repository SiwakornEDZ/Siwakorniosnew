import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:waterlevel/admin/admin_function.dart';
import 'package:waterlevel/pages/nav.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class ProblemDetail extends StatefulWidget {
  final DocumentSnapshot docs;
  const ProblemDetail({Key? key, required this.docs}) : super(key: key);

  @override
  State<ProblemDetail> createState() => _ProblemDetailState();
}

class _ProblemDetailState extends State<ProblemDetail> {
  String status = 'ยังไม่แก้ไข';
  double lagitude = 0;
  double longitude = 0;
  bool haveMap = false;
  @override
  void initState() {
    getStatus();
    getLocation();
    super.initState();
  }

  Future<void> getLocation() async {
    lagitude = double.parse(widget.docs['location']['latitude']);
    longitude = double.parse(widget.docs['location']['longitude']);
    if (lagitude != 0 && longitude != 0) {
      setState(() {
        haveMap = true;
      });
    }
    return;
  }

  void getStatus() {
    if (widget.docs['solve'] == 'true') {
      setState(() {
        status = 'แก้ไขแล้ว';
      });
    } else if (widget.docs['solve'] == 'false') {
      setState(() {
        status = 'ยังไม่แก้ไข';
      });
    }
    else {
      setState(() {
        status = 'กำลังดำเนินการ';
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
            const Text(' รายงานปัญหา', style: TextStyle(color: Colors.black87)),
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
                      content: const Text('คุณต้องการลบข้อมูลนี้ใช่หรือไม่ ?'),
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
                                .collection('user_report')
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
                      title: const Text('การแก้ไขปัญหา'),
                      content: const Text('เปลี่ยนสถานะเป็น "แก้ไขแล้ว" ?'),
                      actions: <Widget>[
                        ElevatedButton(
                          child: const Text('ยังไม่แก้ไข'),
                          onPressed: () {
                            FirebaseFirestore.instance
                                .collection('user_report')
                                .doc(widget.docs.id)
                                .update({'solve': 'false'});
                            setState(() {
                              status = 'ยังไม่แก้ไข';
                            });
                            Navigator.pop(context);
                          },
                        ),
                        ElevatedButton(
                          child: const Text('แก้ไขแล้ว'),
                          onPressed: () {
                            FirebaseFirestore.instance
                                .collection('user_report')
                                .doc(widget.docs.id)
                                .update({'solve': 'true'});
                            setState(() {
                              status = 'แก้ไขแล้ว';
                            });
                            sendFCMProblem('${widget.docs['docid']}','ปัญหา ${widget.docs['topic']}','แก้ไขปัญหาเรียบร้อยแล้ว');
                            Navigator.pop(context);
                          },
                        ),
                        ElevatedButton(
                          child: const Text('กำลังแก้ไข'),
                          onPressed: () {
                            FirebaseFirestore.instance
                                .collection('user_report')
                                .doc(widget.docs.id)
                                .update({'solve': 'process'});
                            setState(() {
                              status = 'กำลังแก้ไข';
                            });
                            
                            if(widget.docs['topic'] == 'ติดต่อผู้ดูแลระบบ'){
                              sendFCMProblem('${widget.docs['docid']}','ปัญหา ${widget.docs['topic']}','ได้ติดต่อผ่านทาง Email แล้ว');
                            }else{
                              sendFCMProblem('${widget.docs['docid']}','ปัญหา ${widget.docs['topic']}','กำลังดำเนินการแก้ไข');
                            }
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
                  title: const Text('หัวข้อ'),
                  subtitle: Text(widget.docs['topic']),
                ),
                ListTile(
                  title: const Text('สถานะการแก้ไข'),
                  subtitle: Text(status),
                ),
                ListTile(
                  title: const Text('รายละเอียด'),
                  subtitle: Text(widget.docs['descript']),
                ),
                ListTile(
                  title: const Text('อีเมลล์'),
                  subtitle: Text(widget.docs['email']),
                ),
                ListTile(
                  title: const Text('วันที่'),
                  subtitle: Text(widget.docs['date'].toDate().toString()),
                ),
                const SizedBox(
                  height: 30,
                ),
              ],
            ),
            if (haveMap)
              FutureBuilder(
                future: getLocation(),
                builder: (context, snapshot) {
                  if (lagitude != 0 && longitude != 0) {
                    return Container(
                      height: 300,
                      child: GoogleMap(
                        initialCameraPosition: CameraPosition(
                          target: LatLng(lagitude, longitude),
                          zoom: 15,
                        ),
                        markers: {
                          Marker(
                            markerId: const MarkerId('1'),
                            position: LatLng(lagitude, longitude),
                          ),
                        },
                      ),
                    );
                  } else {
                    return Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: const <Widget>[
                          CircularProgressIndicator(),
                        ],
                      ),
                    );
                  }
                },
              ),
          ]),
    );
  }
}
