import 'dart:convert';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:smart_grocery_app/home_screen.dart';
import 'package:smart_grocery_app/models/grocery_api.dart';
import 'package:http/http.dart' as http;
import 'package:smart_grocery_app/services/location.dart';

Future<NearbyPlacesResponse> getNearbyGroceryStores(
    Position position, String radius, String apiKey) async {
  var lat = position.latitude;
  var long = position.longitude;
  var url = Uri.parse(
      'https://maps.googleapis.com/maps/api/place/nearbysearch/json?location=$lat,$long&radius=$radius&types=supermarket&key=$apikey');

  var response = await http.post(url);

  return NearbyPlacesResponse.fromJson(jsonDecode(response.body));
}

class GroceryStore extends StatefulWidget {
  const GroceryStore({super.key});

  @override
  State<GroceryStore> createState() => _GroceryStoreState();
}

const String apikey = "enter your api key here";

class _GroceryStoreState extends State<GroceryStore> {
  String radius = "300000";
  double? lat;
  double? long;
  Position? position;
  NearbyPlacesResponse nearbyPlacesResponse = NearbyPlacesResponse();

  void _getLoc() async {
    position = await determinePosition();
    lat = position?.latitude;
    long = position?.longitude;
  }

  void _getGroceryStores() async {
    nearbyPlacesResponse =
        await getNearbyGroceryStores(position!, radius, apikey);
    setState(() {});
  }

  @override
  void initState() {
    super.initState();
    _getLoc();
    _getGroceryStores();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Center(
      child: SingleChildScrollView(
        child: Column(children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: const [
              SizedBox(width: 40),
            ],
          ),
          if (nearbyPlacesResponse.results != null)
            for (int i = 0; i < findlength(nearbyPlacesResponse.results); i++)
              nearbyPlacesWidget(nearbyPlacesResponse.results![i])
        ]),
      ),
    ));
  }

  Widget nearbyPlacesWidget(Results results) {
    return Container(
      width: MediaQuery.of(context).size.width * 0.5,
      margin: const EdgeInsets.only(top: 10, left: 10, right: 10),
      padding: const EdgeInsets.all(5),
      decoration: BoxDecoration(
          border: Border.all(color: Colors.black),
          borderRadius: BorderRadius.circular(10)),
      child: Wrap(
        direction: Axis.horizontal,
        runAlignment: WrapAlignment.center,
        spacing: 20.0,
        children: <Widget>[
          getimg(results.photos),
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                "Name: ${results.name!}",
                textAlign: TextAlign.center,
                style: const TextStyle(fontWeight: FontWeight.bold),
                overflow: TextOverflow.visible,
              ),
              const SizedBox(width: 20),

              // urla(results)

              const SizedBox(height: 25),

              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                      "Distance: ${getDistance(lat!, long!, results.geometry!.location!.lat, results.geometry!.location!.lng)} mi",
                      textAlign: TextAlign.center,
                      overflow: TextOverflow.visible),
                  const Text("mi"),
                  const SizedBox(width: 20),
                  const Text("Status: "),
                  Text(results.openingHours != null ? "Open" : "Closed"),
                  const SizedBox(width: 20),
                  Text(
                    "Rating: ${results.rating!}",
                    overflow: TextOverflow.visible,
                  ),
                ],
              ),

              // const Spacer(),
            ],
          ),
        ],
      ),
    );
  }
}

Image getimg(List<Photos>? photo) {
  String url = "https://maps.googleapis.com/maps/api/place/photo";
  String width = "400";
  String height = "200";
  String? photoReference = photo![0].photoReference;
  String finalurl =
      "$url?maxwidth=$width&maxheight=$height&photoreference=$photoReference&key=$apikey";
  return Image.network(finalurl);
}

// Widget urla(Results results){
//   if(results.website != null){
//     return Text("   website: ${results.website!}");
//   }

//   return Text ("   website");

// }

int findlength(List<Results>? results) {
  int a = 5;
  if (results!.length < 5) {
    a = results.length;
  }

  return a;
}

String getDistance(double lat, double long, double? lat1, double? long1) {
  double totalDistance = 0.0;
  var p = 0.017453292519943295;
  var c = cos;
  var a = 0.5 -
      c((lat1! - lat) * p) / 2 +
      c(lat * p) * c(lat1 * p) * (1 - c((long1! - long) * p)) / 2;
  double distance = 12742 * asin(sqrt(a));
  totalDistance += distance;

  return totalDistance.toStringAsFixed(2);
}
