// 21  Octobre  bra
// 21  Octobre Acces Historique
import 'dart:async';
import 'dart:math';

import 'package:cobrac/brocatrip.dart';
import 'package:cobrac/communestchinos.dart';
import 'package:cobrac/detailedBrocante.dart';
import 'package:cobrac/diverspml.dart' show jours, mois;
import 'package:cobrac/histeric.dart' show Histeric;
import 'package:cobrac/historibroc.dart' show Historic, listHistoric;
import 'package:cobrac/mapcobrac.dart';
import 'package:cobrac/networking.dart' show NetworkHelper;
import 'package:cobrac/pmltools.dart' show Brocabrac, GoToMarket, ManageCobrac;
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:intl/intl.dart';

import 'datate.dart' show ConfigBrocante;

class GeoUtils {
  static double distanceInKmBetweenEarthCoordinates(lat1, lon1, lat2, lon2) {
    var earthRadiusKm = 6371;
    var dLat = _degreesToRadians(lat2 - lat1);
    var dLon = _degreesToRadians(lon2 - lon1);
    lat1 = _degreesToRadians(lat1);
    lat2 = _degreesToRadians(lat2);
    var a = sin(dLat / 2) * sin(dLat / 2) +
        sin(dLon / 2) * sin(dLon / 2) * cos(lat1) * cos(lat2);
    var c = 2 * atan2(sqrt(a), sqrt(1 - a));
    return earthRadiusKm * c;
  }

  static double _degreesToRadians(degrees) {
    return degrees * pi / 180;
  }
}

class ManagerPML extends StatefulWidget {
  static const String id = 'managerpml';

  @override
  _ManagerPMLState createState() => _ManagerPMLState();
}

class _ManagerPMLState extends State<ManagerPML> {
  var versionNum = '27 Juillet 05:00';
  var pifoMetre = 1.27;
  int nbStepAsync = 0; // Eviter de Boucler
  String dateSelected = "2023-07-07";
  String dateSelectedPrev = "2023-07-07";
  String debutHttps = "https://brocabrac.fr/recherche?ou=";
  String finHttps = "&c=bro,vgr,bra&d= ";

  //bra,bro,mal,vgr,vma
  String dateKey = "2025-05-04";
  String dimancheInitial = "2023-03-01";
  String jourActif = "2023-03-01";
  late DateTime nowInit;
  late DateTime nowActif;

  DateTime actifPeanuts = DateTime(2023, 07, 26);
  var secureHistory = 1;

  DateTime brocabracDate = DateTime(2023, 07, 26);
  List<Brocabrac> brocanteBrocabrac = [];
  List<Brocabrac> brocanteBrocabracBis = [];
  double latitudeRef = 0.0;
  double longitudeRef = 0.0;
  double latitudeSelect = 49.20;
  double longitudeSelect = 1.43;
  double latitudeLarris = 49.05;
  double longitudeLarris = 2.1;
  double latitudeMorvan = 47.077;
  double longitudeMorvan = 3.888;

  double rayonBarycentre = 20.0;
  double latitudePortbail = 49.333;
  double longitudePortbail = -1.7;
  Color colorKO = Colors.red;
  Color colorOK = Colors.green;
  Color colorVVF = Colors.grey;
  Color colorMORV = Colors.grey;
  Color colorLAR = Colors.grey;
  Color colorBROC = Colors.grey;
  Color colorMAISON = Colors.grey;

  //e Portbail est 49.3333 et la longitude de la ville de Portbail est -1.7.
//49°20'02.4"N 1°43'33.6"W
  final cobracIconSize = 25.0;
  int nbBrocabrac = 0;
  int nbBrocOK = 0;
  int maxStepAsync = 6; //  A MODIFIER SSi on laance plus dBe 3 requetes Http
  List fullMaster = [];
  List<Color> colorBrocante = [];
  int nbContactReduce = 0;
  var centralCommune = "";
  var centralCompany = "";
  late GoToMarket mapTrip;

