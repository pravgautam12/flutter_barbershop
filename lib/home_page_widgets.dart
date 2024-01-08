import 'package:flutter/material.dart';
import 'package:uuid/uuid.dart';
import 'package:flutter_barbershop/address_search.dart';
import 'package:flutter_barbershop/place_service.dart';
import 'package:flutter_barbershop/location.dart';
import 'package:flutter_barbershop/place_detail.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:intl/intl.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:flutter_barbershop/main.dart';

Widget visibility(bool showNearbyPlaces, BuildContext context) {
  String plcToken = '';
  //MyHomePageState.fetchPosts(lati, longi);

  //Widget ft = const SizedBox();
  // return Visibility(
  //     visible: showNearbyPlaces,
  //     //child: SingleChildScrollView(
  //     child: Column(children: [
  //       FutureBuilder<PlaceResponse_Token>(
  //         future: MyHomePageState.fetchNearbyPlaces(lati, longi),
  //         builder: (context, snapshot) {
  //           if (snapshot.connectionState == ConnectionState.waiting) {
  //             return const CircularProgressIndicator();
  //           } else if (snapshot.hasError) {
  //             return Text('Error: ${snapshot.error}');
  //           } else if (snapshot.hasData) {
  //             PlaceResponse_Token? placeResponseToken =
  //                 snapshot.data as PlaceResponse_Token?;
  //             plcToken = placeResponseToken!.token;

  //             if (placeResponseToken != null &&
  //                 placeResponseToken.placeResponseList != null) {
  //               List<PlaceResponse> placeList =
  //                   placeResponseToken.placeResponseList;

  //               return Column(children: [
  //                 ListView.builder(
  //                   physics: NeverScrollableScrollPhysics(),
  //                   itemCount: placeList.length,
  //                   shrinkWrap: true,
  //                   itemBuilder: (context, index) {
  //                     return PlaceListItem(place: placeList[index]);
  //                   },
  //                 ),
  //                 if (plcToken != '')
  //                   GestureDetector(
  //                     child: Text('uppy'),
  //                     onTap: () {
  //                       print('GestureDetector tapped');
  //                       ft = loadMoreData(plcToken);
  //                     },
  //                   ),
  //                 ft,
  //               ]);
  //             }
  //           }

  //           return const Text("no data found");
  //         },
  //       ),

  //       // if (plcToken != '')
  //       //   GestureDetector(
  //       //       // child: plcToken != '' ? Text('Load') : Text(''),
  //       //       child: plcToken != '' ? Text('Load') : Text('wassup'),
  //       //       onTap: () {
  //       //         String localToken = plcToken;
  //       //         String message = '';
  //       //         if (localToken != '') {
  //       //           message = 'got a value';
  //       //         } else if (localToken == '') {
  //       //           message = 'no luck';
  //       //         }

  //       //         showDialog(
  //       //             context: context,
  //       //             builder: (BuildContext context) {
  //       //               return AlertDialog(
  //       //                   title: const Text('Result'),
  //       //                   content: Text(message),
  //       //                   actions: [
  //       //                     TextButton(
  //       //                       onPressed: () {
  //       //                         Navigator.of(context).pop();
  //       //                       },
  //       //                       child: const Text('OK'),
  //       //                     )
  //       //                   ]);
  //       //             });
  //       //       })
  //     ]));

  return Visibility(
      visible: showNearbyPlaces,
      child: posts[0].length != 0
          ? ListView.builder(
              itemCount: posts[0].length,
              itemBuilder: (context, index) {
                return PlaceListItem(place: posts[0][index]);
              })
          : Text(''));
}

Widget loadMoreData(String x) {
  return FutureBuilder<PlaceResponse_Token>(
    future: MyHomePageState.fetchNearbyPlaces(lati, longi),
    builder: (context, snapshot) =>
        snapshot.connectionState == ConnectionState.waiting
            ? const CircularProgressIndicator()
            : snapshot.hasError
                ? Text('Error: ${snapshot.error}')
                : snapshot.hasData
                    ? ListView.builder(
                        physics: NeverScrollableScrollPhysics(),
                        itemCount: snapshot.data?.placeResponseList.length ?? 0,
                        shrinkWrap: true,
                        itemBuilder: (context, index) {
                          PlaceResponse_Token? placeResponseToken =
                              snapshot.data as PlaceResponse_Token?;
                          //plcToken = placeResponseToken!.token;
                          if (placeResponseToken != null &&
                              placeResponseToken.placeResponseList != null) {
                            List<PlaceResponse> placeList =
                                placeResponseToken.placeResponseList;
                            return PlaceListItem(place: placeList[index]);
                          }
                        },
                      )
                    : const Text("no data found"),
  );
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
                child: SvgPicture.asset('assets/icons/Filter.svg'),
              )
            ],
          )),
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
