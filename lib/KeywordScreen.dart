import 'package:flutter/material.dart';
import 'package:huawei_site/huawei_site.dart';
import 'package:maps_launcher/maps_launcher.dart';

class KeywordScreen extends StatefulWidget {
  const KeywordScreen({Key? key}) : super(key: key);

  @override
  _KeywordScreenState createState() => _KeywordScreenState();
}

class _KeywordScreenState extends State<KeywordScreen> {
  String str = "";
  late SearchService searchService;
  late TextSearchResponse response;
  TextEditingController _controller = TextEditingController();
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    initService();
  }

  void initService() async {
    String API_KEY = Uri.encodeComponent(
        "DAEDABuQsxc69ORIjtCEgqA6U+c6jKehbKjsmmDoSpI2RM2YHirS/qSmWLJkZi7guhfXoNvpdCB/OM5g95hMmlftG3A69Abg526NVQ==");
    searchService = await SearchService.create(API_KEY);
  }

  Future<List<Site?>> callservice() async {
    late TextSearchRequest request;

    request = TextSearchRequest(query: str);
    // request.location = Coordinate(lat: 48.893478, lng: 2.334595);
    request.language = "en";
    // request.countryCode = "FR";
    request.pageIndex = 1;
    request.pageSize = 20;
    // request.radius = 5000;
    // request.countries = ['en', 'fr', 'cn', 'de', 'ko'];
    response = await searchService.textSearch(request);

    List<Site?> sitelist = [];
    var data = response.sites;
    print("data $data");
    if (data != null) {
      for (var u in data) {
        if (u != null) sitelist.add(u);
      }
    }
    return sitelist;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        // Here we take the value from the MyHomePage object that was created by
        // the App.build method, and use it to set our appbar title.
        title: Text("Keyword Search"),
        centerTitle: true,
        backgroundColor: Color(0xff161616),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Container(
              margin: EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: Colors.grey.withOpacity(0.3),
                borderRadius: BorderRadius.circular(100),
              ),
              child: Row(
                children: [
                  Expanded(
                    child: TextField(
                      onChanged: (val) {
                        setState(() {
                          str = val;
                        });
                      },
                      controller: _controller,
                      decoration: InputDecoration(
                        hintText: "Enter Keyword..",
                        contentPadding: EdgeInsets.symmetric(horizontal: 20),
                        border: InputBorder.none,
                      ),
                      style: TextStyle(fontSize: 18),
                    ),
                  ),
                  GestureDetector(
                      onTap: () {
                        _controller.clear();
                        setState(() {
                          str = "";
                        });
                      },
                      child: Padding(
                        padding: const EdgeInsets.only(right: 10.0),
                        child: Icon(
                          Icons.clear,
                          size: 16,
                        ),
                      )),
                ],
              ),
            ),
            Divider(
              thickness: 1,
            ),
            FutureBuilder(
              future: callservice(), // async work
              builder: (BuildContext context, AsyncSnapshot snapshot) {
                switch (snapshot.connectionState) {
                  case ConnectionState.waiting:
                    return Text('Loading....');
                  default:
                    if (snapshot.hasError)
                      return Text('Start Typing to fetch details');
                    if (snapshot.hasData) {
                      return Column(
                        children: [
                          ...snapshot.data.map((element) {
                            return GestureDetector(
                              onTap: () {
                                showDialog(
                                    context: context,
                                    builder: (context) => AlertDialog(
                                          title: Text(element.name),
                                          content: Text(
                                              "FormatAddress : ${element.formatAddress}\nCountry : ${element.address.country}\nAdminArea : ${element.address.adminArea}\nSubAdminArea : ${element.address.subAdminArea}\nLocality : ${element.address.locality}\nPostalCode : ${element.address.postalCode}\nLocation : ${element.location} "),
                                          actions: [
                                            ElevatedButton(
                                                style: ElevatedButton.styleFrom(primary: Color(0xff161616)),
                                                onPressed: () {
                                                  MapsLauncher.launchCoordinates(element.location.lat,element.location.lng);
                                                },
                                                child:
                                                    Text("View on Google Maps",style: TextStyle(color: Color(0xffFBAA27)),))
                                          ],
                                        ));
                              },
                              child: Card(
                                
                                  child: ListTile(
                                title: Text(
                                  element.name,
                                  style: TextStyle(fontWeight: FontWeight.bold),
                                ),
                                subtitle: Text(element.formatAddress),
                              )),
                            );
                          }).toList(),
                        ],
                      );
                    } else
                      return Text('Loading');
                }
              },
            )
          ],
        ),
      ),
    );
  }
}
