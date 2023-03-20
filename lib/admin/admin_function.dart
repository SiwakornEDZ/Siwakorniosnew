import 'dart:convert';
import 'package:http/http.dart';

var httpsUri =
    Uri(scheme: 'https', host: 'fcm.googleapis.com', path: '/fcm/send');

Future<void> sendFCM() async {

  Map<String, String> headers = {
    'Content-Type': 'application/json',
    'Authorization':
        'key=AAAAmLKrAkk:APA91bFNfnkkzPFux6GCYElkMxU55dBYaMcygsIIGkAbOK5DOheKDXgHuirJTshpHYdvZ5x1-oV0yrcEbS1sJNCygdOR-dD3r3zfZ5dZNP0FzfxGCKPZh38-TAUcv24FUNIBGrW4rU2z',
  };
  String jsonMap = jsonEncode({
    "to": "/topics/all",
    "notification": {
      "title": "Water Level",
      "body": "ระดับน้ำเกินค่าที่กำหนดแล้ว"
    }
  });

  final encoding = Encoding.getByName('utf-8');
  Response response = await post(
    httpsUri,
    headers: headers,
    body: jsonMap,
    encoding: encoding,
  );
  print(response.body);
}

Future<void> sendFCMProblem(String topic,String title, String body) async {

  Map<String, String> headers = {
    'Content-Type': 'application/json',
    'Authorization':
        'key=AAAAmLKrAkk:APA91bFNfnkkzPFux6GCYElkMxU55dBYaMcygsIIGkAbOK5DOheKDXgHuirJTshpHYdvZ5x1-oV0yrcEbS1sJNCygdOR-dD3r3zfZ5dZNP0FzfxGCKPZh38-TAUcv24FUNIBGrW4rU2z',
  };
  String jsonMap = jsonEncode({
    "to": "/topics/$topic",
    "notification": {
      "title": title,
      "body": body
    }
  });

  final encoding = Encoding.getByName('utf-8');
  Response response = await post(
    httpsUri,
    headers: headers,
    body: jsonMap,
    encoding: encoding,
  );
  print(response.body);
}
