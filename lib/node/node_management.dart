import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';
import 'package:waterlevel/admin/admin_problem_detail.dart';
import 'package:waterlevel/admin/admin_function.dart';
import 'package:waterlevel/admin/admin_user_detail.dart';
import 'package:waterlevel/main.dart';
import 'package:waterlevel/pages/nav.dart';

class NodeManagement extends StatefulWidget {
  const NodeManagement({super.key});
  @override
  State<NodeManagement> createState() => _NodeManagementState();
}

class _NodeManagementState extends State<NodeManagement> {
  Query<Map<String, dynamic>> data = FirebaseFirestore.instance
      .collection('node')
      .orderBy('created_at', descending: true);

 

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromARGB(255, 242, 243, 247),
      drawer: const DrawerWidget(),
      appBar: AppBar(
        backgroundColor: Color.fromARGB(255, 242, 243, 247),
        title: const Text(' จัดการโหนด',
            style: TextStyle(color: Colors.black87)),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_outlined),
          color: Colors.black87,
          onPressed: () {
            Navigator.push(context, MaterialPageRoute(builder: (context) {
              return const MyHomePage();
            }));
          },
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            color: Colors.black87,
            onPressed: () {},
          ),
        ],
      ),
      body: SingleChildScrollView(
        physics: BouncingScrollPhysics(),
        child: Column(
          children: [
            SizedBox(
              height: 20,
            ),
            // make container scrollable with listview

            Container(
              height: 170,
              width: 330,
              decoration: BoxDecoration(
                color: Color.fromARGB(255, 253, 253, 253),
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(10),
                  topRight: Radius.circular(50),
                  bottomLeft: Radius.circular(10),
                  bottomRight: Radius.circular(10),
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.2),
                    spreadRadius: 2,
                    blurRadius: 3,
                    offset: const Offset(0, 2), // changes position of shadow
                  ),
                ],
              ),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Column(
                        children: const [
                          Padding(
                            padding: EdgeInsets.only(top: 20, left: 20),
                            child: Text(
                              'โหนดทั้งหมด',
                              style: TextStyle(
                                fontSize: 16,
                                color: Color.fromARGB(255, 78, 78, 81),
                              ),
                            ),
                          ),
                          Padding(
                            padding: EdgeInsets.only(top: 0, left: 0),
                            child: Text(
                              '1 โหนด',
                              style: TextStyle(
                                fontSize: 16,
                                color: Color.fromARGB(255, 115, 114, 130),
                              ),
                            ),
                          ),
                          Padding(
                            padding: EdgeInsets.only(top: 20, left: 20),
                            child: Text(
                              'ปิดใช้งาน',
                              style: TextStyle(
                                fontSize: 16,
                                color: Color.fromARGB(255, 78, 78, 81),
                              ),
                            ),
                          ),
                          Padding(
                            padding: EdgeInsets.only(top: 0, left: 0),
                            child: Text(
                              '0 โหนด',
                              style: TextStyle(
                                fontSize: 16,
                                color: Color.fromARGB(255, 115, 114, 130),
                              ),
                            ),
                          ),
                        ],
                      ),
                      CircularPercentIndicator(
                        radius: 50.0,
                        lineWidth: 9.0,
                        percent: 1,
                        widgetIndicator: Center(
                            child: Container(
                          width: 6,
                          height: 6,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(50),
                            color: Color.fromARGB(255, 245, 247, 253),
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
                              padding: const EdgeInsets.fromLTRB(0, 25, 0, 0),
                              child: Text("1 โหนด",
                                  style: GoogleFonts.kanit(
                                    color: Color.fromARGB(255, 107, 108, 190),
                                    fontSize: 15,
                                  )),
                            ),
                          ],
                        ),
                        progressColor: Color.fromARGB(255, 78, 87, 216),
                        backgroundColor: Color.fromARGB(255, 223, 227, 246),
                      ),
                    ],
                  )
                ],
              ),
            ),
            SizedBox(
              height: 30,
            ),
            StreamBuilder<QuerySnapshot>(
              stream: data.snapshots(),
              builder: (context, snapshot) {
                if (snapshot.hasError) {
                  return const Text('Something went wrong');
                }

                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                }

                return ListView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: (snapshot.data!).docs.length,
                  itemBuilder: (context, index) {
                    //check length
                    if (snapshot.hasData == false) {
                      return const Text('ไม่มีข้อมูล');
                    }
                    var colorCard = Colors.red;
                    String status = '#สถานะ';
                    if ((snapshot.data!).docs[index]['status'] == 'off') {
                      status = 'Off';
                      colorCard = Colors.red;
                    } else if ((snapshot.data!).docs[index]['status'] ==
                        'on') {
                      status = 'On';
                      colorCard = Colors.green;
                    } else {
                      status = 'Unknow';
                      colorCard = Colors.orange;
                    }

                    if ((snapshot.data!).docs[index]['status'] == null ||
                        (snapshot.data!).docs[index]['name'] == null) {
                      return const Text('');
                    } else {
                      return InkWell(
                        onTap: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => ProblemDetail(
                                        docs: (snapshot.data!).docs[index],
                                      )));
                        },
                        child: Card(
                          shadowColor: Colors.black,
                          elevation: 2,
                          margin: const EdgeInsets.all(5),
                          clipBehavior: Clip.antiAlias,
                          child: Container(
                            height: 130,
                            padding: const EdgeInsets.all(0),
                            child: InkWell(
                              onTap: () {
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => UserDetail(
                                              docs:
                                                  (snapshot.data!).docs[index],
                                            )));
                              },
                              child: Row(
                                children: [
                                  Expanded(
                                    flex: 1,
                                    child: Container(
                                      color: colorCard,
                                      child: Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          if ((snapshot.data!).docs[index]
                                                  ['status'] ==
                                              'ปิดใช้งาน')
                                            const Icon(
                                              Icons.disabled_by_default,
                                              color: Colors.white,
                                            ),
                                          if ((snapshot.data!).docs[index]
                                                  ['status'] ==
                                              'เปิดใช้งาน')
                                            const Icon(
                                              Icons.bolt,
                                              color: Colors.white,
                                            ),
                                          Text(
                                            status,
                                            style: const TextStyle(
                                                color: Colors.white),
                                          ),

                                        ],
                                      ),
                                    ),
                                  ),
                                  Expanded(
                                    flex: 3,
                                    child: Container(
                                      padding: const EdgeInsets.all(10),
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            (snapshot.data!).docs[index]
                                                ['name'],
                                            style: const TextStyle(
                                                fontSize: 18,
                                                fontWeight: FontWeight.bold),
                                          ),
                                          const SizedBox(
                                            height: 5,
                                          ),
                                          Row(
                                            children: [
                                              Text(
                                                'Location: ',
                                                style: const TextStyle(
                                                    fontSize: 16,
                                                    color: Colors.black54),
                                                maxLines: 3,
                                              ),
                                              Text(
                                                '13.3456, 100.2345',
                                                style: const TextStyle(
                                                    fontSize: 16,
                                                    color: Colors.black54),
                                                maxLines: 3,
                                              ),
                                            ],
                                          ),
                                          Row(
                                            children: [
                                              Text(
                                                'Created at: ',
                                                style: const TextStyle(
                                                    fontSize: 16,
                                                    color: Colors.black54),
                                                maxLines: 3,
                                              ),
                                              Text(
                                                '19/3/2023 23:00',
                                                style: const TextStyle(
                                                    fontSize: 16,
                                                    color: Colors.black54),
                                                maxLines: 3,
                                              ),
                                            ],
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      );
                    }
                  },
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
