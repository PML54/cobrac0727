import 'package:cobrac/pmltools.dart';
import 'package:flutter/material.dart';
import 'dart:async';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class DetailBroc extends StatefulWidget {
  @override
  _DetailBrocState createState() => _DetailBrocState();
}

class _DetailBrocState extends State<DetailBroc> {
  // Génerer dans google sheets
  String thatbrocType = "";
  String thatbrocLocality = "";
  String thatbrocPostal = "";
  String thatbrocStreet = "";
  double thatbrocLatitude = 0.0;
  double thatbrocLongitude = 0.0;
  String thatbrocEventStatus = "";
  String thatbrocOrganizer = "";
  String thatbrocStartDate = "";
  String thatbrocEndDate = "";
  String thatbrocDescription = "";
  String thatbrocNbExposants = "";
  int thatbrocDistance = 0;
  Color thatColor = Colors.green;

  // A recupérer
  double altitude = 0.0;
  double superficie = 0.0;
  double population = 0.0;
  int codeDepartement = 0;
  int codeRegion = 0;
  int thatRevenu = 0;
  int masterBroc = 0;
  int nbPassage = 0;
  late ManageCobrac manageCobrac;
  late Brocabrac thatBrocante;
  List<Brocabrac> allBrocante = [];
  Color colorBrocor = Colors.grey;

  // Map Needs
  Completer<GoogleMapController> _controller = Completer();
  late GoogleMapController mapController;

  late GoToMarket mapTripSingle;

  void readActiveRecord() {
    setState(() {
      thatbrocType = thatBrocante.brocType;
      thatbrocLocality = thatBrocante.brocLocality;
      thatbrocPostal = thatBrocante.brocPostal;
      thatbrocStreet = thatBrocante.brocStreet;
      thatbrocLatitude = thatBrocante.brocLatitude;
      thatbrocLongitude = thatBrocante.brocLongitude;
      thatbrocEventStatus = thatBrocante.brocEventStatus;
      thatbrocOrganizer = thatBrocante.brocOrganizer;
      thatbrocStartDate = thatBrocante.brocStartDate;
      thatbrocEndDate = thatBrocante.brocEndDate;
      thatbrocDescription = thatBrocante.brocDescription;
      thatbrocNbExposants = thatBrocante.brocNbExposants;
      thatbrocDistance = thatBrocante.brocFromCenter;
      thatRevenu = thatBrocante.revenu;
      thatColor = Colors.green;
      if (thatbrocEventStatus == "KO") {
        thatColor = Colors.red;
        thatbrocEventStatus = "Brocante Annulée!!";
      } else
        thatbrocEventStatus = "";
    });
  }

  bool getPrevRecord() {
    if (masterBroc <= 1) return false;
    setState(() {
      masterBroc = masterBroc - 1;

      thatBrocante = allBrocante[masterBroc - 1];
      readActiveRecord();
    });
    return (true);
  }

  bool getNextRecord() {

    print ("masterBroc =" +masterBroc.toString()+ "allBrocante.length =  "+allBrocante.length.toString());
    if (masterBroc +1  > allBrocante.length) return false;
    setState(() {
      masterBroc = masterBroc + 1;

      thatBrocante = allBrocante[masterBroc - 1];
      readActiveRecord();
    });
    return (true);
  }

  GoToMarket setSingleMarker() {
    // Marker  A remettre  A jour
    var _markerOrdre = thatBrocante.brocFromCenter.toString() +
        "km  : " +
        thatBrocante.brocLocality;
    List<Marker> allMarkers = [];

    allMarkers.add(Marker(
      markerId: MarkerId(thatBrocante.brocNbExposants),
      draggable: false,
      infoWindow:
          InfoWindow(title: _markerOrdre, snippet: thatBrocante.brocStreet),
      onTap: () {},
      position: LatLng(thatBrocante.brocLatitude, thatBrocante.brocLongitude),
    ));

// TODO a mettre ailleurs
    double latitudeLarris = 49.034463;
    double longitudeLarris = 2.090107;

    GoToMarket _mapTrip =
        GoToMarket(1, allMarkers, latitudeLarris, longitudeLarris);
    setState(() {
      _mapTrip.centerLatitude = thatBrocante.brocLatitude;
      _mapTrip.centerLongitude = thatBrocante.brocLongitude;
      _mapTrip.tripNbStep = 1;
      // print("_mapTrip.centerLongitude" + _mapTrip.centerLongitude.toString());
    });
    return (_mapTrip);
  }

