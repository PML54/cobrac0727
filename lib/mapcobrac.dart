import 'package:flutter/material.dart';

//bra,bro,mal,vgr,vma
class MapCobrac extends StatefulWidget {
  const MapCobrac({key}) : super(key: key);

  @override
  State<MapCobrac> createState() => _MapCobracState();
}

class _MapCobracState extends State<MapCobrac>
    with SingleTickerProviderStateMixin {
  List<bool> DepFrance = [];

  ConfigTrajet configTrajet = ConfigTrajet(1, 0, 0, []);

  @override
  void initState() {
    super.initState();

    DepFrance.clear();
    for (int i = 0; i < 96; i++) DepFrance.add(false);
  }

  takeThisOne(int _depart) {
    setState(() {
      DepFrance[_depart] = !DepFrance[_depart];
    });
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      child: Scaffold(
        appBar: AppBar(actions: <Widget>[
          Center(
            child: Row(
              children: [
                IconButton(
                  icon: const Icon(Icons.arrow_back),
                  color: Colors.black,
                  iconSize: 30.0,
                  tooltip: 'Home',
                  onPressed: () {
                    Navigator.pop(context);
                  },
                ),
                IconButton(
                  icon: const Icon(Icons.save),
                  color: Colors.red,
                  iconSize: 30.0,
                  tooltip: 'Home',
                  onPressed: () {
                    updateConfigTrajet();
                    Navigator.pop(context, configTrajet);
                  },
                ),
              ],
            ),
          ),
        ]),
        body: Center(
          child: Row(
            children: [
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[

                  Row(
                    children: <Widget>[
                      thisDepart(50),
                      thisDepart(35),
                      thisDepart(14),
                    ],
                  ),
               /*   Row(
                    children: <Widget>[
                      thisDepart(22),
                      thisDepart(53),
                      thisDepart(61),
                    ],
                  ),*/
                ],
              ),
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Row(
                    children: <Widget>[
                      thisDepart(28),
                      thisDepart(27),
                      thisDepart(76),
                    ],
                  ),
                  Row(
                    children: <Widget>[
                      thisDepart(78),
                      thisDepart(95),
                    ],
                  ),
                  Row(
                    children: <Widget>[
                      thisDepart(92),
                      thisDepart(93),
                      thisDepart(60),
                    ],
                  ),
                  Row(
                    children: <Widget>[
                      thisDepart(91),
                      thisDepart(75),
                      thisDepart(94),
                      thisDepart(77),
                    ],
                  ),
         /*         Row(
                    children: <Widget>[
                      thisDepart(58),
                      thisDepart(21),
                    ],
                  ),*/
                ],
              ),
              /*   Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Row(
                    children: <Widget>[
                      thisDepart(58),
                    ],
                  ),
                  Row(
                    children: <Widget>[
                      thisDepart(21),
                      thisDepart(18),
                    ],
                  ),
                  Row(
                    children: <Widget>[
                      thisDepart(3),
                      thisDepart(83),
                      thisDepart(71),
                      thisDepart(45),
                    ],
                  ),
                ],
              ),*/
            ],
          ),
        ),
        // This trailing comma makes auto-formatting nicer for build methods.
      ),
    );
  }

  Padding thisDepart(int _thatone) {
    return Padding(
      padding: const EdgeInsets.all(1.0),
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          foregroundColor: Colors.white, backgroundColor: DepFrance[_thatone] ? Colors.teal : Colors.grey, disabledForegroundColor: Colors.grey.withOpacity(0.38), disabledBackgroundColor: Colors.grey.withOpacity(0.12),
        ),
        child: Text(_thatone.toString()),
        onPressed: () {
          takeThisOne(_thatone);
        },
      ),
    );
  }

  updateConfigTrajet() {
    configTrajet.tripSelected.clear();
    for (int j = 0; j < 96; j++) {
      if (DepFrance[j]) {
        configTrajet.tripSelected.add(j);
      }
    }
    configTrajet.codebrocante = 999;
  }
}

class ConfigTrajet {
  int codebrocante = 0;
  double centerLatitude;
  double centerLongitude;
  List<int> tripSelected = [];
  ConfigTrajet(this.codebrocante, this.centerLatitude, this.centerLongitude,
      this.tripSelected);
}
