// 18-10  Dart Gestion Erreur avec ??
// Apres ??  mettre la Valeur si Numm
// dateSelected = dateSelection  ?? dateSelectedPrev;

// Traitement des Infos recues de brocabrac
// On reçoit une URL vers brocabrac avec
// Une date
// des départements max 4
// catégorie Vg (vode grnier ) et Br ( brocnte)
// On renvoie lrs infos dans une liste d'objets brocabarc

import 'dart:convert';
import 'package:cobrac/pmltools.dart';
import 'package:html/dom.dart' as dom;
import 'package:html/parser.dart' show parse;
import 'package:http/http.dart' as http;

List lecture = [];

class NetworkHelper {
  NetworkHelper();

  Future<List> getDataBrocabrac(Uri myUrl, fullMaster) async {
    final response = await http.get(myUrl);

    if (response.statusCode == 200) {
      // If the server did return a 200 OK response    then parse the JSON.
      var stepOne = parse(response.body);

      List<dom.Element> nbexpo = stepOne.getElementsByClassName("dots");
      List nbExposants = [];
      for (dom.Element tata in nbexpo) {
        if (tata.attributes.containsKey("title") == false) {
        } else {
          var ff = tata.attributes["title"];
          nbExposants.add(ff);
        }
      }
      List<dom.Element> elocucu = stepOne.getElementsByTagName("script");
      int countBroc = 0;

      for (dom.Element entryBrocabrac in elocucu) {
        if (entryBrocabrac.attributes.containsKey("type")) {
          var whatType = entryBrocabrac.attributes["type"];

          if (whatType == "application/ld+json") {
            if (entryBrocabrac.hasChildNodes()) {

              var infoNodes = entryBrocabrac.nodes[0];
              var lookJson = infoNodes.text;
              Map<String, dynamic> user = jsonDecode(lookJson!);

              if (user["@type"] == "Event") {
                countBroc++;
                // @context  todo
                //@name  todo
                String _brocContext = user["@context"] ?? "";
                String _brocName = user["name"] ?? "";

                String _brocType = user["@type"] ?? "";
                String _brocLocality =
                    user["location"]["address"]["addressLocality"] ?? "";
                String _brocPostal =
                    user["location"]["address"]["postalCode"] ?? "";
                String _brocStreet =
                    user["location"]["address"]["streetAddress"] ?? "";
                double _brocLatitude =
                    user["location"]["geo"]["latitude"] ?? -100;
                double _brocLongitude =
                    user["location"]["geo"]["longitude"] ?? -100;
                String _brocEventStatus = user["eventStatus"] ?? "";
                String _brocOrganizer = "Unknown";
                if (user.containsKey("organizer") == true)
                  _brocOrganizer = user["organizer"]["name"] ?? "Unknown";

                String _brocStartDate = user["startDate"] ?? "";
                String _brocEndDate = user["endDate"] ?? "";
                String _brocDescription = user["description"] ?? "";

                String _brocNbExposants = "";
                if (nbExposants[countBroc - 1] != null)
                  _brocNbExposants = nbExposants[countBroc - 1];

                if (_brocEventStatus != null) {
                  if (_brocEventStatus.indexOf('ancelled') != -1) {
                    _brocEventStatus = 'KO';
                  } else //  Cancelled ?
                  {
                    _brocEventStatus = 'OK';
                  }
                }
                // _Brocabrac ne vit que quelques lignes
                // Pas en lowerCamelCase mais commencant par un unsescore pour
                // signifier le temporaire
                // Instance créée pour remplir full master

                Brocabrac _Brocabrac = Brocabrac(
                    _brocType,
                    _brocLocality,
                    _brocPostal,
                    _brocStreet,
                    _brocName,
                    _brocLatitude,
                    _brocLongitude,
                    _brocEventStatus,
                    _brocOrganizer,
                    _brocStartDate,
                    _brocEndDate,
                    _brocDescription,
                    _brocNbExposants);
                _Brocabrac.debugBrocLocality();
                fullMaster.add(_Brocabrac);
              } // Event
            } //application/ld+json
          }
        }
      }
      return (fullMaster);
    } else {
      //print(response.body);
      // If the server did not return a 200 OK response,
      // then throw an exception.
      throw Exception('Failed to load http');
    }
  }
}
