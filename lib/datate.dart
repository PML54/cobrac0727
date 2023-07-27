import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

// Ici  pas d'input
// on retourne   final date Navigator.pop(context, finaldate);
class ConfigBrocante extends StatefulWidget {
  ConfigBrocante({Key? key}) : super(key: key);

  @override
  _ConfigBrocanteState createState() => new _ConfigBrocanteState();
}

class _ConfigBrocanteState extends State<ConfigBrocante> {
  var finaldate;

  void callDatePicker() async {
    var order = await getDate();
    setState(() {
      finaldate = order.toString().substring(0, 10);
    });
  }

  Future<DateTime?> getDate() {
    return showDatePicker(
      context: context,
      // locale : const Locale("fr","FR"),
      initialDate: DateTime.now(),
      firstDate: DateTime(2018),
      lastDate: DateTime(2030),
      //
      builder: (BuildContext context, Widget? child) {
        return Theme(
          data: ThemeData.light(),
          child: child!,
        );
      },




    );
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      localizationsDelegates: [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ],
      supportedLocales: [const Locale('en'), const Locale('fr')],
      home: new Scaffold(
        appBar: new AppBar(
          title: new Text('Configuration'),
        ),
        body: new Center(
          child: new Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Container(
                decoration: BoxDecoration(color: Colors.grey[200]),
                padding: EdgeInsets.symmetric(horizontal: 30.0),
                child: finaldate == null
                    ? Text(
                  "2021-**-**",
                  textScaleFactor: 2.0,
                )
                    : Text(
                  "$finaldate",
                  textScaleFactor: 2.0,
                ),
              ),
              new ElevatedButton(
                onPressed: callDatePicker,
                // color: Colors.blueAccent,
                child: new Text('Date', style: TextStyle(color: Colors.white)),
              ),
              new ElevatedButton(
                onPressed: () {
                  Navigator.pop(context, finaldate);
                },
                //  color: Colors.greenAccent,
                child: Container(
                    child: new Text('Back',
                        style: TextStyle(color: Colors.white))),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