  //List<int> MonCoin = [27, 77, 95, 60, 78, 92, 91, 93, 94, 76];
  List<int> MonCoin = [50, 14, 35, 61, 53, 22];
  ConfigTrajet configTrajet = ConfigTrajet(8, 1, 2, []);

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
          appBar: PreferredSize(
            preferredSize: Size.fromHeight(30.0),
            child: AppBar(
              backgroundColor: Colors.orange,
              foregroundColor: Colors.white,
              actions: <Widget>[
                //buildSlider(),
                Expanded(
                  child: Text(
                    "  " +
                        nbBrocOK.toString() +
                        "/" +
                        nbBrocabrac.toString() +
                        "  " +
                        formatDateBrocante(dateSelected),
                    style: TextStyle(
                        fontSize: 13.0,
                        color: Colors.white,
                        backgroundColor: Colors.orangeAccent,
                        fontWeight: FontWeight.w600),
                  ),
                ),
                Expanded(
                  child: Text(
                    "  " + centralCommune,
                    style: TextStyle(
                        fontSize: 12.0,
                        color: Colors.white,
                        fontWeight: FontWeight.w600),
                  ),
                ),
                ElevatedButton(
                    child: Text('VG', style: TextStyle(fontSize: 15)),
                    style: ButtonStyle(
                        backgroundColor: MaterialStateProperty.all(colorBROC)),
                    onPressed: () {
                      setState(() {
                        colorMAISON = colorKO;
                        colorBROC = colorOK;
                      });
                      finHttps = "&c=bro,vgr,bra&d= ";
                      nbStepAsync = 0;
                      readBrocabrac();
                    }),
                ElevatedButton(
                    child: Text('VM', style: TextStyle(fontSize: 10)),
                    style: ButtonStyle(
                        backgroundColor:
                            MaterialStateProperty.all(colorMAISON)),
                    onPressed: () {
                      setState(() {
                        colorMAISON = colorOK;
                        colorBROC = colorKO;
                      });
                      finHttps = "&c=vma&d= ";
                      nbStepAsync = 0;
                      readBrocabrac();
                    }),
                ElevatedButton(
                    child: Text(
                      'Ou?',
                    ),
                    onPressed: () {
                      callCobrac(context);
                    })
              ],
            ),
          ),
          body: SafeArea(
            child: Row(children: <Widget>[getListView(), getListViewReduce()]),
          ),
          bottomNavigationBar: Row(
              //crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.start,
              children: <Widget>[
                IconButton(
                  // unused
                  icon: const Icon(Icons.arrow_back_outlined),

                  iconSize: cobracIconSize,
                  color: Colors.blue,
                  tooltip: 'Samedi',
                  onPressed: () {
                    print("nbStepAsync= " + nbStepAsync.toString());
                    nbStepAsync = 0;
                    nbBrocabrac = 0;
                    dateSelected = getDateNextSamedi();
                    dateSelectedPrev = dateSelected;
                    readBrocabrac();
                    print("dateSelected Samedi= " + dateSelected);
                  },
                ),
                IconButton(
                  // unused
                  icon: const Icon(Icons.arrow_forward_outlined),

                  iconSize: cobracIconSize,
                  color: Colors.deepOrange,
                  tooltip: 'Dimanche',
                  onPressed: () {
                    nbStepAsync = 0;

                    print("dateSelected Dimanche= " + dateSelected);
                    nbBrocabrac = 0;

                    dateSelected = getDateNextDimanche();
                    dateSelectedPrev = dateSelected;
                    readBrocabrac();
                  },
                ),
                IconButton(
                  // unused
                  icon: const Icon(Icons.car_rental),

                  iconSize: cobracIconSize,
                  color: Colors.deepOrange,
                  tooltip: 'Dimanche',
                  onPressed: () {
                    computeDense(20);
                  },
                ),
                IconButton(
                  // unused
                  icon: const Icon(Icons.alarm),
                  iconSize: cobracIconSize,
                  color: Colors.deepPurple,
                  tooltip: 'Change date',
                  onPressed: () async {
                    String dateSelection = await (Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => ConfigBrocante(),
                        settings: RouteSettings(
                            // arguments: centralCommune,
                            // townContactReduce[index]
                            ),
                      ),
                    ));
                    setState(() {
                      // Maj

                      dateSelectedPrev = dateSelected;

                      dateSelected = dateSelection ?? dateSelectedPrev;
                    });
                    if (dateSelectedPrev != dateSelected) {
                      nbStepAsync = 0; // Bizarre
                      readBrocabrac();
                    }
                    if (dateKey == dateSelected) {
                      secureHistory = 1;
                    } else {
                      secureHistory = 1;
                    }
                  },
                ),
                IconButton(
                  // unused
                  icon: const Icon(Icons.map_outlined),
                  iconSize: cobracIconSize,
                  color: Colors.black87,
                  tooltip: 'Carte',
                  onPressed: () {
                    //TODO  controle des mutiples Press
                    mapTrip = rangeMarkers();
                    Brocabrac _brocabrac=brocanteBrocabrac[1]; // PML Bidon
                    ManageCobrac manageCobrac =
                        ManageCobrac(brocanteBrocabrac, mapTrip, _brocabrac);
                    setState(() {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => ContactMap(),
                          settings: RouteSettings(
                            arguments: manageCobrac,
                          ),
                        ),
                      );
                    });
                  },
                ),
                IconButton(
                  // unused
                  icon: const Icon(Icons.arrow_back_ios_new_outlined),

                  iconSize: cobracIconSize,
                  color: Colors.blue,
                  tooltip: 'Fast avant',
                  onPressed: () {
                    nbStepAsync = 0;
                    nbBrocabrac = 0;
                    setState(() {
                      dateSelected = getDatePrevActif();
                      //  dateSelectedPrev = dateSelected;

                      readBrocabrac();
                    });
                  },
                ),
                IconButton(
                  // unused
                  icon: const Icon(Icons.arrow_forward_ios),

                  iconSize: cobracIconSize,
                  color: Colors.deepOrange,
                  tooltip: 'Fast Suivant',
                  onPressed: () {
                    nbStepAsync = 0;
                    nbBrocabrac = 0;
                    setState(() {
                      dateSelected = getDateNextActif();
                      //dateSelectedPrev = dateSelected;
                    });
                    readBrocabrac();
                  },
                ),
                IconButton(
                  // unused
                  icon: const Icon(Icons.add_to_photos_sharp),

                  iconSize: cobracIconSize,
                  color: Colors.red,
                  tooltip: '+1 Jour',
                  onPressed: () {
                    nbStepAsync = 0;
                    nbBrocabrac = 0;
                    setState(() {
                      dateSelected = getDateNextPeanuts();
                      //dateSelectedPrev = dateSelected;
                    });
                    readBrocabrac();
                  },
                ),
              ])),
    );
  }

  //**************************************************
  Future callCobrac(BuildContext context) async {
    configTrajet = await (Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => MapCobrac()),
    ));

    MonCoin.clear();
    for (int k = 0; k < configTrajet.tripSelected.length; k++) {
      MonCoin.add(configTrajet.tripSelected[k]);
      print("configTrajet-->" + configTrajet.tripSelected[k].toString());
    }
    nbStepAsync = 0;
    setState(() {
      nbStepAsync = 0;
    });
    readBrocabrac();
  }

  //**************************************************
  void completeInfosPlus() {
    // A ce niveau Ajout des etoiles Pour la taille
    // des € pour Revenu
    //   Bary Centre
    for (Brocabrac _brocky in brocanteBrocabrac) {
      String thatVille = _brocky.brocLocality;
      // On y est allé ?
      _brocky.brocDejaVu = "New";
      if (isInHistoric(thatVille)) _brocky.brocDejaVu = "";
      _brocky.revenu = 0;
      for (Commune _communy in listCommunes) {
        if (_communy.ville == thatVille) {
          _brocky.revenu = _communy.revenu.toInt();
          _brocky.brocStarRevenu = "?";
          if (_brocky.revenu > 10000) {
            _brocky.brocStarRevenu = "€";
          }
          if (_brocky.revenu > 15000) {
            _brocky.brocStarRevenu = "€€";
          }
          if (_brocky.revenu > 20000) {
            _brocky.brocStarRevenu = "€€€";
          }
          if (_brocky.revenu > 25000) {
            _brocky.brocStarRevenu = "€€€€";
          }
          if (_brocky.revenu > 30000) {
            _brocky.brocStarRevenu = "€€€€€";
          }
          break;
        }
      }
    }
    for (Brocabrac _brocky in brocanteBrocabrac) {
      _brocky.brocStarNbExposants = "??";
      if (_brocky.brocNbExposants == "Moins de 50") {
        _brocky.brocStarNbExposants = "25";
      }
      if (_brocky.brocNbExposants == "De 50 à 100") {
        _brocky.brocStarNbExposants = "75";
      }
      if (_brocky.brocNbExposants == "De 100 à 200") {
        _brocky.brocStarNbExposants = "150";
      }
      if (_brocky.brocNbExposants == "De 200 à 300") {
        _brocky.brocStarNbExposants = "250";
      }
      if (_brocky.brocNbExposants == "Plus de 300") {
        _brocky.brocStarNbExposants = "300";
      }
    }

    /*  Calcul de Densité
    On se donne un rayon et on compte combien de brocantes dans  ce cercle
    Pour l'instant ne pas faire intervenir  le nombre d'exposants
    Attention qqfois brocabrac declare 2 fois la meme
    qqfois des particuliers prennent le statut de vide grenier

     */
    int nbInside = -1;
    for (Brocabrac _brocky in brocanteBrocabrac) {
      var latitudeFrom = _brocky.brocLatitude;
      var longitudeFrom = _brocky.brocLongitude;

      nbInside = -1;
      for (Brocabrac _brocky2 in brocanteBrocabrac) {
        var latitudeTo = _brocky2.brocLatitude;
        var longitudeTo = _brocky2.brocLongitude;
        double bricolo = GeoUtils.distanceInKmBetweenEarthCoordinates(
            latitudeFrom, longitudeFrom, latitudeTo, longitudeTo);
        int initialdist = (bricolo * pifoMetre).round();
        if (initialdist < rayonBarycentre) nbInside++;
      }
      _brocky.brocInside = nbInside;
    }
    //  Calcul de la Note  densité ,revenu , derniere note , distance , plan B
    // Kilometrage important
    // Calcul du Cout Essence
    // Existence d'un plan B  < 15 km
  }

  //**************************************************
  void computeNewDistance() {
    // Un nouveau centre est défini
    // Il va servir d'origine pour calculer les nouvelles`
    // distances
    // On va dupkiquer la liste des brocantes
    // et les retrier
    //Brocabrac est la liste d'origine Cergy
    for (Brocabrac _brocky in brocanteBrocabrac) {
      var latitudeTo = _brocky.brocLatitude;
      var longitudeTo = _brocky.brocLongitude;
      double bricolo = GeoUtils.distanceInKmBetweenEarthCoordinates(
          latitudeRef, longitudeRef, latitudeTo, longitudeTo);
      int initialdist = (bricolo * pifoMetre).round();
      _brocky.brocFromCenter = initialdist; // New Distance
    }
    // bon ca a lair de marcher
    completeInfosPlus(); // complement d'infos glanées sur f
    //
    // On tri
    brocanteBrocabrac
        .sort((a, b) => a.brocFromCenter.compareTo(b.brocFromCenter));
    colorBrocante.clear();

    int thatMaster = 0;
    setState(() {
      for (Brocabrac _brocky in brocanteBrocabrac) {
        thatMaster++;
        _brocky.brocMaster = thatMaster;
        if (_brocky.brocEventStatus == "OK")
          colorBrocante.add(Colors.green);
        else
          colorBrocante.add(Colors.red);
      }
    });
    getListView();
    getListViewReduce();
  }

