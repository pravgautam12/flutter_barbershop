import 'package:flutter/material.dart';
import 'package:uuid/uuid.dart';
import 'package:flutter_barbershop/address_search.dart';
import 'package:flutter_barbershop/place_service.dart';
import 'package:flutter_barbershop/location.dart';
import 'package:flutter_barbershop/place_detail.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
          colorScheme: ColorScheme.fromSwatch(
              primarySwatch: Colors.blue,
              backgroundColor: Colors.white,
              accentColor: Colors.white,
              cardColor: Colors.white),
          fontFamily: 'Poppins'),
      home: const MyHomePage(),
    );
  }
}

// class MyHomePage extends StatefulWidget {
//   const MyHomePage({super.key, required this.title});

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});
  //final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final _controller = TextEditingController();
  String locationText = "Enter your location";
  double lati = 0.00;
  double longi = 0.00;
  double placeIdLati = 0.00;
  double placeIdLongi = 0.00;
  bool showNearbyPlaces = false;

  TextEditingController latitudeController = TextEditingController();

  //var coord = Coordinates();

  void updateLocationText() {
    setState(() {
      locationText = "Your location";
    });
  }

  Future<List<PlaceResponse>> fetchNearbyPlaces(
      double latitude, double longitude) async {
    final sessionToken = const Uuid().v4();
    final places = await PlaceApiProvider(sessionToken)
        .getNearbyPlaces(latitude, longitude);
    return places;
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // appBar: AppBar(
      //     //title: Text(widget.title),
      //     //title: const Text('wassup'),
      //     backgroundColor: Colors.white,
      //     elevation: 0.0,),
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
          child: Column(children: <Widget>[
        Container(
          margin: const EdgeInsets.only(left: 10, right: 10, top: 30),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              TextField(
                controller: _controller,
                readOnly: true,
                onTap: () async {
                  final sessionToken = const Uuid().v4();
                  final result = await showSearch(
                    context: context,
                    delegate: AddressSearch(sessionToken),
                  );
                  if (result != null) {
                    final placeDetails = await PlaceApiProvider(sessionToken)
                        .getPlaceDetailFromId(result.placeId);
                    lati = placeDetails.latitude;
                    longi = placeDetails.longitude;
                    // await Future.microtask(() {
                    //   Navigator.push(
                    //     context,
                    //     MaterialPageRoute(
                    //         builder: (context) => NearbyPlacesList(
                    //             latitude: placeIdLati,
                    //             longitude: placeIdLongi)),
                    //   );
                    // });
                    setState(() {
                      _controller.text = result.description;
                      showNearbyPlaces = true;
                    });
                  }
                },
                decoration: InputDecoration(
                  icon: Container(
                    width: 10,
                    height: 10,
                    child: const Icon(
                      Icons.home,
                      color: Colors.black,
                    ),
                  ),
                  hintText: locationText,
                  border: InputBorder.none,
                  contentPadding: const EdgeInsets.only(left: 8.0, top: 16.0),
                ),
              ),
              const SizedBox(height: 10),
              ElevatedButton(
                style: ElevatedButton.styleFrom(backgroundColor: Colors.white),
                onPressed: () async {
                  updateLocationText();
                  final loc = LocationService();
                  Coordinates coord = await loc.getCurrentLocation();
                  lati = coord.lat;
                  longi = coord.long;

                  setState(() {
                    showNearbyPlaces = true;
                  });
                },
                child: const Text("Use your location",
                    style: TextStyle(color: Colors.black)),
              ),
              Visibility(
                  visible: showNearbyPlaces,
                  //child: SingleChildScrollView(
                  child: FutureBuilder<List<PlaceResponse>>(
                    future: fetchNearbyPlaces(lati, longi),
                    builder: (context, snapshot) =>
                        snapshot.connectionState == ConnectionState.waiting
                            ? const CircularProgressIndicator()
                            : snapshot.hasError
                                ? Text('Error: ${snapshot.error}')
                                : snapshot.hasData
                                    ? ListView.builder(
                                        physics: NeverScrollableScrollPhysics(),
                                        shrinkWrap: true,
                                        itemBuilder: (context, index) =>
                                            PlaceListItem(
                                                place: snapshot.data?[index]
                                                    as PlaceResponse),
                                        itemCount: snapshot.data?.length)
                                    : const Text("no data found"),
                  ))
            ],
          ),
        ),
      ])),
    );
  }
}
/////////// NearbyPlacesList Class///////////////

