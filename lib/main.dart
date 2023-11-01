import 'package:flutter/material.dart';
import 'package:uuid/uuid.dart';
import 'package:flutter_barbershop/address_search.dart';
import 'package:flutter_barbershop/place_service.dart';
import 'package:flutter_barbershop/location.dart';
import 'package:flutter_barbershop/place_detail.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:intl/intl.dart';

void main() {
  runApp(const MyApp());
}

double lati = 0.00;
double longi = 0.00;

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        fontFamily: 'Poppins',
      ),
      home: const Scaffold(
          backgroundColor: Colors.white,
          appBar: null,
          body: const MyHomePage()),
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
  // double lati = 0.00;
  // double longi = 0.00;
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

  Future<void> callBackFunc() async {
    updateLocationText();
    final loc = LocationService();
    Coordinates coord = await loc.getCurrentLocation();
    lati = coord.lat;
    longi = coord.long;

    setState(() {
      showNearbyPlaces = true;
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
    return Stack(
      children: [
        //backgroundColor: Colors.white,
        SingleChildScrollView(
            child: Column(children: <Widget>[
          Container(
            margin: const EdgeInsets.only(left: 10, right: 10, top: 30),
            decoration: BoxDecoration(boxShadow: [
              BoxShadow(
                  color: const Color(0xff1D1617).withOpacity(0.11),
                  blurRadius: 40,
                  spreadRadius: 0.0)
            ]),
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
                      delegate: AddressSearch(sessionToken,
                          callBackFunc: callBackFunc),
                    );
                    if (result != null) {
                      final placeDetails = await PlaceApiProvider(sessionToken)
                          .getPlaceDetailFromId(result.placeId);
                      lati = placeDetails.latitude;
                      longi = placeDetails.longitude;
                      setState(() {
                        _controller.text = result.description;
                        showNearbyPlaces = true;
                      });
                    }
                  },
                  decoration: InputDecoration(
                      filled: true,
                      fillColor: Colors.white,
                      hintText: locationText,
                      hintStyle:
                          const TextStyle(color: Colors.grey, fontSize: 14),
                      contentPadding: const EdgeInsets.all(15),
                      prefixIcon: Padding(
                        padding: const EdgeInsets.all(12),
                        child: SvgPicture.asset('assets/icons/Search.svg'),
                      ),
                      suffixIcon: Container(
                        width: 100,
                        child: IntrinsicHeight(
                            child: Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            const VerticalDivider(
                              color: Colors.black,
                              indent: 10,
                              endIndent: 10,
                              thickness: 0.1,
                            ),
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child:
                                  SvgPicture.asset('assets/icons/Filter.svg'),
                            )
                          ],
                        )),
                      ),
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(15),
                          borderSide: BorderSide.none)),
                ),
                const SizedBox(height: 10),
                ElevatedButton(
                  style:
                      ElevatedButton.styleFrom(backgroundColor: Colors.white),
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
                                          physics:
                                              NeverScrollableScrollPhysics(),
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
        ]))
      ],
    );
  }
}

class PlaceListItem extends StatelessWidget {
  final PlaceResponse? place;
  final String sessionToken;

  PlaceListItem({super.key, required this.place})
      : sessionToken = const Uuid().v4();

  Future<PlaceDetails> fetchPlaceDetails(String p) async {
    final PlaceApi = new PlaceApiProvider(sessionToken);
    PlaceDetails PD = await PlaceApi.getAddress(p, lati, longi);
    return PD;
  }

  String a = '';