//

  void computeNewDistanceFromSelectPml() {
    // Consecuti a un nouveau choix
    for (Brocabrac _brocky in brocanteBrocabrac) {
      var latitudeTo = _brocky.brocLatitude;
      var longitudeTo = _brocky.brocLongitude;
      double bricolo = GeoUtils.distanceInKmBetweenEarthCoordinates(
          latitudeSelect, longitudeSelect, latitudeTo, longitudeTo);
      int initialdist = (bricolo * pifoMetre).round();
      _brocky.brocFromSelect = initialdist;
    }
    // brocanteBrocabrac
    //   .sort((a, b) => a.brocFromSelect.compareTo(b.brocFromSelect));
    setState(() {
      nbBrocOK = 0;
      brocanteBrocabracBis.clear();
      for (Brocabrac _brocky in brocanteBrocabrac) {
        if (_brocky.brocEventStatus == 'OK') {
          setState(() {
            nbBrocOK++;
          });

          brocanteBrocabracBis.add(_brocky);
        }
      }
    });
    brocanteBrocabracBis
        .sort((a, b) => a.brocFromSelect.compareTo(b.brocFromSelect));
    nbBrocOK = 0;
    for (Brocabrac _brocky in brocanteBrocabracBis) {
      if (_brocky.brocEventStatus == 'OK') {
        setState(() {
          nbBrocOK++;
        });
        _brocky.brocMaster = nbBrocOK; // indicateur Index pour les fleches
      }
    }
  }

  void computeNewDistanceFromSelect() {
    //final pifoMetre = 1000; // Conversion de kilomètres en mètres

    // Calculer les distances et mettre à jour _brocky.brocFromSelect
    for (Brocabrac _brocky in brocanteBrocabrac) {
      final latitudeTo = _brocky.brocLatitude;
      final longitudeTo = _brocky.brocLongitude;
      final bricolo = GeoUtils.distanceInKmBetweenEarthCoordinates(
          latitudeSelect, longitudeSelect, latitudeTo, longitudeTo);
      final initialdist = (bricolo * pifoMetre).round();
      _brocky.brocFromSelect = initialdist;
    }

    // Trier les éléments de brocanteBrocabracBis en fonction de brocFromSelect
    brocanteBrocabracBis = List.from(brocanteBrocabrac);
    brocanteBrocabracBis
        .sort((a, b) => a.brocFromSelect.compareTo(b.brocFromSelect));

    // Mettre à jour nbBrocOK et filtrer les éléments avec un statut 'OK'
    setState(() {
      nbBrocOK = brocanteBrocabracBis
          .where((brocabrac) => brocabrac.brocEventStatus == 'OK')
          .length;
      brocanteBrocabracBis
          .retainWhere((brocabrac) => brocabrac.brocEventStatus == 'OK');
    });

    // Mettre à jour brocMaster pour les éléments avec un statut 'OK'
    nbBrocOK = 0;
    brocanteBrocabracBis.forEach((brocabrac) {
      setState(() {
        nbBrocOK++;
      });
      brocabrac.brocMaster = nbBrocOK; // indicateur Index pour les flèches
    });
  }

  void computeDensePML(int denseRayon) {
    // Consecuti a un nouveau choix

    for (Brocabrac _brocky in brocanteBrocabrac) {
      var latitudeFrom = _brocky.brocLatitude;
      var longitudeFrom = _brocky.brocLongitude;

      int nbdens = 0;

      for (Brocabrac _brocky2 in brocanteBrocabrac) {
        if (_brocky2.brocEventStatus == 'OK') {
          double bricolo = GeoUtils.distanceInKmBetweenEarthCoordinates(
              latitudeFrom,
              longitudeFrom,
              _brocky2.brocLatitude,
              _brocky2.brocLongitude);
          int initialdist = (bricolo * pifoMetre).round();

          if ((initialdist > 1) && (initialdist <= denseRayon)) nbdens++;
        }
      }
      setState(() {
        //"❤"
        _brocky.brocStarBarycentre = "";

        for (int i = 1; i <= nbdens; i++) {
          _brocky.brocStarBarycentre = _brocky.brocStarBarycentre + "🚓";
        }
      });

      //});
    }
  }

  void computeDense(int denseRayon) {
    for (Brocabrac _brocky in brocanteBrocabrac) {
      if (_brocky.brocEventStatus == 'OK') {
        var latitudeFrom = _brocky.brocLatitude;
        var longitudeFrom = _brocky.brocLongitude;

        int nbdens = 0;

        for (Brocabrac _brocky2 in brocanteBrocabrac) {
          if (_brocky2.brocEventStatus == 'OK' && _brocky != _brocky2) {
            double bricolo = GeoUtils.distanceInKmBetweenEarthCoordinates(
                latitudeFrom,
                longitudeFrom,
                _brocky2.brocLatitude,
                _brocky2.brocLongitude);
            int initialdist = (bricolo * pifoMetre).round();
            print("brocky.brocStarBarycentre -->" + initialdist.toString());
            if (initialdist > 1 && initialdist <= denseRayon) nbdens++;
          }
        }

        setState(() {
          _brocky.brocStarBarycentre = "🚓" * nbdens;
        });
      }
    }
  }

  //**************************************************
  String formatDateBrocante(dateselect) {
    DateTime naw = DateTime.parse(dateselect);
    String formatter = jours[naw.weekday] +
        " " +
        naw.day.toString() +
        " " +
        mois[naw.month].toString();
    return (formatter);
  }

  //**************************************************
  Brocabrac getCurrentBrocabrac(String centralCommune) {
    // Possibiliré de Doublonn
    late Brocabrac _rocky;
    for (Brocabrac _brocky in brocanteBrocabrac) {
      if (_brocky.brocLocality == centralCommune) {
        return (_brocky);
      }
      _rocky=_brocky;
    }
    return (_rocky);// PML bidon pour eviter Null
  }

  //*******************************************
  void getCurrentCommmune() {
    // Possibiliré de Doublonn
    for (Brocabrac _brocky in brocanteBrocabrac) {
      if (_brocky.brocLocality == centralCommune) {
        // PML DOUTE de flasher les REF
        //latitudeRef = _brocky.brocLatitude;
        //longitudeRef = _brocky.brocLongitude;
        latitudeSelect = _brocky.brocLatitude;
        longitudeSelect = _brocky.brocLongitude;
        break;
      }
    }
  }

