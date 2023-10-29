import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

const apiKey = "AIzaSyC63KBS5ACnWB3BRRlS9-OWX1zLHti7BBg";

class Place {
  // String? streetNumber;
  // String? street;
  // String? city;
  // String? zipCode;

  // Place({
  //   this.streetNumber,
  //   this.street,
  //   this.city,
  //   this.zipCode,

  double latitude;
  double longitude;

  Place(this.latitude, this.longitude);

  // @override
  // String toString() {
  //   return 'Place(streetNumber: $streetNumber, street: $street, city: $city, zipCode: $zipCode)';
  // }
}

class PlaceDetails {
  String address;
  List<String> photos;
  List<String> openingHours;
  bool openStatus;
  double rating;
  List<dynamic> periods;
  List<dynamic> reviews;

  PlaceDetails(this.address, this.photos, this.openingHours, this.openStatus,
      this.rating, this.periods, this.reviews);
}

class PlaceResponse {
  final String name;
  final String placeId;
  final String photoReference;

  PlaceResponse(
    this.name,
    this.placeId,
    this.photoReference,
  );

  @override
  String toString() {
    return 'PlaceResponse(description: $name, placeId: $placeId)';
  }
}

class DistanceMatrix {
  String distance;
  DistanceMatrix(this.distance);
}

class Suggestion {
  final String placeId;
  final String description;

  Suggestion(this.placeId, this.description);

  @override
  String toString() {
    return 'Suggestion(description: $description, placeId: $placeId)';
  }
}

class PlaceApiProvider {
  final client = HttpClient();

  PlaceApiProvider(this.sessionToken);

  final sessionToken;

  static const String androidKey = 'YOUR_API_KEY_HERE';
  static const String iosKey = 'YOUR_API_KEY_HERE';
  //final apiKey = Platform.isAndroid ? androidKey : iosKey;
  final apiKey = "AIzaSyC63KBS5ACnWB3BRRlS9-OWX1zLHti7BBg";

  Future<List<Suggestion>> fetchSuggestions(String input, String lang) async {
    final request =
        'https://maps.googleapis.com/maps/api/place/autocomplete/json?input=$input&types=address&language=$lang&components=country:us&key=$apiKey&sessiontoken=$sessionToken';
    final response = await http.get(Uri.parse(request));
    //Use HttpClient instead of http package for low level functionality, available in flutter documentation.

    if (response.statusCode == 200) {
      final result = json.decode(response.body);
      if (result['status'] == 'OK') {
        // compose suggestions in a list
        return result['predictions']
            .map<Suggestion>((p) => Suggestion(p['place_id'], p['description']))
            .toList();
      }
      if (result['status'] == 'ZERO_RESULTS') {
        return [];
      }
      throw Exception(result['error_message']);
    } else {
      throw Exception('Failed to fetch suggestion');
    }
  }

  Future<Place> getPlaceDetailFromId(String placeId) async {
    final request =
        'https://maps.googleapis.com/maps/api/place/details/json?place_id=$placeId&fields=geometry&key=$apiKey&sessiontoken=$sessionToken';
    final response = await http.get(Uri.parse(request));

    if (response.statusCode == 200) {
      final result = json.decode(response.body);
      if (result['status'] == 'OK') {
        final components = result['result']['geometry'];
        // build result
        final place = Place(0, 0);

        //components.forEach((c) {
        // final List type = c['types'];
        // if (type.contains('street_number')) {
        //   place.latitude = c['long_name'];
        // }
        // if (type.contains('route')) {
        //   place.street = c['long_name'];
        // }
        // if (type.contains('locality')) {
        //   place.city = c['long_name'];
        // }
        // if (type.contains('postal_code')) {
        //   place.zipCode = c['long_name'];
        // }
        place.latitude = components['location']['lat'];
        place.longitude = components['location']['lng'];
        //});
        return place;
      }
      throw Exception(result['error_message']);
    } else {
      throw Exception('Failed to fetch suggestion');
    }
  }

  Future<List<PlaceResponse>> getNearbyPlaces(double l, double g) async {
    const apiKey = "AIzaSyC63KBS5ACnWB3BRRlS9-OWX1zLHti7BBg";

    final request =
        'https://maps.googleapis.com/maps/api/place/nearbysearch/json?keyword=barbershop&location=$l,$g&radius=10000&type=salons&key=$apiKey&sessiontoken=$sessionToken';

    final response = await http.get(Uri.parse(request));

    if (response.statusCode == 200) {
      final result = json.decode(response.body);
      if (result['status'] == 'OK') {
        return result['results']
            .map<PlaceResponse>((p) => PlaceResponse(
                p['name'], p['place_id'], p['photos'][0]['photo_reference']))
            .toList();
      }
      throw Exception(result['error_message']);
    } else {
      throw Exception('Failed to fetch places');
    }
  }

  Future<PlaceDetails> getAddress(String placeId) async {
    final request =
        'https://maps.googleapis.com/maps/api/place/details/json?place_id=$placeId&fields=formatted_address,photos/photo_reference,opening_hours,rating,reviews&key=$apiKey&sessiontoken=$sessionToken';

    final response = await http.get(Uri.parse(request));

    if (response.statusCode == 200) {
      final result = json.decode(response.body);
      if (result['status'] == 'OK') {
        //final address = result['result']['formatted_address'];

        PlaceDetails pd = PlaceDetails('', [], [], false, 0, [], []);

        pd.address = result['result']['formatted_address'];

        final components = result['result']['photos'];
        List<String> pictures = [];

        components.forEach((c) {
          pictures.add(c['photo_reference']);
        });

        pd.photos = pictures;
        pd.openStatus = result['result']['opening_hours']['open_now'];
        List<dynamic> hours = result['result']['opening_hours']['weekday_text'];
        pd.openingHours = hours.map((p) => p.toString()).toList();
        pd.rating = result['result']['rating'].toDouble();
        pd.periods = result['result']['opening_hours']['periods'];

        return pd;
      }
      throw Exception(result['error message']);
    } else {
      throw Exception('Failed to find address');
    }
  }

  Future<DistanceMatrix> getDistanceMatrix(
      String placeId, double latitude, double longitude) async {
    final request =
        'https://maps.googleapis.com/maps/api/distancematrix/json?destinations=place_id:$placeId&origins=$latitude,$longitude&key=$apiKey&sessiontoken=$sessionToken';

    final response = await http.get(Uri.parse(request));

    if (response.statusCode == 200) {
      final result = json.decode(response.body);
      if (result['status'] == 'OK') {
        DistanceMatrix dm = DistanceMatrix('');
        dm.distance = result['rows'][0]['elements'][0]['distance']['text'];
        return dm;
      }
      throw Exception(result['error message']);
    } else {
      throw Exception('could not find distance');
    }
  }
}
