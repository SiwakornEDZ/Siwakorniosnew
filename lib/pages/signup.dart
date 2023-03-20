import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/scheduler.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:waterlevel/pages/login.dart';

class Signup extends StatefulWidget {
  const Signup({Key? key}) : super(key: key);

  @override
  _SignupState createState() => _SignupState();
}

class _SignupState extends State<Signup> {
  final _formstate = GlobalKey<FormState>();
  TextEditingController email = TextEditingController();
  TextEditingController password = TextEditingController();
  TextEditingController confirmPassword = TextEditingController();
  TextEditingController name = TextEditingController();
  String? countUser;
  String? countID;
  bool hidePassword = true;
  bool hideConfirmPassword = true;

  void togglePasswordView() {
    setState(() {
      hidePassword = !hidePassword;
    });
  }

  void toggleConfirmPasswordView() {
    setState(() {
      hideConfirmPassword = !hideConfirmPassword;
    });
  }

  @override
  void initState() {
    super.initState();
    if (FirebaseAuth.instance.currentUser != null) {
      print('Found user');
      SchedulerBinding.instance.addPostFrameCallback((_) {
        Navigator.push(
            context, new MaterialPageRoute(builder: (context) => Login()));
      });
    } else {
      print('ไม่พบการเข้าสู่ระบบ');
    }
  }

