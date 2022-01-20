import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:huawei_site/huawei_site.dart';
import 'package:splashscreen/splashscreen.dart';
import 'package:tourist_app/ImageScreen.dart';
import 'package:tourist_app/KeywordScreen.dart';
import 'package:tourist_app/NearbyScreen.dart';

import 'home_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: ThemeData(
        // This is the theme of your application.
        //
        // Try running your application with "flutter run". You'll see the
        // application has a blue toolbar. Then, without quitting the app, try
        // changing the primarySwatch below to Colors.green and then invoke
        // "hot reload" (press "r" in the console where you ran "flutter run",
        // or simply save your changes to "hot reload" in a Flutter IDE).
        // Notice that the counter didn't reset back to zero; the application
        // is not restarted.
        primarySwatch: Colors.blue,
      ),
      home: SplashScreen(
        seconds: 3,
        navigateAfterSeconds:MyHomePage(title: 'GEO LAUNCH'),
        image: Image.asset('assets/logopng.png'),
        photoSize: 100,
        backgroundColor:  Color(0xff161616),
        loaderColor: Color(0xffFBAA27),
      ),
    );
  }
}