//**************************************************
  String getDateNextActif() {
    //On va se balader de dimanche en samedi etc
    // On commencera par initialiser le dimanche initial
    // Enduite on aura le Dimanche actif queon incrementera de 7 en 7
    // Si actif
    // Le samrdi sera le dimanche actif -1
    // comment trater les jours fériés ?
    // var nowInit  = nowTemp.add(Duration(days: 7 - nowTemp.weekday));
    //  var nowActif=nowInit;

    // Samedi ou Dimanche ??
    centralCommune = "";
    var quelJour = nowActif.weekday;
    switch (quelJour) {
      case 6:
        nowActif = nowActif.add(Duration(days: 1));
        break;
      case 7:
        nowActif = nowActif.add(Duration(days: 6));
        break;
      default:
    }
    actifPeanuts = nowActif;
    String formatter = "";
    var naw = nowActif;
    if (naw.day < 10 && naw.month >= 10)
      formatter = DateFormat('y-M-0d').format(naw);

    if (naw.month < 10 && naw.day >= 10)
      formatter = DateFormat('y-0M-d').format(naw);

    if (naw.day < 10 && naw.month < 10)
      formatter = DateFormat('y-0M-0d').format(naw);
    if (naw.day >= 10 && naw.month >= 10)
      formatter = DateFormat('y-M-d').format(naw);

    return (formatter);
  }

