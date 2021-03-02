import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:my_money/db/Preferences.dart';
import 'package:my_money/util/AppRouter.dart';
import 'package:my_money/util/DefaultText.dart';
import 'package:my_money/util/Helper.dart';
import 'package:toast/toast.dart';

import 'InputView.dart';

class MyApp extends StatefulWidget {
  // This widget is the root of your application.
  @override
  MyAppState createState() => MyAppState();
}

class MyAppState extends State<MyApp> {
  bool isStart = false;
  bool isLoading = false;

  TextEditingController _tabunganController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: isStart == true
          ? AppBar(
              backgroundColor: Colors.blueGrey,
              centerTitle: true,
              title: Text('HOME'),
            )
          : null,
      body: isStart == false
          ? startNew()
          : isLoading == true
              ? Center(
                  child: CircularProgressIndicator(),
                )
              : inputFirst(context),
    );
  }

  Widget startNew() {
    return Container(
      child: Stack(
        children: [
          Center(
            child: Container(
              margin: EdgeInsets.only(bottom: 100),
              child: DefaultText(
                textLabel: "WELCOME BACK WITH ME",
                colorsText: Colors.blueGrey,
                fontWeight: FontWeight.bold,
                sizeText: 20,
              ),
            ),
          ),
          Center(
            child: GestureDetector(
              onTap: () {
                setState(() {
                  isStart = true;
                  isLoading = true;
                  Future.delayed(Duration(seconds: 1)).then((value) {
                    setState(() {
                      isLoading = false;
                    });
                  });
                });
              },
              child: Container(
                height: 40,
                margin: EdgeInsets.only(left: 20, right: 20, top: 50),
                alignment: Alignment.center,
                decoration: BoxDecoration(
                    color: Colors.blueGrey,
                    borderRadius: BorderRadius.all(Radius.circular(10)),
                    border: Border.all(color: Colors.grey.withOpacity(0.5))),
                child: DefaultText(
                  textLabel: 'START',
                  colorsText: Colors.white,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  // gotoInput(BuildContext context) {
  //   Navigator.push(
  //     context,
  //     MaterialPageRoute(builder: (context) => InputData()),
  //   );
  // }

  Widget inputFirst(BuildContext context) {
    return Container(
      child: Column(
        children: [
          Container(
            margin: EdgeInsets.only(top: 100),
            alignment: Alignment.center,
            child: DefaultText(
              textLabel: 'MASUKAN TOTAL TABUNGAN',
              colorsText: Colors.blueGrey,
              fontWeight: FontWeight.bold,
            ),
          ),
          Container(
            margin: EdgeInsets.only(left: 20, right: 20, top: 10),
            child: TextFormField(
              keyboardType: TextInputType.number,
              controller: _tabunganController,
              maxLength: 21,
              decoration: InputDecoration(
                labelText: 'Tabungan',
                prefixText: '¥',
                prefixStyle: TextStyle(color: Colors.black),
              ),
            ),
          ),
          GestureDetector(
            onTap: () {
              if (_tabunganController.text.isEmpty) {
                Helper.showToast(context, 'Isi total tabungan dulu',
                    gravity: Toast.BOTTOM, duration: Toast.LENGTH_LONG);
              } else {
                Preferences.setId('saya');
                Preferences.setTabungan(_tabunganController.text);
                AppRouter.makeFirst(
                    context, NewOrder(total: _tabunganController.text));
              }
            },
            child: Container(
              height: 40,
              margin: EdgeInsets.only(left: 20, right: 20, top: 20),
              alignment: Alignment.center,
              decoration: BoxDecoration(
                  color: Colors.blueGrey,
                  borderRadius: BorderRadius.all(Radius.circular(10)),
                  border: Border.all(color: Colors.grey.withOpacity(0.5))),
              child: DefaultText(
                textLabel: 'SUBMIT',
                colorsText: Colors.white,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
