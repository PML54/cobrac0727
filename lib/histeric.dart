import 'package:cobrac/historibroc.dart';
import 'package:flutter/material.dart';

//
//MyHomePage({Key key, this.title}) : super(key: key);

class Histeric extends StatefulWidget {
  @override
  _HistericState createState() => _HistericState();
}

class _HistericState extends State<Histeric> {
  List<Historic> myHistoric = []; //
  String thatName = "";
  String thatDate = "";
  int thatGood = 0;
  String thatVille = "";
  int thatCodePostal = 0;
  String thatAdresse = "";
  int thatNbExpo = 0;
  int thatPmlDep = 0;
  int thatFraDep = 0;
  int thatMaisonDep = 0;
  String thatAvis = "";
  String thatDetail = "";
  int thatCode = 0; // N° Ordre
  int activeRecord = 0;
  int nbSelect = 0;

  // A recupérer
  double altitude = 0.0;
  double superficie = 0.0;
  double population = 0.0;
  int codeDepartement = 0;
  int codeRegion = 0;
  double revenu = 0.0;
  Color colorBrocor = Colors.grey;

  _readThisRecord() {
    setState(() {
      //  print("Inside Read Record" + activeRecord.toString());
      // print("myHistoric[activeRecord].histName" +
      //  myHistoric[activeRecord].histName);
      thatName = myHistoric[activeRecord].histName;
      thatDate = myHistoric[activeRecord].histDate;
      thatGood = myHistoric[activeRecord].histGood;
      thatVille = myHistoric[activeRecord].histVille;
      thatCodePostal = myHistoric[activeRecord].histCodePostal;
      thatAdresse = myHistoric[activeRecord].histAdresse;
      thatNbExpo = myHistoric[activeRecord].histNbExpo;
      thatPmlDep = myHistoric[activeRecord].histPmlDep;
      thatFraDep = myHistoric[activeRecord].histFraDep;
      thatMaisonDep = myHistoric[activeRecord].histMaisonDep;
      thatAvis = myHistoric[activeRecord].histAvis;
      thatDetail = myHistoric[activeRecord].histDetail;
      thatCode = myHistoric[activeRecord].histCode;
      if (thatDetail == 'No') thatDetail = " ";
      thatAvis = thatAvis + " .....";
      colorBrocor = Colors.black12;
      if (thatGood == 1) colorBrocor = Colors.red;
      if (thatGood == 2) colorBrocor = Colors.orange;
      if (thatGood == 3) colorBrocor = Colors.blue;
      if (thatGood == 4) colorBrocor = Colors.greenAccent;
    });
  }

  objSort(List<Historic> hist, String ladate) {}

  @override
  Widget build(BuildContext context) {
// Je n'arrive pas à deplacer   l'extraction
    // est relancer à chque refresh
// ThatCommue Point d'entrée

   // thatCommune = ModalRoute.of(context)?.settings.arguments;

    String? thatCommune = ModalRoute.of(context)?.settings.arguments as String? ?? "";

    myHistoric.clear();
    for (Historic _his in listHistoric) {
      // On ne teste que que  sur le nom de la Ville
      // Pur Paris cela est trop vage
      if (_his.histVille == thatCommune) {
        myHistoric.add(_his);
      }
    }
    // 21-10-15 pour inverser changer a en b  ( date decroissante ci-dessous)
    myHistoric.sort((a, b) => b.histCheckDate.compareTo(a.histCheckDate));
    int nbSelect = myHistoric.length;
    if (nbSelect > 0)
      _readThisRecord();
    else
      Navigator.pop(context);
    return Scaffold(
      appBar: AppBar(actions: <Widget>[
        Center(
          child: IconButton(
            icon: const Icon(Icons.arrow_back),
            // ON REMONTE
            color: Colors.green,
            iconSize: 60.0,
            tooltip: 'Home',
            onPressed: () {
              setState(() {
                activeRecord--;
                if (activeRecord < 0) activeRecord = 0;
                _readThisRecord();
              });
            }, //ava
          ),
        ),
        //
        IconButton(
          icon: const Icon(Icons.laptop),
          color: Colors.green,
          iconSize: 30.0,
          tooltip: 'Home',
          onPressed: () {
            setState(() {});
          },
        ),
        //
        Center(
          child: IconButton(
            icon: const Icon(Icons.arrow_forward),
            // ON DESCEND
            color: Colors.green,
            iconSize: 60.0,
            tooltip: 'Home',
            onPressed: () {
              setState(
                () {
                  activeRecord++;
                  if (activeRecord >= nbSelect) activeRecord--;

                  // print("active avant drt state " + activeRecord.toString());
                },
              );
            },
          ),
        ),
      ]),
      body: Container(
        height: 500,
        padding: EdgeInsets.all(20),
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: <Widget>[
              Row(
                children: <Widget>[
                  RichText(
                      text: TextSpan(
                    style: TextStyle(color: Colors.black, fontSize: 20),
                    text: ' ' + thatName + ' :  ',
                  )),
                  RichText(
                      text: TextSpan(
                    style: TextStyle(color: colorBrocor, fontSize: 20),
                    text: '#' + thatDate + '# ',
                  )),
                  RichText(
                      text: TextSpan(
                    style: TextStyle(color: Colors.black, fontSize: 20),
                    text: ' <' + thatNbExpo.toString() + '>',
                  )),
                ],
              ),
              RichText(
                  text: TextSpan(
                style: TextStyle(color: colorBrocor, fontSize: 18),
                text: thatCommune,
              )),
              RichText(
                  text: TextSpan(
                style: TextStyle(color: colorBrocor, fontSize: 22),
                text: thatAdresse,
              )),
              SingleChildScrollView(
                child: RichText(
                  text: TextSpan(
                    style: TextStyle(color: Colors.black, fontSize: 18),
                    text: thatAvis,
                  ),
                ),
              ),
              SingleChildScrollView(
                child: RichText(
                  text: TextSpan(
                    style: TextStyle(color: Colors.black, fontSize: 16),
                    text: thatDetail,
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
