import 'package:flutter/material.dart';
import 'package:huawei_site/huawei_site.dart';
import 'package:location/location.dart' as loc;
import 'package:geocoding/geocoding.dart';
import 'package:maps_launcher/maps_launcher.dart';

class NearbyScreen extends StatefulWidget {
  const NearbyScreen({Key? key}) : super(key: key);

  @override
  _NearbyScreenState createState() => _NearbyScreenState();
}

class _NearbyScreenState extends State<NearbyScreen> {
  List<Site> sitelist = [];
  double radius = 10000;
  String str = "";

  late SearchService searchService;
  late TextSearchResponse response;
  var location = new loc.Location();
  late loc.LocationData userLocation;
  late List<Placemark> placemarks;
  List<LocationType> locationtypes = [
    LocationType.ACCOUNTING,
    LocationType.AIRPORT,
    LocationType.AQUARIUM,
    LocationType.ART_GALLERY,
    LocationType.ATM,
    LocationType.BAKERY,
    LocationType.BANK,
    LocationType.BAR,
    LocationType.BEAUTY_SALON,
    LocationType.BOOK_STORE,
    LocationType.BUS_STATION,
    LocationType.CAFE,
    LocationType.CAR_DEALER,
    LocationType.CAR_RENTAL,
    LocationType.CAR_REPAIR,
    LocationType.CAR_WASH,
    LocationType.CHURCH,
    LocationType.CLOTHING_STORE,
    LocationType.DOCTOR,
    LocationType.ELECTRICIAN,
    LocationType.ELECTRONICS_STORE,
    LocationType.FINANCE,
    LocationType.FIRE_STATION,
    LocationType.FLORIST,
    LocationType.FURNITURE_STORE,
    LocationType.GAS_STATION,
    LocationType.GROCERY_OR_SUPERMARKET,
    LocationType.GYM,
    LocationType.HAIR_CARE,
    LocationType.HARDWARE_STORE,
    LocationType.HEALTH,
    LocationType.HINDU_TEMPLE,
    LocationType.HOME_GOODS_STORE,
    LocationType.HOSPITAL,
    LocationType.INSURANCE_AGENCY,
    LocationType.JEWELRY_STORE,
    LocationType.LAUNDRY,
    LocationType.LAWYER,
    LocationType.LIBRARY,
    LocationType.LIGHT_RAIL_STATION,
    LocationType.LOCAL_GOVERNMENT_OFFICE,
    LocationType.MEAL_DELIVERY,
    LocationType.MEAL_TAKEAWAY,
    LocationType.MOSQUE,
    LocationType.MOVIE_THEATER,
    LocationType.MUSEUM,
    LocationType.PAINTER,
    LocationType.PARK,
    LocationType.PARKING,
    LocationType.PET_STORE,
    LocationType.PHARMACY,
    LocationType.PHYSIOTHERAPIST,
    LocationType.PLACE_OF_WORSHIP,
    LocationType.PLUMBER,
    LocationType.POLICE,
    LocationType.POST_BOX,
    LocationType.POST_OFFICE,
    LocationType.PRIMARY_SCHOOL,
    LocationType.RESTAURANT,
    LocationType.ROOM,
    LocationType.SCHOOL,
    LocationType.SECONDARY_SCHOOL,
    LocationType.SHOE_STORE,
    LocationType.SHOPPING_MALL,
    LocationType.STADIUM,
    LocationType.STORE,
    LocationType.SUBWAY_STATION,
    LocationType.SUPERMARKET,
    LocationType.TAXI_STAND,
    LocationType.TOURIST_ATTRACTION,
    LocationType.TRAIN_STATION,
    LocationType.TRAVEL_AGENCY,
    LocationType.UNIVERSITY,
    LocationType.VETERINARY_CARE,
    LocationType.ZOO
  ];

