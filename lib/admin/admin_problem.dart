import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:waterlevel/admin/admin_problem_detail.dart';
import 'package:waterlevel/admin/admin_function.dart';
import 'package:waterlevel/main.dart';
import 'package:waterlevel/pages/nav.dart';

class Problem extends StatefulWidget {
  const Problem({super.key});
  @override
  State<Problem> createState() => _ProblemState();
}

class _ProblemState extends State<Problem> {
    
  Query<Map<String, dynamic>> data = FirebaseFirestore.instance
      .collection('user_report')
      .orderBy('date', descending: true);

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
            Navigator.push(context, MaterialPageRoute(builder: (context) {
              return const MyHomePage();
            }));
          },
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.edit),
            color: Colors.black87,
            onPressed: () {

            },
          ),
        ],
      ),
      body: StreamBuilder<QuerySnapshot>(
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
            physics: const BouncingScrollPhysics(
              parent: AlwaysScrollableScrollPhysics(
                parent: BouncingScrollPhysics(),
              ),
            ),
            itemCount: (snapshot.data!).docs.length,
            itemBuilder: (context, index) {
              //check length
              if(snapshot.hasData == false){
                return const Text('ไม่มีข้อมูล');
              }
              var colorCard = Colors.red;
              String status = '#สถานะ';
              if ((snapshot.data!).docs[index]['solve'] == 'true') {
                status = 'แก้ไขแล้ว';
                colorCard = Colors.green;
              }
              else if ((snapshot.data!).docs[index]['solve'] == 'false') {
                status = 'ยังไม่แก้ไข';
                colorCard = Colors.red;
              }
              else {
                status = 'กำลังดำเนินการ';
                colorCard = Colors.orange;
              }
              
              if ((snapshot.data!).docs[index]['topic'] == null ||
                  (snapshot.data!).docs[index]['descript'] == null) {
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
                                          builder: (context) => ProblemDetail(
                                                docs: (snapshot.data!)
                                                    .docs[index],
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
                                                    ['solve'] ==
                                                'true')
                                              const Icon(
                                                Icons.check_circle,
                                                color: Colors.white,
                                              ),
                                            if ((snapshot.data!).docs[index]
                                                    ['solve'] ==
                                                'false')
                                              const Icon(
                                                Icons.cancel,
                                                color: Colors.white,
                                              ),
                                            if ((snapshot.data!).docs[index]
                                                    ['solve'] ==
                                                'process')
                                              const Icon(
                                                Icons.pending_actions,
                                                color: Colors.white,
                                              ),
                                            Text(status,
                                              style: const TextStyle(
                                                  color: Colors.white),
                                            ),
                                            Text(
                                              (snapshot.data!).docs[index]
                                                  ['date']
                                                  .toDate()
                                                  .toString()
                                                  .substring(0, 10),
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
                                                  ['topic'],
                                              style: const TextStyle(
                                                  fontSize: 18,
                                                  fontWeight: FontWeight.bold),
                                                   
                                            ),
                                            const SizedBox(
                                              height: 5,
                                            ),
                                            Text(
                                              (snapshot.data!).docs[index]
                                                  ['descript'],
                                              style: const TextStyle(
                                                  fontSize: 16,
                                                  color: Colors.black54),
                                                  maxLines: 3,
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
    );
  }
}