//**************************************************
  String getDateNextDimanche() {
    centralCommune = "";
    var now = new DateTime.now();
    String formatter = "";
    var naw = now.add(Duration(days: 7 - now.weekday));
    if (naw.day < 10 && naw.month >= 10)
      formatter = DateFormat('y-M-0d').format(naw);

    if (naw.month < 10 && naw.day >= 10)
      formatter = DateFormat('y-0M-d').format(naw);

    if (naw.day < 10 && naw.month < 10)
      formatter = DateFormat('y-0M-0d').format(naw);
    if (naw.day >= 10 && naw.month >= 10)
      formatter = DateFormat('y-M-d').format(naw);

    return (formatter);
  }

//**************************************************
  String getDateNextPeanuts() {
    //On va se balader de dimanche en samedi etc
    actifPeanuts = actifPeanuts.add(Duration(days: 1));
    centralCommune = "";
    String formatter = "";
    var naw = actifPeanuts;
    if (naw.day < 10 && naw.month >= 10)
      formatter = DateFormat('y-M-0d').format(naw);

    if (naw.month < 10 && naw.day >= 10)
      formatter = DateFormat('y-0M-d').format(naw);

    if (naw.day < 10 && naw.month < 10)
      formatter = DateFormat('y-0M-0d').format(naw);
    if (naw.day >= 10 && naw.month >= 10)
      formatter = DateFormat('y-M-d').format(naw);

    return (formatter);
  }

  //**************************************************
  String getDateNextSamedi() {
    centralCommune = "";
    var now = new DateTime.now();
    String formatter = "";
    var naw = now.add(Duration(days: 6 - now.weekday));
    if (naw.day < 10 && naw.month >= 10)
      formatter = DateFormat('y-M-0d').format(naw);

    if (naw.month < 10 && naw.day >= 10)
      formatter = DateFormat('y-0M-d').format(naw);

    if (naw.day < 10 && naw.month < 10)
      formatter = DateFormat('y-0M-0d').format(naw);
    if (naw.day >= 10 && naw.month >= 10)
      formatter = DateFormat('y-M-d').format(naw);

    return (formatter);
  }

  //**************************************************
  String getDatePrevActif() {
    // Samedi ou Dimanche ??
    centralCommune = "";
    DateTime nowa = new DateTime.now();
    var quelJour = nowActif.weekday;
    DateTime nowTemp = nowActif;

    switch (quelJour) {
      case 6:
        nowActif = nowActif.subtract(Duration(days: 6));
        break;
      case 7:
        nowActif = nowActif.subtract(Duration(days: 1));
        break;
      default:
    }

    if (nowActif.isBefore(nowa)) {
      nowActif = nowTemp;
    }
    actifPeanuts = nowActif; // Pour les détails
    String formatter = "";
    var naw = nowActif;

    if (naw.day < 10 && naw.month >= 10)
      formatter = DateFormat('y-M-0d').format(naw);

    if (naw.month < 10 && naw.day >= 10)
      formatter = DateFormat('y-0M-d').format(naw);

    if (naw.day < 10 && naw.month < 10)
      formatter = DateFormat('y-0M-0d').format(naw);
    if (naw.day >= 10 && naw.month >= 10)
      formatter = DateFormat('y-M-d').format(naw);

    return (formatter);
  }

