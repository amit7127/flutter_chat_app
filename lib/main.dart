import 'package:flutter/material.dart';
import 'file:///D:/Practice%20Project/flutter_chat_app/lib/pages/login/LoginPage.dart';

void main()async {
  WidgetsFlutterBinding.ensureInitialized();
  //await Firebase.initializeApp();

  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Chat App',
      theme: ThemeData(primaryColor: Colors.blueAccent),
      home: LoginScreen(),
      debugShowCheckedModeBanner: false,
    );
  }
}