  PlaceDetails? placedetails;
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      child: Container(
          //color: Color.fromARGB(255, 196, 195, 185),
          child: Padding(
              padding: const EdgeInsets.all(10),
              child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 0),
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
                          List<String> address =
                              placedetails!.address.split(',');
                          //return Text(placedetails0!.address);
                          placedetails!.openStatus ? a = 'Open' : a = 'Closed';

                          String test = NextOpenOrClose(
                              placedetails!.periods, placedetails!.openStatus);

                          return Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(address[0]),
                              Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    a == 'Open'
                                        ? test == '24 hours'
                                            ? Text('$a $test',
                                                style: const TextStyle(
                                                    fontStyle: FontStyle.italic,
                                                    fontSize: 14,
                                                    color: Colors.green,
                                                    fontFamily: 'Roboto'))
                                            : Text('$a - $test',
                                                style: const TextStyle(
                                                    fontStyle: FontStyle.italic,
                                                    fontSize: 14,
                                                    color: Colors.green,
                                                    fontFamily: 'Roboto'))
                                        : Text('$a - $test',
                                            style: const TextStyle(
                                                fontStyle: FontStyle.italic,
                                                fontSize: 14,
                                                color: Colors.red,
                                                fontFamily: 'Roboto')),
                                    const Spacer(),
                                    Text(placedetails!.distance),
                                    const SizedBox(width: 20),
                                    Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.end,
                                        children: [
                                          Text(
                                            placedetails!.rating.toString(),
                                          ),
                                          Icon(Icons.star),
                                        ])
                                  ])
                            ],
                          );
                        } else {
                          return const Text(
                              'Address and openStatus not available');
                        }
                      },
                    ),
                    const SizedBox(height: 10),
                    Container(
                        width: 400,
                        height: 300,
                        child: ClipRRect(
                            borderRadius: BorderRadius.circular(10),
                            child: Image.network(
                              "https://maps.googleapis.com/maps/api/place/photo?maxwidth=400&photo_reference=${place!.photoReference}&key=AIzaSyC63KBS5ACnWB3BRRlS9-OWX1zLHti7BBg",
                              fit: BoxFit.cover,
                            ))),
                    const SizedBox(height: 30),
                    Divider(thickness: 3),
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
                    photos: placedetails!.photos,
                    openStatus: a,
                    openingHours: placedetails!.openingHours,
                    reviews: placedetails!.reviews,
                  )),
        );
      }),
    );
  }

  String NextOpenOrClose(List<dynamic> list, bool openstatus) {
    final aDateTime = DateTime.now();
    int hour = aDateTime.hour;
    int minute = aDateTime.minute;
    int combinedTime = hour * 100 + minute;

    String day = DateFormat('EEEEE', 'en_US').format(aDateTime);
    int n = 100;

    if (day == "Sunday") {
      n = 0;
    } else if (day == "Monday") {
      n = 1;
    } else if (day == "Tuesday") {
      n = 2;
    } else if (day == "Wednesday") {
      n = 3;
    } else if (day == "Thursday") {
      n = 4;
    } else if (day == "Friday") {
      n = 5;
    } else if (day == "Saturday") {
      n = 6;
    }

    if (!openstatus) {
      bool isItClosed = isItClosedForTheWholeDay(n, list);
      int lengthOfList = list.length;

      if (isItClosed) {
        while (true) {
          n = n + 1;
          if (n >= lengthOfList) {
            n = 0;
          } else {
            n = n;
          }

          bool closedOrNot = isItClosedForTheWholeDay(n, list);
          if (closedOrNot == false) {
            List<String> times = findOpenAndCloseTime(n, list);
            String day = returnsDay(n);
            String formatted_time = formatTime(times[0]);
            return 'Opens $formatted_time $day';
          }
        }
      } else {
        List<String> times = findOpenAndCloseTime(n, list);

        if (combinedTime < int.parse(times[0])) {
          //String day = returnsDay(n);
          String formatted_time = formatTime(times[0]);
          return 'Opens $formatted_time';
        }

        if (combinedTime > int.parse(times[1])) {
          while (true) {
            n = n + 1;
            if (n >= lengthOfList) {
              n = 0;
            } else {
              n = n;
            }
            bool closedOrNot = isItClosedForTheWholeDay(n, list);
            if (closedOrNot == false) {
              String day = returnsDay(n);
              List<String> times = findOpenAndCloseTime(n, list);
              String formatted_time = formatTime(times[0]);

              return 'Opens $formatted_time $day';
            }
          }
        }
      }
    }

    if (openstatus) {
      var times = findOpenAndCloseTime(n, list);
      if (times is List<String>) {
        String formatted_time = formatTime(times[1]);
        return 'Closes $formatted_time';
      }

      if (times is String) {
        return '$times';
      }
    } else {}

    return '';
  }

  bool isItClosedForTheWholeDay(num n, List<dynamic> listi) {
    for (var element in listi) {
      if (n == element['close']['day']) {
        return false;
      }
    }

    return true;
  }

  String returnsDay(int n) {
    switch (n) {
      case 0:
        return 'Sun';
      case 1:
        return 'Mon';
      case 2:
        return 'Tue';
      case 3:
        return 'Wed';
      case 4:
        return 'Thu';
      case 5:
        return 'Fri';
      case 6:
        return 'Sat';
      default:
        return 'Could not convert day';
    }
  }

  dynamic findOpenAndCloseTime(num x, List<dynamic> list) {
    List<String> openAndCloseTime = [];
    for (var element in list) {
      if (element['close'] != null) {
        if (x == element['close']['day']) {
          String openTime = element['open']['time'];
          String closeTime = element['close']['time'];
          openAndCloseTime.add(openTime);
          openAndCloseTime.add(closeTime);
          return openAndCloseTime;
        }
      } else if (element['close'] == null) {
        return '24 hours';
      }
    }
    throw Exception('Could not find');
  }
}