//**************************************************
  Future<String> getInfoBrocabrac(Uri bigUrl)
// Step1 On instancie la classe brocabrac
// Step 2 on lit
  // Step 3  on Met les resultats dans le global brocante.Brocabrac
  async {
    NetworkHelper networkHelper = NetworkHelper();
    await networkHelper.getDataBrocabrac(bigUrl, fullMaster); //

    // A ce niveau rentrer la ligne des  distances dans

    for (Brocabrac _brocky in fullMaster) {
      nbBrocabrac++;
      _brocky.setbrocMaster(nbBrocabrac);
      brocanteBrocabrac.add(_brocky);
    }
    // A ce Niveau Ajouter les fichiers de Base pourles liteq
    computeNewDistance(); // Calculs de Base
    fullMaster.clear();
    print("Nb Brocantes = " + brocanteBrocabrac.length.toString());
    // Indiquer que c'est LU
    setState(() {
      nbStepAsync++;
    });
    if (nbStepAsync == maxStepAsync + 1) nbStepAsync = 0; // Pret à recommencer

    return ("OK");
  }

  Expanded getListViewPML() {
    var listView = ListView.builder(
        controller: ScrollController(),
        itemCount: brocanteBrocabrac.length,
        itemBuilder: (context, index) {
          return ListTile(
              //  leading: Icon(Icons.arrow_right),
              title: Text(
                brocanteBrocabrac[index].brocPostal +
                    " : " +
                    brocanteBrocabrac[index].brocLocality +
                    " à " +
                    brocanteBrocabrac[index].brocFromCenter.toString() +
                    " km " +
                    brocanteBrocabrac[index].brocStarBarycentre

                ,
                style: TextStyle(
                    fontSize: 12,
                    fontFamily: 'Serif',
                    color: colorBrocante[index]),
              ),
              subtitle: Text(
                brocanteBrocabrac[index].brocStarNbExposants +
                    " Expo " +
                    brocanteBrocabrac[index].brocName ,
                style: TextStyle(
                    fontSize: 12, fontFamily: 'Serif', color: Colors.black),
              ),
              dense: true,
              onLongPress: () {
                setState(() {
                  centralCommune = brocanteBrocabrac[index].brocLocality;
                });
                Brocabrac thisBrocabrac = getCurrentBrocabrac(centralCommune);
                List<Marker> allMarkers = [];
                GoToMarket _mapTrip =GoToMarket(2,allMarkers,1.0,
                    2.0); // PArametres PML Bidon


                ManageCobrac manageCobrac =
                    ManageCobrac(brocanteBrocabrac, _mapTrip, thisBrocabrac);

                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => DetailBroc(),
                    settings: RouteSettings(
                        // arguments: centralCommune,
                        arguments: manageCobrac),
                  ),
                );
              },

              onTap: () {
                setState(() {
                  if (brocanteBrocabrac[index].brocEventStatus == "OK") {
                    centralCommune = brocanteBrocabrac[index].brocLocality;
                    getCurrentCommmune(); // Step N°1 Position Centre
                    computeNewDistanceFromSelect();
                  }
                });
              });

        });

    return Expanded(child: listView);
  }
  Expanded getListView() {
    var listView = ListView.builder(
      controller: ScrollController(),
      itemCount: brocanteBrocabrac.length,
      itemBuilder: (context, index) {
        return InkWell(
          onTap: () {
            setState(() {
              if (brocanteBrocabrac[index].brocEventStatus == "OK") {
                centralCommune = brocanteBrocabrac[index].brocLocality;
                getCurrentCommmune(); // Step N°1 Position Centre
                computeNewDistanceFromSelect();
              }
            });
          },
          onLongPress: () {
            setState(() {
              centralCommune = brocanteBrocabrac[index].brocLocality;
            });
            Brocabrac thisBrocabrac = getCurrentBrocabrac(centralCommune);
// Bidon PML 2 lignes
            List<Marker> allMarkers = [];
            GoToMarket _mapTrip =GoToMarket(2,allMarkers,1.0,
                2.0); // PArametres PML Bidon

            ManageCobrac manageCobrac =
            ManageCobrac(brocanteBrocabrac, _mapTrip, thisBrocabrac);

            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => DetailBroc(),
                settings: RouteSettings(
                  // arguments: centralCommune,
                  arguments: manageCobrac,
                ),
              ),
            );
          },
          onDoubleTap: () {
            setState(() {
              if (brocanteBrocabrac[index].brocEventStatus == "OK") {

                if (brocanteBrocabrac[index].brocLove== "❤") {
                  brocanteBrocabrac[index].brocLove="";
              }
                else
                {
                  brocanteBrocabrac[index].brocLove="❤";
                }
              }
            });
          },
          child: ListTile(
            title: Text(
              brocanteBrocabrac[index].brocPostal +
                  " : " +
                  brocanteBrocabrac[index].brocLocality +
                  " à " +
                  brocanteBrocabrac[index].brocFromCenter.toString() +
                  " km " +
                  brocanteBrocabrac[index].brocStarBarycentre + " "+ brocanteBrocabrac[index].brocLove,
              style: TextStyle(
                fontSize: 12,
                fontFamily: 'Serif',
                color: colorBrocante[index],
              ),
            ),
            subtitle: Text(
              brocanteBrocabrac[index].brocStarNbExposants +
                  " Expo " +
                  brocanteBrocabrac[index].brocName,
              style: TextStyle(
                fontSize: 12,
                fontFamily: 'Serif',
                color: Colors.black,
              ),
            ),
            dense: true,
          ),
        );
      },
    );

    return Expanded(child: listView);
  }


  //********************* *****************************
  Expanded getListViewReduce() {
    var listView = ListView.builder(
        controller: ScrollController(),
        itemCount: brocanteBrocabracBis.length,
        itemBuilder: (context, index) {
          return ListTile(
              //leading: Icon(Icons.favorite),
              title: Text(
                brocanteBrocabracBis[index].brocPostal +
                    " : " +
                    brocanteBrocabracBis[index].brocLocality +
                    " à " +
                    brocanteBrocabracBis[index].brocFromSelect.toString() +
                    " km  - " +
                    brocanteBrocabracBis[index].brocStarNbExposants +
                    " Expo " +
                    // (brocanteBrocabracBis[index].revenu ~/ 1000).toString() +
                    brocanteBrocabracBis[index].brocStarRevenu ,
                style: TextStyle(
                    fontSize: 14, fontFamily: 'Serif', color: brocanteBrocabracBis[index].brocDejaVu =="New" ?Colors.black : Colors.blue),
              ),
              /*subtitle: Text(
                brocanteBrocabracBis[index].brocDejaVu,
                style: TextStyle(
                   // color: useColor1 ? color1 : color2,
                    fontSize: 15, fontFamily: 'Serif', color: Colors.red),
              ),*/
              dense: true,
              onTap: () {},
              onLongPress: () {
                if (isInHistoric(brocanteBrocabracBis[index].brocLocality) &&
                    (secureHistory == 1)) {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => Histeric(),
                      settings: RouteSettings(
                        // arguments: centralCommune,
                        arguments: brocanteBrocabracBis[index].brocLocality,
                      ),
                    ),
                  );
                }
              });
        });
    // il faudra remettre en ordre SelectColor
    return Expanded(child: listView);
  }

