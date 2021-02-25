import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:my_money/db/Preferences.dart';
import 'package:my_money/input.dart';
import 'AppRouter.dart';
import 'Home.dart';

class SplashScreenView extends StatefulWidget {
  @override
  _SplashScreenViewState createState() => new _SplashScreenViewState();
}

class _SplashScreenViewState extends State<SplashScreenView> {
  startTime() async {
    var _duration = new Duration(seconds: 2);
    return new Timer(_duration, _goRouter);
  }

  void _goRouter() {
    Preferences.getId().then((value) {
      if (value.isNotEmpty) {
        Preferences.getTabungan().then((value) {
          AppRouter.makeFirst(context, NewOrder(total: value));
        });
      } else {
        AppRouter.makeFirst(context, MyApp());
      }
    });
  }

  @override
  void initState() {
    super.initState();
    startTime();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Container(
        child: Stack(
          children: [
            Container(
                margin: EdgeInsets.only(top: 180),
                alignment: Alignment.topCenter,
                child: Icon(Icons.circle)),
            Container(
                margin: EdgeInsets.only(bottom: 50),
                alignment: Alignment.bottomCenter,
                padding: EdgeInsets.all(10),
                child: Text(
                  'Version 0.00.1',
                  style: TextStyle(color: Colors.white, fontSize: 12),
                ))
          ],
        ),
      ),
    );
  }
}