class NearbyPlacesList extends StatefulWidget {
  final double latitude;
  final double longitude;

  const NearbyPlacesList(
      {super.key, required this.latitude, required this.longitude});

  @override
  State<NearbyPlacesList> createState() => _NearbyPlacesListState();
}

class _NearbyPlacesListState extends State<NearbyPlacesList> {
  Future<List<PlaceResponse>>? places;
  final sessionToken = const Uuid().v4();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // appBar: AppBar(
      //   title: const Text('Nearby Places'),
      // ),
      backgroundColor: const Color.fromARGB(255, 155, 141, 32),
      body: FutureBuilder<List<PlaceResponse>>(
          future: PlaceApiProvider(sessionToken)
              .getNearbyPlaces(widget.latitude, widget.longitude),
          builder: (context, snapshot) => snapshot.connectionState ==
                  ConnectionState.waiting
              ? const CircularProgressIndicator()
              : snapshot.hasError
                  ? Text('Error: ${snapshot.error}')
                  : snapshot.hasData
                      ? ListView.builder(
                          itemBuilder: (context, index) => PlaceListItem(
                              place: snapshot.data?[index] as PlaceResponse),
                          itemCount: snapshot.data?.length)
                      : const Text("no data found")),
    );
  }
}

//////////// NearbyPlacesListClass ends //////////////

class PlaceListItem extends StatelessWidget {
  final PlaceResponse? place;
  final String sessionToken;

  PlaceListItem({super.key, required this.place})
      : sessionToken = const Uuid().v4();

  Future<PlaceDetails> fetchPlaceDetails(String p) async {
    final PlaceApi = new PlaceApiProvider(sessionToken);
    PlaceDetails PD = await PlaceApi.getAddress(p);
    return PD;
  }

  PlaceDetails? placedetails;
  @override
  Widget build(BuildContext context) {
    return Card(
        child: GestureDetector(
      child: Container(
          //color: Color.fromARGB(255, 196, 195, 185),
          child: Padding(
              padding: const EdgeInsets.all(0),
              child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 10),
                    Text(
                      place!.name,
                      style: const TextStyle(
                          fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 4),
                    FutureBuilder<PlaceDetails?>(
                      future: fetchPlaceDetails(place!.placeId),
                      builder: (context, snapshot) {
                        if (snapshot.connectionState ==
                            ConnectionState.waiting) {
                          // Handle loading state
                          return CircularProgressIndicator();
                        } else if (snapshot.hasError) {
                          // Handle error state
                          return Text('Error: ${snapshot.error}');
                        } else if (snapshot.hasData) {
                          // Display the retrieved address
                          placedetails = snapshot.data!;
                          return Text(placedetails!.address);
                        } else {
                          return Text('Address not available');
                        }
                      },
                    ),
                    const SizedBox(height: 10),
                    ClipRRect(
                        borderRadius: BorderRadius.circular(10),
                        child: Image.network(
                            "https://maps.googleapis.com/maps/api/place/photo?maxwidth=400&photo_reference=${place!.photoReference}&key=AIzaSyC63KBS5ACnWB3BRRlS9-OWX1zLHti7BBg")),
                    const SizedBox(height: 4),
                  ]))),
      onTap: () async => await Future.microtask(() {
        Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => PlaceDetail(
                  placeId: place!.placeId,
                  name: place!.name,
                  address: placedetails!.address,
                  photo_reference: place!.photoReference,
                  photos: placedetails!.photos)),
        );
      }),
    ));
  }
}
