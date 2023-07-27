import 'dart:async';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:cobrac/pmltools.dart';
class ContactMap extends StatefulWidget {
  @override
  _ContactMapState createState() => _ContactMapState();
}

class _ContactMapState extends State<ContactMap> {
  Completer<GoogleMapController> _controller = Completer();
  late GoogleMapController mapController;


  //BitmapDescriptor pinLocationIcon;
  List<Marker> allMarkers = [];
  LatLng centered = LatLng(44.033333, 4.066667);
  double zoomPml = 8.0;

  //@override
  void initState() {
    // BitmapDescriptor.fromAssetImage(ImageConfiguration(devicePixelRatio: 2.5),
    //         'assets/destination_map_marker.png')
    //     .then((onValue) {
    //   pinLocationIcon = onValue;
    // });
    super.initState(); // ???
  }



  @override
  Widget build(BuildContext context) {
    ManageCobrac? manageCobrac = ModalRoute.of(context)!.settings.arguments as ManageCobrac?;
    GoToMarket obj = manageCobrac!.goToMarket;

    allMarkers = obj.tripMarkers;
    centered = LatLng(obj.centerLatitude, obj.centerLongitude);
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        appBar: AppBar(actions: <Widget>[
          IconButton(
            icon: const Icon(Icons.arrow_back),
            color: Colors.redAccent,
            iconSize: 30.0,
            tooltip: 'Home',
            onPressed: () {
              Navigator.pop(context);
            },
          ),

        ]),
        body: SafeArea(
          child: GoogleMap(
              zoomGesturesEnabled: true,
              myLocationEnabled: true,
              markers: Set.from(allMarkers),
              initialCameraPosition: CameraPosition(
                target: centered,
                zoom: zoomPml,
              ),
              tiltGesturesEnabled: true,
              onCameraMove: (CameraPosition cameraPosition) {},
              onMapCreated: (GoogleMapController controller) {
                _controller.complete(controller);
              }),
        ),
      ),
    );
  }
}