  @override
  Widget build(BuildContext context) {
    print("Rebuilding  _DetailBrocState");
    if (nbPassage == 0) {
    //PML


      var arguments = ModalRoute.of(context)?.settings.arguments;
      if (arguments is ManageCobrac) {
        manageCobrac = arguments;
      } else {
        // Traiter le cas où les arguments sont null ou d'un type incorrect.
        // Vous pouvez attribuer une valeur par défaut ou prendre une autre action en conséquence.
      }
      // manageCobrac = ModalRoute.of(context)!.settings.arguments;




      allBrocante = manageCobrac.brocanteBrocabrac;
      thatBrocante = manageCobrac.brocabrac;
      nbPassage = 1;
      masterBroc = thatBrocante.brocMaster;
    } else {
      thatBrocante = allBrocante[masterBroc];
    }
    readActiveRecord();
    setState(() {
      mapTripSingle = setSingleMarker();
      print(" REBUILDING MAP _DetailBrocState " +
          mapTripSingle.centerLatitude.toString());
    });
//***********
    GoogleMap animateMapBroc(GoToMarket mapTripSingle) {
      LatLng centered =
          LatLng(mapTripSingle.centerLatitude, mapTripSingle.centerLongitude);
      double zoomPml = 8.0;
      print(" REBUILDING MAP in _SingleMapState = " +
          mapTripSingle.centerLatitude.toString());

      return (GoogleMap(
        zoomGesturesEnabled: true,
        myLocationEnabled: false,
        markers: Set.from(mapTripSingle.tripMarkers),
        initialCameraPosition: CameraPosition(
          target: centered,
          zoom: zoomPml,
        ),
        tiltGesturesEnabled: true,
        onCameraMove: (CameraPosition cameraPosition) {
          // mapController.moveCamera(CameraUpdate.newLatLng(centered));
        },
        onMapCreated: (GoogleMapController controller) {
          _controller.complete(controller);
        },
      ));
    }

    //*********************
    return Scaffold(
        appBar:  AppBar(actions: <Widget>[
        Center(
          child: Text(
            thatbrocDistance.toString() + " km " + thatbrocLocality,
            style: TextStyle(color: Colors.black, fontSize: 12),
          ),
        ),

        IconButton(
            icon: const Icon(Icons.arrow_upward),
            iconSize: 25,
            color: Colors.red,
            tooltip: 'brocabrac',
            onPressed: () {
              bool answer = getPrevRecord();
              if (answer == true) {
                readActiveRecord();
                setState(() {
                  mapTripSingle = setSingleMarker();
                });
              }}),
        IconButton(
            icon: const Icon(Icons.arrow_downward),
            iconSize: 25,
            color: Colors.red,
            tooltip: 'brocabrac',
            onPressed: () {
              bool answer = getNextRecord();
if (answer == true) {
  readActiveRecord();
  setState(() {
    mapTripSingle = setSingleMarker();
    print(" -->REBUILDING  ICON  " +
        mapTripSingle.centerLatitude.toString());
  });
} }),
        //
      ]),
      body: SafeArea(
        child: Column(
          children: <Widget>[
            Row(children: <Widget>[
              RichText(
                  text: TextSpan(
                      style: TextStyle(color: thatColor, fontSize: 15),
                      text: thatbrocPostal +
                          "  " +
                          thatbrocLocality +
                          " " +
                          thatbrocEventStatus)),
            ]),
            Row(children: <Widget>[
              RichText(
                  text: TextSpan(
                      style: TextStyle(color: Colors.black, fontSize: 13),
                      text: thatbrocStreet)),
            ]),
            Row(children: <Widget>[
              RichText(
                  text: TextSpan(
                      style: TextStyle(color: Colors.black, fontSize: 12),
                      text: thatbrocNbExposants + " Exposants")),
            ]),
            Row(children: <Widget>[
              RichText(
                  text: TextSpan(
                      style: TextStyle(color: Colors.black, fontSize: 12),
                      text: "Revenu Moyen = " + thatRevenu.toString() + "€")),
            ]),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: RichText(
                    text: TextSpan(
                        style: TextStyle(color: Colors.black, fontSize: 13),
                        text: thatbrocDescription)),
              ),
            ),
            Expanded(child: animateMapBroc(mapTripSingle))
          ],
        ),
      ),
    );
  }
}
