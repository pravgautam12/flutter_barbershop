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

  const PlaceDetail({
    super.key,
    this.placeId,
    required this.name,
    required this.address,
    required this.photo_reference,
    required this.photos,
  });

  static bool inner = true;
  @override
  State<PlaceDetail> createState() => _PlaceDetailPageState();
}

class _PlaceDetailPageState extends State<PlaceDetail>
    with TickerProviderStateMixin {
  late TabController _tabController;

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

  // @override
  // Widget build(BuildContext context) {
  //   //TabController _tabController = TabController(length: 2, vsync: this);
  //   return Scaffold(
  //       body: Container(
  //           //color: Colors.white,
  //           child: Padding(
  //               padding: const EdgeInsets.all(10),
  //               child: Column(
  //                   crossAxisAlignment: CrossAxisAlignment.start,
  //                   children: [
  //                     const SizedBox(height: 30),
  //                     Text(
  //                       widget.name,
  //                       style: const TextStyle(
  //                           fontSize: 20,
  //                           fontWeight: FontWeight.bold,
  //                           color: Colors.black,
  //                           fontFamily: 'Poppins',
  //                           decoration: TextDecoration.none),
  //                     ),
  //                     const SizedBox(height: 0),
  //                     Text(
  //                       widget.address,
  //                       style: const TextStyle(
  //                           fontSize: 16,
  //                           fontWeight: FontWeight.normal,
  //                           color: Colors.black,
  //                           fontFamily: 'Poppins',
  //                           decoration: TextDecoration.none),
  //                     ),
  //                     const SizedBox(height: 10),
  //                     ClipRRect(
  //                         borderRadius: BorderRadius.circular(10),
  //                         child: Image.network(
  //                             "https://maps.googleapis.com/maps/api/place/photo?maxwidth=400&photo_reference=${widget.photo_reference}&key=AIzaSyC63KBS5ACnWB3BRRlS9-OWX1zLHti7BBg")),
  //                     const SizedBox(height: 10),
  //                     Container(
  //                         color: Color.fromARGB(255, 236, 228, 228),
  //                         child: TabBar(
  //                           controller: _tabController,
  //                           tabs: const [
  //                             Tab(text: 'Overview'),
  //                             Tab(text: 'Reviews'),
  //                             Tab(text: 'Photos'),
  //                           ],
  //                           labelColor: Colors.black,
  //                           //unselectedLabelColor: Colors.grey,
  //                           //indicator: BoxDecoration(color: Colors.grey),
  //                         )),
  //                     Expanded(
  //                         child: SingleChildScrollView(
  //                             child: Container(
  //                                 width: double.maxFinite,
  //                                 height: 300,
  //                                 child: TabBarView(
  //                                   controller: _tabController,
  //                                   children: [
  //                                     const Text("Overview"),

  //                                     const Text('wassup',
  //                                         style: TextStyle(
  //                                             color: Colors.black,
  //                                             fontSize: 50)),

  //                                     //Text("Photos"),

  //                                     GridView.builder(
  //                                       gridDelegate:
  //                                           const SliverGridDelegateWithFixedCrossAxisCount(
  //                                               crossAxisCount: 2),
  //                                       itemCount: widget.photos.length,
  //                                       itemBuilder:
  //                                           (BuildContext context, int index) {
  //                                         return Padding(
  //                                           padding: const EdgeInsets.all(1.0),
  //                                           child: ClipRRect(
  //                                               borderRadius:
  //                                                   BorderRadius.circular(7),
  //                                               child: Image.network(
  //                                                 "https://maps.googleapis.com/maps/api/place/photo?maxwidth=400&photo_reference=${widget.photos[index]}&key=AIzaSyC63KBS5ACnWB3BRRlS9-OWX1zLHti7BBg",
  //                                                 fit: BoxFit.cover,
  //                                                 //centerSlice: Rect.,
  //                                               )),
  //                                           // onTap: () =>
  //                                           //     "https://maps.googleapis.com/maps/api/place/photo?maxwidth=400&photo_reference=${widget.photos[index]}&key=AIzaSyC63KBS5ACnWB3BRRlS9-OWX1zLHti7BBg",
  //                                         );
  //                                       },
  //                                     )
  //                                   ],
  //                                 ))))
  //                   ]))));
  // }

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
        body: //Container(
            //     child: SingleChildScrollView(
            //         child: Container(
            //             width: double.maxFinite,
            //             height: 300,
            TabBarView(
          controller: _tabController,
          children: [
            const Text("Overview"),
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
