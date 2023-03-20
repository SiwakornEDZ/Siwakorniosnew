import 'package:mysql_client/mysql_client.dart';

 connectMySQL() async {
  print("Connecting to MySQL server...");
  final conn = await MySQLConnection.createConnection(
    host: "databases.000webhost.com",
    port: 3306,
    userName: "id20242880_root",
    // ignore: unnecessary_string_escapes
    password: "LILy7\O+!_kz3MRs",
    databaseName: "id20242880_waterlevel", // optional
  );
  await conn.connect();
  print("Connected");
}
