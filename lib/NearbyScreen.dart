import 'package:flutter/material.dart';
import 'package:huawei_site/huawei_site.dart';
import 'package:location/location.dart' as loc;
import 'package:geocoding/geocoding.dart';

class NearbyScreen extends StatefulWidget {
  const NearbyScreen({Key? key}) : super(key: key);

  @override
  _NearbyScreenState createState() => _NearbyScreenState();
}

class _NearbyScreenState extends State<NearbyScreen> {
  String str = "";
  late SearchService searchService;
  late TextSearchResponse response;
  var location = new loc.Location();
  late loc.LocationData userLocation;
  late List<Placemark> placemarks;

  String locality = "", subarea = "", area = "", postal = "", country = "";
  late Future myfuture, myfuture2;

  @override
  void initState() {
    // TODO: implement initState
    myfuture = getLocation();

    myfuture2 = getNearbyPlaces();
    super.initState();
    initService();
  }

  void initService() async {
    String API_KEY = Uri.encodeComponent(
        "DAEDABuQsxc69ORIjtCEgqA6U+c6jKehbKjsmmDoSpI2RM2YHirS/qSmWLJkZi7guhfXoNvpdCB/OM5g95hMmlftG3A69Abg526NVQ==");
    searchService = await SearchService.create(API_KEY);
  }

  Future<List<String>> getLocation() async {

    print("called");
    late List<String> map;
    try {
      userLocation = await location.getLocation();
      placemarks = await placemarkFromCoordinates(
          userLocation.latitude!, userLocation.longitude!);
      map= [
        placemarks[0].locality!,
        placemarks[0].subAdministrativeArea!,
        placemarks[0].administrativeArea!,
        placemarks[0].postalCode!,
        placemarks[0].country!,
      ];
    } catch (e) {
      print("error occured");
    }
    return map;
  }

  Future<List<Site?>> getNearbyPlaces() async {
    await Future.delayed(Duration(seconds: 1));
    List<Site?> sitelist = [];
    try{
      print("called");
      late NearbySearchRequest request;
      request = NearbySearchRequest(location: Coordinate(lat: userLocation.latitude, lng: userLocation.longitude));
      request.language = "en";
      request.pageIndex = 1;
      request.pageSize = 20;
      request.radius = 5000;
      NearbySearchResponse response = await searchService.nearbySearch(request);

      var data = response.sites;
      print("data $data");
      if (data != null) {
        for (var u in data) {
          if (u != null) sitelist.add(u);
        }
      }
    }catch(e){
      print(e);
    }


    return sitelist;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Nearby Location Search"),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            FutureBuilder(
                future: getLocation(),
                builder: (BuildContext context, AsyncSnapshot snapshot) {
                  ConnectionState connectionstate = snapshot.connectionState;
                  print(snapshot.data);
                  if (connectionstate == ConnectionState.waiting) {
                    return Text('Getting details');
                  } else if (snapshot.hasError)
                    return Text("Error while fetching data");
                  else if (snapshot.hasData) {
                    return Card(
                      color: Colors.white,
                      child: ListTile(
                        title: Text(
                          "Current Location : ${snapshot.data[0]} ${snapshot.data[1]} ${snapshot.data[2]} ${snapshot.data[3]!} ",
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                        subtitle: Text("Country: ${snapshot.data[4]}"),
                      ),
                    );
                  } else
                    return Text("Error");
                }),
            FutureBuilder(
                future: myfuture2,
                builder: (BuildContext context, AsyncSnapshot snapshot) {
                  ConnectionState connectionstate = snapshot.connectionState;
                  if (connectionstate == ConnectionState.waiting) {
                    return Text('Getting details');
                  } else if (snapshot.hasError)
                    return Text("Error while fetching data");
                  else if (snapshot.hasData) {
                    return Column(
                      children: [
                        ...snapshot.data.map((element) {
                          return Card(
                            child: ListTile(
                              title: Text(element.name),
                            ),
                          );
                        }).toList(),
                      ],
                    );
                  } else
                    return Text("Error");
                }),
          ],
        ),
      ),
    );
  }
}