String formatTime(String x) {
  String result = (int.parse(x) / 100).toStringAsFixed(2);
  List<String> hourAndMinutes = result.split('.');
  List<String> hourSplit =
      ((int.parse(hourAndMinutes[0]) / 10).toStringAsFixed(1)).split('.');
  if (hourAndMinutes[1] == "00") {
    if (hourAndMinutes[0] != "00") {
      if (hourSplit[0] == '0') {
        return '${hourSplit[1]} AM';
      }
      if (hourSplit[0] != '0') {
        if (int.parse(hourAndMinutes[0]) < 12) {
          return '${hourAndMinutes[0]} AM';
        }
        if (int.parse(hourAndMinutes[0]) >= 12) {
          if (int.parse(hourAndMinutes[0]) > 12) {
            return '${convertTwentyFourHourToTwelveHour(hourAndMinutes[0])} PM';
          } else if (int.parse(hourAndMinutes[0]) == 12) {
            return '${hourAndMinutes[0]} PM';
          }
        }
      }

      if (hourAndMinutes[0] == '00') {
        return '12 AM';
      }
    }
  }

  if (hourAndMinutes[1] != '00') {
    if (hourAndMinutes[0] != '00') {
      if (hourSplit[0] == '0') {
        return '${hourSplit[1]}:${hourAndMinutes[1]} AM';
      } else if (hourSplit[0] != '0') {
        if (int.parse(hourAndMinutes[0]) < 12) {
          return '${hourAndMinutes[0]}:${hourAndMinutes[1]} AM';
        } else if (int.parse(hourAndMinutes[0]) >= 12) {
          if (int.parse(hourAndMinutes[0]) > 12) {
            return '${convertTwentyFourHourToTwelveHour(hourAndMinutes[0])}:${hourAndMinutes[1]} PM';
          } else if (int.parse(hourAndMinutes[0]) == 12) {
            return '${hourAndMinutes[0]}:${hourAndMinutes[1]} PM';
          }
        }
      }
    } else if (hourAndMinutes[0] == '00') {
      return '12:${hourAndMinutes[1]} AM';
    }
  }
  return '';
}

String convertTwentyFourHourToTwelveHour(String x) {
  int y = int.parse(x) - 12;
  return y.toString();
}
