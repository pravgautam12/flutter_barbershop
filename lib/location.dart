import 'dart:async';
//import 'dart:ffi';

import 'package:location/location.dart';

class Coordinates {
  double lat;
  double long;

  Coordinates({required this.lat, required this.long});
}

class LocationService {
  StreamController<Coordinates> _locationController =
      StreamController<Coordinates>();
  //Location location = Location();
  bool serviceEnabled = false;
  PermissionStatus permissionGranted = PermissionStatus.denied;
  LocationData? locationData;
  Location location = Location();

  Future<Coordinates> getCurrentLocation() async {
    Coordinates coordinates = Coordinates(lat: 0, long: 0);
    // bool serviceEnabled;
    // PermissionStatus permissionGranted;
    // LocationData locationData;

    await checkServiceAndPermissionStatus();

    var locationData = await location.getLocation();
    coordinates.lat = locationData.latitude as double;
    coordinates.long = locationData.longitude as double;
    return coordinates;
  }

  Future<void> checkServiceAndPermissionStatus() async {
    try {
      serviceEnabled = await location.serviceEnabled();
      if (serviceEnabled == false) {
        serviceEnabled = await location.requestService();
        if (serviceEnabled == false) {
          return;
        }
      }
    } catch (ex) {
      print(ex);
    }

    try {
      permissionGranted = await location.hasPermission();
    } catch (ex) {
      print(ex);
    }

    try {
      if (permissionGranted == PermissionStatus.denied) {
        permissionGranted = await location.requestPermission();
        if (permissionGranted != PermissionStatus.granted) {
          return;
        }
      }
    } catch (ex) {
      print(ex);
    }
  }

  // LocationService() {
  //   checkServiceAndPermissionStatus();
  //   location.onLocationChanged.listen((LocationData currentLocation) {
  //     if (currentLocation != null) {
  //       _locationController.add(Coordinates(
  //         lat: currentLocation.latitude as double,
  //         long: currentLocation.longitude as double,
  //       ));
  //     }
  //   });
  // }
}