//**************************************************
  @override
  void initState() {
    super.initState();
    dateSelected = getDateNextDimanche();
    dimancheInitial = dateSelected;
    DateTime nowTemp = new DateTime.now();
    nowInit = nowTemp.add(Duration(days: 7 - nowTemp.weekday));
    nowActif = nowInit;
    actifPeanuts = nowActif;

    centralCommune = versionNum;

    colorVVF = colorKO;
    colorMORV = colorKO;
    colorLAR = colorOK;
    latitudeRef = latitudeLarris;
    longitudeRef = longitudeLarris;
    latitudeRef = latitudeLarris;
    longitudeRef = longitudeLarris;
    latitudeRef = latitudePortbail;
    longitudeRef = longitudePortbail;
    latitudeSelect = latitudeRef;
    longitudeSelect = longitudeRef;

    nbBrocabrac = 0;
    readBrocabrac();
    nbBrocabrac = nbBrocabrac;
  }

//**************************************************
  bool isInHistoric(String thatVille) {
    for (Historic _his in listHistoric) {
      if (_his.histVille == thatVille) {
        return (true);
      }
    }
    return (false);
  }

//**************************************************
  int passeParPiege(double latfrom, double longfrom, double latitudeTo,
      double longitudeTo, int initialdist) {
    return (1);
  }

