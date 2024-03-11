import 'package:flutter/material.dart';
import 'package:uuid/uuid.dart';
import 'package:flutter_barbershop/address_search.dart';
import 'package:flutter_barbershop/place_service.dart';
import 'package:flutter_barbershop/place_detail.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter_barbershop/main.dart';

Widget visibility(bool showNearbyPlaces, BuildContext context) {
  return Visibility(
      visible: showNearbyPlaces,
      //child: SingleChildScrollView(
      child: FutureBuilder<List<PlaceResponse>>(
        future: MyHomePageState.fetchNearbyPlaces(lati, longi, context),
        builder: (context, snapshot) =>
            snapshot.connectionState == ConnectionState.waiting
                ? const CircularProgressIndicator()
                : snapshot.hasError
                    ? Text('Error: ${snapshot.error}')
                    : snapshot.hasData
                        ? ListView.builder(
                            physics: NeverScrollableScrollPhysics(),
                            shrinkWrap: true,
                            itemBuilder: (context, index) => PlaceListItem(
                                place: snapshot.data?[index] as PlaceResponse),
                            itemCount: snapshot.data?.length)
                        : const Text("no data found"),
      ));
}

Widget textField(
    BuildContext context,
    TextEditingController _controller,
    String locationText,
    bool showNearbyPlaces,
    customSetState,
    Future<void> Function() callBackFunc,
    Future<void> Function() onTapCallBack) {
  return TextField(
    controller: _controller,
    readOnly: true,
    onTap: () async {
      final sessionToken = const Uuid().v4();
      final result = await showSearch(
        context: context,
        delegate: AddressSearch(sessionToken, callBackFunc: callBackFunc),
      );
      if (result != null) {
        final placeDetails = await PlaceApiProvider(sessionToken)
            .getPlaceDetailFromId(result.placeId);
        lati = placeDetails.latitude;
        longi = placeDetails.longitude;
        obtainedResult = result;
        customSetState(_controller, showNearbyPlaces, obtainedResult);
        await onTapCallBack();
      }
    },
    decoration: InputDecoration(
        filled: true,
        fillColor: Colors.white,
        hintText: locationText,
        hintStyle: const TextStyle(color: Colors.grey, fontSize: 14),
        contentPadding: const EdgeInsets.all(15),
        prefixIcon: Padding(
          padding: const EdgeInsets.all(12),
          child: SvgPicture.asset('assets/icons/Search.svg'),
        ),
        suffixIcon: GestureDetector(
          onTap: () => {Navigator.pushNamed(context, '/filter')},
          child: Container(
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
                  child: SvgPicture.asset('assets/icons/Filter.svg'),
                )
              ],
            )),
          ),
        ),
        border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(15),
            borderSide: BorderSide.none)),
  );
}

Widget placeDetails(place, PlaceDetails? placedetails, BuildContext context) {
  return GestureDetector(
    child: Container(
        child: Padding(
            padding: const EdgeInsets.all(10),
            child:
                Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              const SizedBox(height: 0),
              Text(
                place!.name,
                style:
                    const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 4),
              FutureBuilder<PlaceDetails?>(
                future: PlaceListItem.fetchPlaceDetails(place!.placeId),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    // Handle loading state
                    return CircularProgressIndicator();
                  } else if (snapshot.hasError) {
                    // Handle error state
                    return Text('Error: ${snapshot.error}');
                  } else if (snapshot.hasData) {
                    // Display the retrieved address
                    placedetails = snapshot.data!;
                    List<String> address = placedetails!.address.split(',');

                    bool a;
                    if (placedetails!.openStatus == 'Open') {
                      a = true;
                    }
                    if (placedetails!.openStatus == 'Closed') {
                      a = false;
                    } else {}

                    // String test = NextOpenOrClose(
                    //     placedetails!.periods, a);

                    //removed periods from the call, kept openStatus
                    String test = '';

                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(address[0]),
                        Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              placedetails!.openStatus == 'Open'
                                  ? test == '24 hours'
                                      ? Text(
                                          '${placedetails!.openStatus} $test',
                                          style: openCloseStyle('green'))
                                      : Text(
                                          '${placedetails!.openStatus} - $test',
                                          style: openCloseStyle('green'))
                                  : placedetails!.openStatus == 'Closed'
                                      ? Text(
                                          '${placedetails!.openStatus} - $test',
                                          style: openCloseStyle('red'))
                                      : placedetails!.openStatus ==
                                              'Hours unavailable'
                                          ? Text(' $test',
                                              style: openCloseStyle('green'))
                                          : Text(''),
                              const Spacer(),
                              Text(placedetails!.distance),
                              const SizedBox(width: 20),
                              const Row(
                                  mainAxisAlignment: MainAxisAlignment.end,
                                  children: [
                                    // Text(
                                    //   placedetails!.rating.toString(),
                                    // ),
                                    Text('5.0'),
                                    Icon(Icons.star),
                                  ])
                            ])
                      ],
                    );
                  } else {
                    return const Text('Address and openStatus not available');
                  }
                },
              ),
              const SizedBox(height: 10),
              if (place.photoReference != '')
                Container(
                    width: 400,
                    height: 300,
                    child: ClipRRect(
                        borderRadius: BorderRadius.circular(10),
                        child: Image.network(
                          "https://maps.googleapis.com/maps/api/place/photo?maxwidth=400&photo_reference=${place!.photoReference}&key=AIzaSyBQ_vedKFD899jLzjhkub_2N1oW5udgZOU",
                          fit: BoxFit.cover,
                        ))),
              const SizedBox(height: 30),
              const Divider(thickness: 3),
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
                  openStatus: placedetails!.openStatus,
                  openingHours: placedetails!.openingHours,
                  reviews: placedetails!.reviews,
                  phoneNumber: placedetails!.phoneNumber,
                )),
      );
    }),
  );
}

TextStyle openCloseStyle(String color) {
  if (color == 'green') {
    return const TextStyle(
      fontStyle: FontStyle.italic,
      fontSize: 14,
      color: Colors.green,
    );
  }

  if (color == 'red') {
    return const TextStyle(
      fontStyle: FontStyle.italic,
      fontSize: 14,
      color: Colors.red,
    );
  }
  return const TextStyle(
    fontStyle: FontStyle.italic,
    fontSize: 14,
    color: Colors.black,
  );
}
