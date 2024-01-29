
import 'package:flutter/material.dart';
import 'package:flutter_barbershop/providers/miscellaneous_provider.dart';
import 'package:uuid/uuid.dart';
import 'package:flutter_barbershop/place_service.dart';
import 'package:flutter_barbershop/location.dart';
import 'package:flutter_barbershop/home_page_widgets.dart';
import 'package:intl/intl.dart';
import 'package:flutter_barbershop/config/Theme.dart';
import 'package:flutter_barbershop/config/app_router.dart';
import 'package:flutter_barbershop/providers/filter_provider.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(const MyApp());
}

Suggestion obtainedResult = Suggestion('', '');
double lati = 0.00;
double longi = 0.00;

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    //wrapping Material app with this widget to be able to use FilterProvider inside the entire app
    return MultiProvider(
        providers: [
          ChangeNotifierProvider(create: (context) => FilterProvider()),
          ChangeNotifierProvider(create: (context) => MiscellaneousProvider())
        ],
        child: MaterialApp(
          debugShowCheckedModeBanner: false,
          theme: theme(),
          home: Scaffold(body: MyHomePage()),
          onGenerateRoute: AppRouter.onGenerateRoute,
          initialRoute: MyHomePage.routeName,
        ));
  }
}

// class MyHomePage extends StatefulWidget {
//   const MyHomePage({super.key, required this.title});

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});
  static const String routeName = '/';

  static Route route() {
    return MaterialPageRoute(
        builder: (_) => MyHomePage(),
        settings: RouteSettings(name: routeName));
  }

  @override
  State<MyHomePage> createState() => MyHomePageState();
}

class MyHomePageState extends State<MyHomePage> {
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

  static Future<List<PlaceResponse>> fetchNearbyPlaces(
      double latitude, double longitude, BuildContext context) async {
    final sessionToken = const Uuid().v4();
    //final places = await PlaceApiProvider(sessionToken).getNearbyPlaces(latitude, longitude);
    final places = await PlaceApiProvider(sessionToken)
        .getNearbyPlaces(latitude, longitude, context);
    return places;
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  customSetState(TextEditingController c, bool x, Suggestion r) {
    setState(() {
      _controller.text = r.description;
      x = true;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
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
                textField(
                  context,
                  _controller,
                  locationText,
                  showNearbyPlaces,
                  customSetState,
                  callBackFunc,
                ),
                visibility(showNearbyPlaces, context),
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
  static final String sessionToken = const Uuid().v4();

  PlaceListItem({super.key, required this.place});
  //     : sessionToken = const Uuid().v4();

  static Future<PlaceDetails> fetchPlaceDetails(String p) async {
    final PlaceApi = new PlaceApiProvider(sessionToken);
    PlaceDetails PD = await PlaceApi.getAddress(p, lati, longi);
    return PD;
  }

  PlaceDetails? placedetails;
  @override
  Widget build(BuildContext context) {
    return placeDetails(place, placedetails, context);
  }
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