//*******************************************************
  GoToMarket rangeMarkers() {
    //  Set Matrice de Passage à une  autre Classe
    // La Matric est une classe d'arguments

    int nbStep = 0; // TOMODIFY
    List<Marker> allMarkers = [];
    double ccenterLatitude = 0.0;
    double ccenterLongitude = 0.0;
    GoToMarket gogo; //Bidon
    for (int i = 1; i <= brocanteBrocabrac.length; i++) {
      Brocabrac _mapic = brocanteBrocabrac[i - 1];
      Brocabrac _fakit = brocanteBrocabrac[i - 1]; //Bidon
      if (_mapic.brocEventStatus == "OK") {

        List<Marker> allMarkers = [];
        GoToMarket gogo =GoToMarket(2,allMarkers,1.0,
            2.0); // PArametres PML Bidon


        ManageCobrac manageCobrac =
            ManageCobrac(brocanteBrocabrac, gogo, _fakit); //Bidon
        if (nbStep == 0) {
          ccenterLatitude = _mapic.brocLatitude;
          ccenterLongitude = _mapic.brocLongitude;
        } else {
          ccenterLatitude = (ccenterLatitude + _mapic.brocLatitude) / 2.0;
          ccenterLongitude = (ccenterLongitude + _mapic.brocLongitude) / 2.0;
        }
        nbStep++;
        var _markerOrdre =
            "N°" + nbStep.toString() + " : " + _mapic.brocLocality;
//  definir les futurs Markers qui setont utilisés sur la carte
        allMarkers.add(Marker(
          markerId: MarkerId(nbStep.toString()),
          draggable: false,
          infoWindow:
              InfoWindow(title: _markerOrdre, snippet: _mapic.brocLocality),
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => DetailBroc(),
                settings: RouteSettings(
                  arguments: manageCobrac,
                ),
              ),
            );
          },
          position: LatLng(_mapic.brocLatitude, _mapic.brocLongitude),
        ));
      }
    }
    GoToMarket _mapTrip =
        GoToMarket(nbStep, allMarkers, latitudeRef, longitudeRef);
    _mapTrip.centerLatitude = ccenterLatitude;
    _mapTrip.centerLongitude = ccenterLongitude;
    _mapTrip.tripNbStep = nbStep;
    return (_mapTrip);
  }

  void readBrocabrac() {
    print("ReadBrocabrac  inside");
    // A refaire prendre la liste des départementsdans un fchier et consruire les https
    DateTime dt = DateTime.parse(dateSelected);
    var now = DateTime.now();
    if (dt.isBefore(now)) {
      print("Date Avant KO" + dateSelected + "  " + dt.toString());
      //  return;
    }

    if (nbStepAsync > 0) return;
    nbBrocOK = 0;
    nbBrocabrac = 0;
    brocanteBrocabrac.clear();
    brocanteBrocabracBis.clear();

    nbStepAsync = 1; // Appelé une fois
    // Attendre jusqu'au Complet
    // String debutHttps = "https://brocabrac.fr/recherche?ou=";
    for (int dipart in MonCoin) {
      String quelCoin = dipart.toString();
      String paramHttps = debutHttps + quelCoin + finHttps + dateSelected;
      Uri myUrl = Uri.parse(paramHttps);
      print("myUrl =" + myUrl.toString());
      getInfoBrocabrac(myUrl);
    }
    // computeDense(50);
  }
}
//****
