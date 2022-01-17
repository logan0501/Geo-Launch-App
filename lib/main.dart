import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:huawei_site/huawei_site.dart';
import 'package:tourist_app/ImageScreen.dart';
import 'package:tourist_app/KeywordScreen.dart';
import 'package:tourist_app/NearbyScreen.dart';

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
      home: const MyHomePage(title: 'Tourist App'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key, required this.title}) : super(key: key);

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _counter = 0;
  late SearchService searchService;
  late TextSearchResponse response;
  String text = "";

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

//   void callservice() async {
//     String API_KEY = Uri.encodeComponent(
//         "DAEDABuQsxc69ORIjtCEgqA6U+c6jKehbKjsmmDoSpI2RM2YHirS/qSmWLJkZi7guhfXoNvpdCB/OM5g95hMmlftG3A69Abg526NVQ==");
//
// // DeclareanSearchService object and instantiate it.
//     searchService = await SearchService.create(API_KEY);
//     late TextSearchRequest request;
//
//     request = TextSearchRequest(query: "Eiffel Tower");
//     request.location = Coordinate(lat: 48.893478, lng: 2.334595);
//     request.language = "en";
//     request.countryCode = "FR";
//     request.pageIndex = 1;
//     request.pageSize = 20;
//     request.radius = 5000;
//     request.countries = ['en', 'fr', 'cn', 'de', 'ko'];
//     response = await searchService.textSearch(request);
//     setState(() {
//       text = response.toString();
//       print(text);
//     });
//   }

  void _incrementCounter() {
    setState(() {
      // This call to setState tells the Flutter framework that something has
      // changed in this State, which causes it to rerun the build method below
      // so that the display can reflect the updated values. If we changed
      // _counter without calling setState(), then the build method would not be
      // called again, and so nothing would appear to happen.
      _counter++;
    });
  }

  @override
  Widget build(BuildContext context) {
    // This method is rerun every time setState is called, for instance as done
    // by the _incrementCounter method above.
    //
    // The Flutter framework has been optimized to make rerunning build methods
    // fast, so that you can just rebuild anything that needs updating rather
    // than having to individually change instances of widgets.
    return Scaffold(
      appBar: AppBar(
        // Here we take the value from the MyHomePage object that was created by
        // the App.build method, and use it to set our appbar title.
        title: Text(widget.title),
        centerTitle: true,
        backgroundColor: Colors.blue,
      ),
      resizeToAvoidBottomInset: false,
      body: Column(
        children: <Widget>[
          Container(
              padding: EdgeInsets.all(10),
              child: Text(
                "FEATURES WE OFFER",
                style: TextStyle(
                  color: Colors.blue,
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              )),
          GestureDetector(
            onTap: () {
              Navigator.push(context,
                  MaterialPageRoute(builder: (context) => KeywordScreen()));
            },
            child: Card(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: ListTile(
                  leading: Icon(
                    Icons.home,
                    size: 40,
                  ),
                  title: Text(
                    "Keyword Search",
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  subtitle: Text(
                    "Returns a place list based on keywords entered by the user.",
                  ),
                ),
              ),
            ),
          ),
          GestureDetector(
            onTap: () {
              Navigator.push(context,
                  MaterialPageRoute(builder: (context) => NearbyScreen()));
            },
            child: Card(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: ListTile(
                  leading: Icon(
                    Icons.home,
                    size: 40,
                  ),
                  title: Text(
                    "Nearby Place Search",
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  subtitle: Text(
                      "Searches for nearby places based on the current location of the user's device."),
                ),
              ),
            ),
          ),
          GestureDetector(
            onTap: (){
              Navigator.push(context,MaterialPageRoute(builder: (context)=>ImageScreen()));
            },
            child: Card(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: ListTile(
                  leading: Icon(
                    Icons.home,
                    size: 40,
                  ),
                  title: Text(
                    "Image Based Place Search",
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  subtitle: Text("Detect a landmark with the image."),
                ),
              ),
            ),
          ),
        ],
      ),
      // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}
