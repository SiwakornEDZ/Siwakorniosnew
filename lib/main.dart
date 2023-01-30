import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:google_fonts/google_fonts.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:waterlevel/pages/home.dart';
import 'package:waterlevel/pages/nav.dart';
import 'package:waterlevel/firebase_options.dart';

// final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
//     FlutterLocalNotificationsPlugin();

// await flutterLocalNotificationsPlugin
//   .resolvePlatformSpecificImplementation<AndroidFlutterLocalNotificationsPlugin>()
//   ?.createNotificationChannel(channel);
const AndroidNotificationChannel channel = AndroidNotificationChannel(
  'high_importance_channel', // id
  'High Importance Notifications', // title
  description:
      'This channel is used for important notifications.', // description
  importance: Importance.max,
);

final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
    FlutterLocalNotificationsPlugin();

// await flutterLocalNotificationsPlugin
//   .resolvePlatformSpecificImplementation<AndroidFlutterLocalNotificationsPlugin>()
//   ?.createNotificationChannel(channel);

Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  // If you're going to use other Firebase services in the background, such as Firestore,
  // make sure you call `initializeApp` before using other Firebase services.
  await Firebase.initializeApp();

  print("Handling a background message: ${message.messageId}");
}

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Tuam Yang',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        fontFamily: 'josefinSans',
        scaffoldBackgroundColor: Color.fromARGB(255, 240, 249, 255),
        textTheme: GoogleFonts.kanitTextTheme(),
        appBarTheme: AppBarTheme(
          color: Color.fromARGB(255, 240, 249, 255),
          elevation: 0,
        ),
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      
      home: const MyHomePage(),
      builder: EasyLoading.init(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key}) : super(key: key);

 

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _counter = 0;
  String? message;
  String channelId = "1000";
  String channelName = "FLUTTER_NOTIFICATION_CHANNEL";
  String channelDescription = "FLUTTER_NOTIFICATION_CHANNEL_DETAIL";
  FirebaseMessaging firebaseMessaging = FirebaseMessaging.instance;

  @override
  initState() {
        SystemChrome.setEnabledSystemUIMode (SystemUiMode.manual, overlays: []);

    var initializationSettingsAndroid =
        AndroidInitializationSettings('notiicon');

    var initializationSettingsIOS = DarwinInitializationSettings(
        onDidReceiveLocalNotification: (id, title, body, payload) async {
      print("onDidReceiveLocalNotification called.");
    });

    var initializationSettings = InitializationSettings(
        android: initializationSettingsAndroid, iOS: initializationSettingsIOS);

    flutterLocalNotificationsPlugin.initialize(initializationSettings,
        onDidReceiveNotificationResponse: (payload) async {
      // when user tap on notification.
      print("onSelectNotification called.");
      setState(() {
        message = payload.payload;
      });
    });
    initFirebaseMessaging();
    super.initState();
  }

  void initFirebaseMessaging() {
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      RemoteNotification notification = message.notification!;
      AndroidNotification? android = message.notification?.android;

      // If `onMessage` is triggered with a notification, construct our own
      // local notification to show to users using the created channel.
      if (android != null) {
        flutterLocalNotificationsPlugin.show(
            notification.hashCode,
            notification.title,
            notification.body,
            NotificationDetails(
              android: AndroidNotificationDetails(
                channel.id,
                channel.name,
                channelDescription: channel.description,
                icon: android.smallIcon,
                // other properties...
              ),
            ));
        //   var a = notification.title.toString();
        //   var b = notification.body.toString();
        //  sendNotification(a,b);
      }
    });

    firebaseMessaging.getToken().then((String? token) {
      assert(token != null);
      print("Token : $token");
    });
  }

  sendNotification(String title, String body) async {
    var androidPlatformChannelSpecifics = const AndroidNotificationDetails(
      '10000',
      'FLUTTER_NOTIFICATION_CHANNEL',
      channelDescription: 'FLUTTER_NOTIFICATION_CHANNEL_DETAIL',
      importance: Importance.max,
      priority: Priority.max, // high
    );

    var iOSPlatformChannelSpecifics = const DarwinNotificationDetails();

    var platformChannelSpecifics = NotificationDetails(
        android: androidPlatformChannelSpecifics,
        iOS: iOSPlatformChannelSpecifics);

    await flutterLocalNotificationsPlugin.show(
        111, title, body, platformChannelSpecifics,
        payload: 'I just haven\'t Met You Yet');
  }

  Future<void> sendPushMessage() async {
    firebaseMessaging.getToken().then((String? _token) async {
      assert(_token != null);
      if (_token == null) {
        print('Unable to send FCM message, no token exists.');
        return;
      }

      var st = constructFCMPayload(_token);
      try {
        await http.post(
          Uri.parse('https://fcm.googleapis.com/fcm/send'),
          headers: <String, String>{
            'Content-Type': 'application/json; charset=UTF-8',
            'Authorization': 'key=AAAAmLKrAkk:APA91bFNfnkkzPFux6GCYElkMxU55dBYaMcygsIIGkAbOK5DOheKDXgHuirJTshpHYdvZ5x1-oV0yrcEbS1sJNCygdOR-dD3r3zfZ5dZNP0FzfxGCKPZh38-TAUcv24FUNIBGrW4rU2z',
          },
          body: st,
        );
        print('FCM request for device sent!');
      } catch (e) {
        print(e);
      }
      print("Token : $_token");
    });
  }

  @override
  Widget build(BuildContext context) {
      final GlobalKey<ScaffoldState> _drawerKey = new GlobalKey<ScaffoldState>();
    return Scaffold(
      appBar: AppBar(
        leading: Container(
          margin: EdgeInsets.all(5),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16),
            color: Color.fromARGB(255, 220, 238, 255),
          ),
          child: IconButton(
              icon: Icon(
                Icons.menu,
                color: Color.fromARGB(255, 46, 66, 110),
              ),
                        onPressed: () {
            _drawerKey.currentState!.openDrawer();
          },
        ),
        ),
        title: Text('แอพพลิเคชั่นตรวจสอบระดับน้ำ',
            style: TextStyle(
                color: Color.fromARGB(255, 46, 66, 110),
                fontSize: 20,
                fontWeight: FontWeight.bold)),
        actions: [
          IconButton(
              icon: Icon(
                Icons.notifications,
                color: Color.fromARGB(255, 46, 66, 110),
              ),
              onPressed: () {})
        ],
      ),
      body: Home(),
            key: _drawerKey,
                 drawer: Container(
              width: MediaQuery.of(context).size.width / 1.3,
              child: DrawerWidget()
              ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          sendPushMessage();
        },
        tooltip: 'Increment',
        child: const Icon(Icons.notifications_active),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}

int _messageCount = 0;
String constructFCMPayload(String token) {
  _messageCount++;
  return jsonEncode({
    'to': token,
    'data': {
      'via': 'Firebase Cloud Messaging!!! ',
      'count': _messageCount.toString(),
    },
    'notification': {
      'title': 'Hello Firebase Cloud Messaging!',
      'body': 'This notification (#$_messageCount) was created via FCM!',
    },
  });
}
