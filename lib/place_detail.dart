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

  const PlaceDetail({
    super.key,
    this.placeId,
    required this.name,
    required this.address,
    required this.photo_reference,
    required this.photos,
    required this.openStatus,
    required this.openingHours,
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
    //TabController _tabController = TabController(length: 2, vsync: this);
    return NestedScrollView(
        headerSliverBuilder: (context, value) {
          return [
            SliverAppBar(
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
                          padding: EdgeInsets.all(4),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const SizedBox(height: 30),
                              Text(
                                widget.name,
                                style: const TextStyle(
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.black,
                                    fontFamily: 'Poppins',
                                    decoration: TextDecoration.none),
                              ),
                              Text(
                                widget.address,
                                style: const TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.normal,
                                    color: Colors.black,
                                    fontFamily: 'Poppins',
                                    decoration: TextDecoration.none),
                              ),
                              widget.openStatus == 'Open now'
                                  ? Text(
                                      widget.openStatus,
                                      style: const TextStyle(
                                          fontStyle: FontStyle.italic,
                                          color: Colors.green),
                                    )
                                  : Text(
                                      widget.openStatus,
                                      style: const TextStyle(
                                          fontStyle: FontStyle.italic,
                                          color: Colors.red),
                                    ),
                              const SizedBox(height: 10),
                              ClipRRect(
                                  borderRadius: BorderRadius.circular(10),
                                  child: Image.network(
                                      "https://maps.googleapis.com/maps/api/place/photo?maxwidth=400&photo_reference=${widget.photo_reference}&key=AIzaSyC63KBS5ACnWB3BRRlS9-OWX1zLHti7BBg")),
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
                padding: EdgeInsets.all(4),
                child: Material(
                    //child: Column(
                    //crossAxisAlignment: CrossAxisAlignment.start,
                    //children: <Widget>[
                    //Text(widget.openStatus, style: commonTextStyle()),

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

            const Text('wassup',
                style: TextStyle(color: Colors.white, fontSize: 50)),
            //const Text('photos'),
            Container(
                color: Colors.white,
                child: GridView.builder(
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2),
                  itemCount: widget.photos.length,
                  itemBuilder: (BuildContext context, int index) {
                    return Padding(
                      padding: const EdgeInsets.all(1.0),
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
                ))
          ],
        ));
  }
}





// ListView.builder(
//                                             itemCount:
//                                                 widget.openingHours.length,
//                                             itemBuilder: (BuildContext context,
//                                                 int index) {
//                                               return Text(
//                                                   widget.openingHours[index]);
//                                             })