import 'package:flutter/material.dart';
import 'package:flutter_chat_app/pages/LoginPage.dart';

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