  String locality = "", subarea = "", area = "", postal = "", country = "";
  late Future myfuture, myfuture2;
  String _locationtype = LocationType.STORE.toString();
  @override
  void initState() {
    // TODO: implement initState
    initService();
    myfuture = getLocation();

    super.initState();
    getNearbyPlaces();
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
      map = [
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

  void getNearbyPlaces() async {
    sitelist.clear();
    await Future.delayed(Duration(seconds: 1));

    try {
      print("called");
      late NearbySearchRequest request;
      request = NearbySearchRequest(
          location: Coordinate(
              lat: userLocation.latitude, lng: userLocation.longitude));
      request.language = "en";
      request.pageIndex = 1;
      request.pageSize = 20;
      request.radius = radius.toInt();
      request.poiType = LocationType.fromString(_locationtype);
      print("CALLED INNER");
      NearbySearchResponse response = await searchService.nearbySearch(request);

      var data = response.sites;
      print("data $data");
      if (data != null) {
        for (var u in data) {
          if (u != null) sitelist.add(u);
        }
        setState(() {});
        print(sitelist);
      } else {
        print("No data found");
      }
    } catch (e) {
      print(e);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Nearby Location Search"),
        backgroundColor: Color(0xff161616),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(
              "Radius(in KM) ${(radius / 1000).toString()}",
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
          ),
          Slider(
            thumbColor: Color(0xff161616),
            activeColor: Color(0xff161616),
            inactiveColor: Colors.grey,
            min: 10000,
            max: 50000,
            value: radius,
            divisions: 10,
            onChanged: (value) {
              setState(() {
                radius = value;
                getNearbyPlaces();
              });
            },
          ),
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
                  return Container(
                    height: 80,
                    width: double.infinity,
                    child: Card(
                      color: Colors.white,
                      child: ListTile(
                        title: Text(
                          "Current Location : ${snapshot.data[0]} ${snapshot.data[1]} ${snapshot.data[2]} ${snapshot.data[3]!} ",
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                        subtitle: Text("Country: ${snapshot.data[4]}"),
                      ),
                    ),
                  );
                } else
                  return Text("Error");
              }),
          // FutureBuilder(
          //     future: myfuture2,
          //     builder: (BuildContext context, AsyncSnapshot snapshot) {
          //       ConnectionState connectionstate = snapshot.connectionState;
          //       if (connectionstate == ConnectionState.waiting) {
          //         return Text('Getting details');
          //       } else if (snapshot.hasError)
          //         return Text("Error while fetching data");
          //       else if (snapshot.hasData) {
          //         return Column(
          //           children: [
          //             ...snapshot.data.map((element) {
          //               return Card(
          //                 child: ListTile(
          //                   title: Text(element.name),
          //                 ),
          //               );
          //             }).toList(),
          //           ],
          //         );
          //       } else
          //         return Text("Error");
          //     }),

          DropdownButton(
            hint: Text("Select Location Type"),
            value: _locationtype,
            onChanged: (newvalue) {
              setState(() {
                print("NEW DATA");
                _locationtype = newvalue.toString();
                getNearbyPlaces();
              });
            },
            items: locationtypes.map((e) {
              return DropdownMenuItem(
                child: Text(e.toString()),
                value: e.toString(),
              );
            }).toList(),
          ),
          sitelist.length != 0
              ? Expanded(
                  child: ListView.builder(
                    itemCount: sitelist.length,
                    itemBuilder: (context, index) {
                      return GestureDetector(
                        onTap: () {
                          showDialog(
                              context: context,
                              builder: (context) => AlertDialog(
                                    title: Text(sitelist[index].name!),
                                    content: Text(
                                        "FormatAddress : ${sitelist[index].formatAddress}\nCountry : ${sitelist[index].address!.country}\nAdminArea : ${sitelist[index].address!.adminArea}\nSubAdminArea : ${sitelist[index].address!.subAdminArea}\nLocality : ${sitelist[index].address!.locality}\nPostalCode : ${sitelist[index].address!.postalCode}\nLocation : ${sitelist[index].location} "),
                                    actions: [
                                      ElevatedButton(
                                          style: ElevatedButton.styleFrom(
                                              primary: Color(0xff161616)),
                                          onPressed: () {
                                            MapsLauncher.launchCoordinates(
                                                sitelist[index].location!.lat!,
                                                sitelist[index].location!.lng!);
                                          },
                                          child: Text(
                                            "View on Google Maps",
                                            style: TextStyle(
                                                color: Color(0xffFBAA27)),
                                          ))
                                    ],
                                  ));
                        },
                        child: Card(
                          child: ListTile(
                            title: Text(sitelist[index].name!),
                          ),
                        ),
                      );
                    },
                    shrinkWrap: true,
                  ),
                )
              : Text("Fetching Details.."),
        ],
      ),
    );
  }
}
