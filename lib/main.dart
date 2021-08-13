import 'package:crate_and_barrel/constants.dart';
import 'package:crate_and_barrel/home_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      themeMode: ThemeMode.dark,
      darkTheme: ThemeData(
        brightness: Brightness.light,
        scaffoldBackgroundColor: kPrimaryColor,
        primarySwatch: Colors.grey,
        primaryColor: kPrimaryColor,
        appBarTheme: const AppBarTheme(
          elevation: 0,
          backgroundColor: Colors.transparent,
          textTheme: TextTheme(
            headline6: TextStyle(
              fontSize: 28,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        textTheme: const TextTheme(
          bodyText2: TextStyle(color: Colors.white),
        ),
      ),
      home: const HomePage(),
    );
  }
}