  final auth = FirebaseAuth.instance;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          backgroundColor: Colors.white,
          leading: IconButton(
            icon: const Icon(Icons.arrow_back_ios_new_outlined,
                color: Colors.black87, size: 20),
            color: Colors.black87,
            onPressed: () {
              //   Navigator.pop(context);
              Navigator.pushNamed(context, '/');
            },
          ),
          actions: <Widget>[
            //  status == 1 ? logoutButton(context) : Container(),
          ],
        ),
        body: Form(
          key: _formstate,
          child: ListView(
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.only(top: 30.0),
                child: SizedBox(
                  height: 100,
                  child: Image.network(
                      "https://cdn-icons-png.flaticon.com/512/2397/2397697.png"),
                ),
              ),
              SizedBox(height: 50),
              Container(
                  alignment: Alignment.topLeft,
                  child: Text(
                    "    สมัครสมาชิก",
                    style: GoogleFonts.kanit(
                      fontSize: 20,
                      color: Colors.black,
                    ),
                  )),
              Text(
                "              กรอกข้อมูลเพื่อทำการลงทะเบียน",
                style: GoogleFonts.kanit(
                  fontSize: 14,
                  color: Colors.black,
                ),
              ),
              SizedBox(height: 20),
              Container(
                  margin: const EdgeInsets.only(left: 40.0, right: 40.0),
                  child: buildNameField()),
              SizedBox(height: 10),
              Container(
                  margin: const EdgeInsets.only(left: 40.0, right: 40.0),
                  child: buildEmailField()),
              SizedBox(height: 10),
              Container(
                  margin: const EdgeInsets.only(left: 40.0, right: 40.0),
                  child: buildPasswordField()),
              SizedBox(height: 10),
              Container(
                  margin: const EdgeInsets.only(left: 40.0, right: 40.0),
                  child: buildConfirmPasswordField()),
              SizedBox(height: 30),
              Container(
                  height: 50,
                  margin: const EdgeInsets.only(left: 100.0, right: 100.0),
                  child: buildRegisterButton()),
            ],
          ),
        ));
  }

  ElevatedButton buildRegisterButton() {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        primary: Colors.red[400],
        onPrimary: Colors.white,
        shape:
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.0)),
      ),
      child: Text(
        'สมัครสมาชิก',
        style: GoogleFonts.kanit(
          fontSize: 18,
          color: Colors.white,
        ),
      ),
      onPressed: () async {
        print('Register');
        registerWithEmailPassword();
      },
    );
  }

  Future<void> registerWithEmailPassword() async {
    if (FirebaseAuth.instance.currentUser == null) {
      try {
        final _user = await auth.createUserWithEmailAndPassword(
          email: email.text.trim(),
          password: password.text.trim(),
        );
        print(_user.user!.uid);
        FirebaseAuth.instance.currentUser!.updateDisplayName(name.text.trim());
        countDocuments();
        _user.user!.sendEmailVerification();
      } on FirebaseAuthException catch (e) {
        if (e.code == 'weak-password') {
          print('The password provided is too weak.');
        } else if (e.code == 'email-already-in-use') {
          print('The account already exists for that email.');
          ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text("อีเมลล์ถูกใช้งานแล้ว")));
        } else if (e.code == 'operation-not-allowed') {
          print('There is a problem with auth service config :/');
        } else if (e.code == 'weak-password') {
          print('Please type stronger password');
        } else {
          print('auth error ' + e.toString());
          print(e);
        }
      }
    } else {
      Navigator.pushReplacement(
          context, CupertinoPageRoute(builder: (_) => Login()));
    }
  }

  TextFormField buildPasswordField() {
    return TextFormField(
      controller: password,
      validator: (value) {
        if (value!.length < 8)
          return 'Please Enter more than 8 Character';
        else
          return null;
      },
      obscureText: hidePassword,
      keyboardType: TextInputType.text,
      decoration: InputDecoration(
        border: OutlineInputBorder(
          borderRadius: BorderRadius.all(Radius.circular(22.0)),
        ),
        prefixIcon: Icon(Icons.lock),
        labelText: 'Password',
        suffixIcon: IconButton(
          onPressed: togglePasswordView,
          icon: Icon(
            hidePassword ? Icons.visibility_off : Icons.visibility,
          ),
        ),
      ),
    );
  }

  TextFormField buildConfirmPasswordField() {
    return TextFormField(
      controller: confirmPassword,
      validator: (value) {
        if (value!.isEmpty) return 'กรุณากรอกรหัสผ่านอีกครั้ง';
        if (value != password.text) return 'รหัสผ่านไม่ตรงกัน';
        return null;
      },
      obscureText: hideConfirmPassword,
      keyboardType: TextInputType.text,
      decoration: InputDecoration(
        border: OutlineInputBorder(
          borderRadius: BorderRadius.all(Radius.circular(22.0)),
        ),
        prefixIcon: Icon(Icons.lock),
        labelText: 'Confirm Password',
        suffixIcon: IconButton(
          onPressed: toggleConfirmPasswordView,
          icon: Icon(
            hideConfirmPassword ? Icons.visibility_off : Icons.visibility,
          ),
        ),
      ),
    );
  }

  TextFormField buildNameField() {
    return TextFormField(
      controller: name,
      validator: (value) {
        if (value!.isEmpty)
          return 'กรุณากรอกชื่อ';
        else
          return null;
      },
      keyboardType: TextInputType.name,
      textInputAction: TextInputAction.next,
      decoration: const InputDecoration(
        border: OutlineInputBorder(
          borderRadius: BorderRadius.all(Radius.circular(22.0)),
        ),
        prefixIcon: Icon(Icons.person),
        labelText: 'Name',
        hintText: 'Sivagon ganjanaburi',
      ),
    );
  }

  TextFormField buildEmailField() {
    return TextFormField(
      controller: email,
      validator: (value) {
        if (value!.isEmpty)
          return 'กรุณากรอกอีเมล';
        else
          return null;
      },
      keyboardType: TextInputType.emailAddress,
      textInputAction: TextInputAction.next,
      decoration: const InputDecoration(
        border: OutlineInputBorder(
          borderRadius: BorderRadius.all(Radius.circular(22.0)),
        ),
        prefixIcon: Icon(Icons.email),
        labelText: 'E-mail',
        hintText: 'email@example.com',
      ),
    );
  }

  Future<bool> isUserLogged() async {
    var user = await auth.currentUser;
    if (user != null) {
      return true;
    } else {
      return false;
    }
  }

  void countDocuments() async {
    QuerySnapshot _allUser =
        await FirebaseFirestore.instance.collection('users').get();
    List<DocumentSnapshot> _myDocCount = _allUser.docs;
    countUser = _myDocCount.length.toString();
    print('จำนวนข้อมูลก่อนเพิ่ม $countUser');
    updateDocuments();
  }

  void updateDocuments() async {
    QuerySnapshot query = await FirebaseFirestore.instance
        .collection('users_count')
        .where('userallcount')
        .get();
    if (query.docs.isNotEmpty) {
      FirebaseFirestore.instance
          .collection('users_count')
          .where('userallcount')
          .get()
          .then((value) => FirebaseFirestore.instance
              .collection('users_count')
              .doc(value.docs[0].id)
              .update({"userallcount": FieldValue.increment(1)}));
      print('Add 1 to allcount');
      createID();
    } else if (query.docs.isEmpty) {
      print('ไม่สามารถเพิ่มฟอร์มจำนวนได้');
    }
  }

  void createID() async {
    QuerySnapshot createcountid = await FirebaseFirestore.instance
        .collection('users_count')
        .where('userallcount')
        .get();
    if (createcountid.docs.isNotEmpty) {
      var countid = (createcountid.docs[0]['userallcount'].toString());
      print("จำนวนข้อมูล ID ทั้งหมดที่สร้างและ ID ปัจจุบัน : $countid");
      setState(() {
        countID = countid;
      });
      uploadUser(countID!);
    }
  }

  void uploadUser(String countID) async {
    await FirebaseFirestore.instance.collection("users").doc(email.text).set({
      "id": countID,
      "uid": auth.currentUser!.uid,
      "email": email.text,
      "name": name.text,
      "admin": false.toString(),
      "created_at": DateTime.now().toString(),
      "loginwith": 'Firebase',
      "avatar":
          'https://firebasestorage.googleapis.com/v0/b/mainproject-25523.appspot.com/o/avatarnull%2Favatar.png?alt=media&token=14755271-9e58-4710-909c-b10f9c1917e9'
    });
    await FirebaseFirestore.instance
        .collection('users_option')
        .doc(email.text)
        .set({
      "email": email.text,
      "notification": false.toString(),
      "fullscreen": true.toString(),
    });
    FirebaseAuth.instance.signOut();
    _signOut();
    goLoginPage();
  }

  Future _signOut() async {
    await FirebaseAuth.instance.signOut();
    Navigator.pushAndRemoveUntil(context,
        MaterialPageRoute(builder: (context) => Login()), (route) => false);
  }

  void goLoginPage() {
    FirebaseAuth.instance.signOut();
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (context) => Login(),
      ),
    );
  }
}
