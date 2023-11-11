//import 'dart:html';

import 'package:flutter/material.dart';
import 'package:uuid/uuid.dart';
import 'package:flutter_barbershop/address_search.dart';
import 'package:flutter_barbershop/place_service.dart';
import 'package:flutter_barbershop/location.dart';
import 'package:flutter_barbershop/main.dart';
import 'package:flutter_barbershop/models/constants.dart';

class PlaceDetail extends StatefulWidget {
  final String? placeId;
  final String name;
  final String address;
  final String photo_reference;
  final List<String> photos;
  final String openStatus;
  final List<String> openingHours;
  final List<dynamic> reviews;

  const PlaceDetail({
    super.key,
    this.placeId,
    this.name = '',
    this.address = '',
    this.photo_reference = '',
    this.photos = const [''],
    this.openStatus = '',
    this.openingHours = const [''],
    this.reviews = const [],
  });

  static bool inner = true;
  @override
  State<PlaceDetail> createState() => _PlaceDetailPageState();
}

class _PlaceDetailPageState extends State<PlaceDetail>
    with TickerProviderStateMixin {
  late TabController _tabController;
  //bool _customTileExpanded = false;
  final ExpansionTileController controller = ExpansionTileController();

  @override
  void initState() {
    _tabController = TabController(length: 3, vsync: this);
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
    _tabController.dispose();
  }

  TextStyle commonTextStyle() {
    return TextStyle(
        fontSize: 16,
        fontWeight: FontWeight.normal,
        color: Colors.black,
        fontFamily: 'Roboto',
        decoration: TextDecoration.none);
  }

  @override
  Widget build(BuildContext context) {
    return NestedScrollView(
        headerSliverBuilder: (context, value) {
          return [
            SliverAppBar(
                leading: GestureDetector(
                    onTap: () {
                      Navigator.of(context).pop();
                    },
                    child: const Padding(
                        padding: EdgeInsets.fromLTRB(0, 10, 10, 10),
                        child: Icon(color: Colors.blue, Icons.arrow_back_ios))),
                pinned: true,
                //snap: true,
                floating: true,
                expandedHeight: 500,
                flexibleSpace: FlexibleSpaceBar(
                  collapseMode: CollapseMode.pin,
                  background: Container(
                      height: 80,
                      color: Colors.white,
                      child: Padding(
                          padding: EdgeInsets.all(10),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const SizedBox(height: 70),
                              Text(
                                widget.name,
                                style: const TextStyle(
                                    fontSize: 14,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.black,
                                    fontFamily: 'Poppins',
                                    decoration: TextDecoration.none),
                              ),
                              Divider(thickness: 3),
                              Text(
                                widget.address,
                                style: const TextStyle(
                                    fontSize: 12,
                                    fontWeight: FontWeight.normal,
                                    color: Colors.black,
                                    fontFamily: 'Poppins',
                                    decoration: TextDecoration.none),
                              ),
                              Divider(thickness: 3),
                              widget.openStatus == 'Open now'
                                  ? Text(
                                      widget.openStatus,
                                      style: const TextStyle(
                                          fontStyle: FontStyle.italic,
                                          fontSize: 12,
                                          color: Colors.green),
                                    )
                                  : Text(
                                      widget.openStatus,
                                      style: const TextStyle(
                                          fontStyle: FontStyle.italic,
                                          fontSize: 12,
                                          color: Colors.red),
                                    ),
                              const SizedBox(height: 5),
                              Container(
                                  width: 400,
                                  height: 300,
                                  child: ClipRRect(
                                      borderRadius: BorderRadius.circular(10),
                                      child: Image.network(
                                          "https://maps.googleapis.com/maps/api/place/photo?maxwidth=400&photo_reference=${widget.photo_reference}&key=AIzaSyC63KBS5ACnWB3BRRlS9-OWX1zLHti7BBg",
                                          fit: BoxFit.cover))),
                            ],
                          ))),
                ),
                bottom: TabBar(
                  controller: _tabController,
                  tabs: [
                    Tab(text: 'Overview'),
                    Tab(text: 'Reviews'),
                    Tab(text: 'Photos'),
                  ],
                  labelColor: Colors.black,
                ))
          ];
        },
        body: TabBarView(
          controller: _tabController,
          children: [
            Container(
              color: Colors.white,
              child: Padding(
                padding: EdgeInsets.all(0),
                child: Material(
                    child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      ExpansionTile(
                        controller: controller,
                        title: const Text('Hours of operation'),
                        subtitle: const Text('Hours may vary'),
                        children: <Widget>[
                          SingleChildScrollView(
                              child: MediaQuery.removePadding(
                                  context: context,
                                  removeTop: true,
                                  child: ListView.builder(
                                      shrinkWrap: true,
                                      itemCount: widget.openingHours.length,
                                      physics:
                                          const NeverScrollableScrollPhysics(),
                                      itemBuilder:
                                          (BuildContext context, int index) {
                                        final openingHour =
                                            widget.openingHours[index];
                                        final parts = openingHour.split(':');

                                        if (parts.length == 4) {
                                          final day = parts[0];
                                          final time = [
                                            parts[1],
                                            parts[2],
                                            parts[3]
                                          ].join(':');

                                          return Padding(
                                              padding:
                                                  const EdgeInsets.fromLTRB(
                                                      15, 0, 15, 0),
                                              child: Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment
                                                          .spaceBetween,
                                                  children: [
                                                    Text(day),
                                                    SizedBox(width: 5),
                                                    Text(time),
                                                  ])
                                              // Text(
                                              //     widget.openingHours[index])

                                              );
                                        }

                                        if (parts.length == 2) {
                                          final day = parts[0];
                                          final time = parts[1];
                                          return Padding(
                                              padding:
                                                  const EdgeInsets.fromLTRB(
                                                      15, 0, 15, 0),
                                              child: Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment
                                                          .spaceBetween,
                                                  children: [
                                                    Text(day),
                                                    SizedBox(width: 5),
                                                    Text(time),
                                                  ]));
                                        } else {
                                          return Text(
                                              widget.openingHours[index]);
                                        }
                                      }))),
                          const SizedBox(height: 10)
                        ],
                      ),
                      const SizedBox(height: 10),
                      //Text('wassup'),
                    ],
                  ),
                )),
              ),
            ),

            Container(
                color: Colors.white,
                child: ListView.builder(
                  itemCount: widget.reviews.length,
                  itemBuilder: (context, index) => Container(
                    child: Padding(
                        padding: EdgeInsets.all(10),
                        child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                  '${widget.reviews[index]['author_name'] ?? 'N/A'}',
                                  textAlign: TextAlign.left,
                                  style: const TextStyle(
                                      decoration: TextDecoration.none,
                                      color: Colors.black,
                                      fontSize: 14,
                                      fontStyle: FontStyle.normal,
                                      fontWeight: FontWeight.bold,
                                      fontFamily: 'Poppins')),
                              Row(children: [
                                Text(
                                  '${widget.reviews[index]['rating']}',
                                  style: ReviewTextStyle(),
                                ),
                                ...List.generate(5, (i) {
                                  return Icon(
                                    i < widget.reviews[index]['rating']
                                        ? Icons.star
                                        : Icons.star_border,
                                    color: Color.fromARGB(255, 255, 230, 9),
                                  );
                                }),
                                const SizedBox(width: 10),
                                Text(
                                    '${widget.reviews[index]['relative_time_description']}',
                                    style: const TextStyle(
                                        decoration: TextDecoration.none,
                                        color: Colors.black,
                                        fontSize: 12,
                                        fontStyle: FontStyle.normal,
                                        fontWeight: FontWeight.normal,
                                        fontFamily: 'Poppins')),
                              ]),
                              Text(
                                '${widget.reviews[index]['text']}',
                                style: const TextStyle(
                                    decoration: TextDecoration.none,
                                    color: Colors.black,
                                    fontSize: 14,
                                    fontStyle: FontStyle.normal,
                                    fontWeight: FontWeight.normal,
                                    fontFamily: 'Poppins'),
                              ),
                            ])),
                  ),
                )),
            //const Text('photos'),
            Container(
                color: Colors.white,
                child: MediaQuery.removePadding(
                    context: context,
                    removeTop: true,
                    child: GridView.builder(
                      gridDelegate:
                          const SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: 2),
                      itemCount: widget.photos.length,
                      itemBuilder: (BuildContext context, int index) {
                        return Padding(
                          padding: const EdgeInsets.fromLTRB(1, 0, 1, 1),
                          child: ClipRRect(
                              borderRadius: BorderRadius.circular(7),
                              child: Image.network(
                                "https://maps.googleapis.com/maps/api/place/photo?maxwidth=400&photo_reference=${widget.photos[index]}&key=AIzaSyC63KBS5ACnWB3BRRlS9-OWX1zLHti7BBg",
                                fit: BoxFit.cover,
                                //centerSlice: Rect.,
                              )),
                          // onTap: () =>
                          //     "https://maps.googleapis.com/maps/api/place/photo?maxwidth=400&photo_reference=${widget.photos[index]}&key=AIzaSyC63KBS5ACnWB3BRRlS9-OWX1zLHti7BBg",
                        );
                      },
                    )))
          ],
        ));
  }

  TextStyle ReviewTextStyle() {
    return const TextStyle(
        decoration: TextDecoration.none,
        color: Colors.black,
        fontSize: 14,
        fontStyle: FontStyle.normal,
        fontWeight: FontWeight.normal,
        fontFamily: 'Poppins');
  }
}
