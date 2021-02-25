import 'package:date_format/date_format.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';
import 'package:my_money/AppRouter.dart';
import 'package:my_money/Home.dart';
import 'package:my_money/db/History.dart';
import 'package:my_money/db/Preferences.dart';
import 'package:my_money/util/DefaultText.dart';
import 'package:my_money/util/Helper.dart';
import 'package:toast/toast.dart';

import 'db/DatabaseHelper.dart';

class NewOrder extends StatefulWidget {
  String total;

  @override
  _NewOrderState createState() => _NewOrderState();

  NewOrder({Key key, @required this.total}) : super(key: key);
}

class _NewOrderState extends State<NewOrder> {
  TextEditingController productNameController = TextEditingController();

  TextEditingController priceController = TextEditingController();
  bool isLoading = false;
  String date;
  int totalPengeluaran = 0;
  int totalSisa = 0;
  String _date = '-';

  final dbHelper = DatabaseHelper.instance;
  List<History> history = [];
  List price = [];
  List<History> historyByDate = [];

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    totalSisa = int.parse(widget.total);
    _queryAll();
  }

  void _showMessageInScaffold(String message) {
    Scaffold.of(context).showSnackBar(SnackBar(
      content: Text(message),
    ));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.blueGrey,
          centerTitle: true,
          title: Text('Input Pengeluaran'),
          actions :[
            GestureDetector(
              onTap: (){
                print('logout');
                setState(() {
                  Preferences.logout();
                  AppRouter.makeFirst(context, MyApp());
                });
              },
              child: Container(
                margin: EdgeInsets.only(right: 10),
                  child: Icon(Icons.exit_to_app)),
            )
          ],
        ),
        body: SingleChildScrollView(
          child: Center(
            child: Container(
              padding: EdgeInsets.all(16),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  DefaultText(
                    textLabel:
                        'TOTAL TABUNGAN: ${Helper.formatCurrencyIdr(widget.total.toString())}',
                    colorsText: Colors.blueGrey,
                  ),
                  TextField(
                    decoration: InputDecoration(hintText: 'Product Name'),
                    keyboardType: TextInputType.text,
                    controller: productNameController,
                  ),
                  TextField(
                    decoration: InputDecoration(hintText: 'Product Price'),
                    keyboardType: TextInputType.number,
                    controller: priceController,
                  ),
                  Container(
                    margin: EdgeInsets.only(top: 8),
                    width: MediaQuery.of(context).size.width,
                    decoration: BoxDecoration(
                        color: Colors.blueGrey,
                        borderRadius: BorderRadius.all(Radius.circular(8))),
                    child: GestureDetector(
                      onTap: () {
                        if (productNameController.text.isEmpty &&
                            priceController.text.isEmpty) {
                          Helper.showToast(context, 'Please fill the form',
                              gravity: Toast.BOTTOM);
                        } else {
                          isLoading = true;
                          setState(() {
                            date =
                                Helper.formatToDateTimetoString(DateTime.now());
                            int price = int.parse(priceController.text);
                            _insert(productNameController.text, price, date);
                            _queryAll();
                            priceController.clear();
                            productNameController.clear();
                            _date = '-';
                            Future.delayed(Duration(seconds: 1)).then((value) {
                              setState(() {
                                isLoading = false;
                              });
                            });
                          });
                        }
                      },
                      child: DefaultText(
                        padding: EdgeInsets.all(10),
                        textLabel: "SUBMIT",
                        colorsText: Colors.white,
                        alignment: Alignment.center,
                      ),
                    ),
                  ),
                  isLoading == true
                      ? Container(
                          margin: EdgeInsets.only(top: 50),
                          child: CircularProgressIndicator(),
                        )
                      : Column(children: [
                          Divider(
                            height: 20,
                            thickness: 2,
                            color: Colors.blueGrey.withOpacity(0.5),
                          ),
                          DefaultText(
                            alignment: Alignment.center,
                            textLabel: 'LIST PENGELUARAN',
                            colorsText: Colors.blueGrey,
                            fontWeight: FontWeight.bold,
                          ),
                          DefaultText(
                            alignment: Alignment.center,
                            textLabel:
                                'Sisa tabungan anda: ${Helper.formatCurrencyIdr(totalSisa.toString())}',
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              DefaultText(
                                margin: EdgeInsets.only(top: 8),
                                textLabel: _date,
                              ),
                              GestureDetector(
                                onTap: () => openDatePicker(),
                                child: Container(
                                    margin: EdgeInsets.only(top: 8),
                                    child: Icon(Icons.calendar_today_outlined)),
                              )
                            ],
                          ),
                          Container(
                              height: 700,
                              width: double.infinity,
                              child: ListView.builder(
                                  padding: EdgeInsets.all(3),
                                  itemCount: history.length + 1,
                                  itemBuilder:
                                      (BuildContext context, int index) {
                                    if (index == history.length) {
                                      return Container(
                                        margin: EdgeInsets.only(top: 20),
                                        decoration: BoxDecoration(
                                            color: Colors.blueGrey,
                                            borderRadius: BorderRadius.all(
                                                Radius.circular(8))),
                                        child: GestureDetector(
                                          onTap: () {
                                            setState(() {
                                              isLoading = true;
                                              Future.delayed(
                                                      Duration(seconds: 1))
                                                  .then((value) {
                                                setState(() {
                                                  isLoading = false;
                                                });
                                              });
                                              _queryAll();
                                              _date = '-';
                                            });
                                          },
                                          child: DefaultText(
                                            padding: EdgeInsets.all(10),
                                            textLabel: "REFRESH",
                                            colorsText: Colors.white,
                                            alignment: Alignment.center,
                                          ),
                                        ),
                                      );
                                    }
                                    return Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      children: [
                                        Container(
                                          padding: EdgeInsets.all(8),
                                          width:
                                              MediaQuery.of(context).size.width,
                                          margin: EdgeInsets.only(top: 20),
                                          decoration: BoxDecoration(
                                              boxShadow: [
                                                BoxShadow(
                                                  color: Colors.grey
                                                      .withOpacity(0.3),
                                                  offset: const Offset(
                                                    5.0,
                                                    5.0,
                                                  ),
                                                  blurRadius: 4.0,
                                                  spreadRadius: 2.0,
                                                ), //BoxShadow
                                                BoxShadow(
                                                  color: Colors.white,
                                                  offset:
                                                      const Offset(0.0, 0.0),
                                                  blurRadius: 0.0,
                                                  spreadRadius: 0.0,
                                                ), //BoxShadow
                                              ],
                                              color:
                                                  Colors.grey.withOpacity(0.2),
                                              borderRadius:
                                                  BorderRadius.circular(2),
                                              border: Border.all(
                                                  color: Colors.grey
                                                      .withOpacity(0.5))),
                                          child: Row(
                                            mainAxisSize: MainAxisSize.max,
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: [
                                              CircleAvatar(
                                                foregroundColor: Colors.white,
                                                backgroundColor:
                                                    Colors.blueGrey,
                                                maxRadius: 10,
                                                child: DefaultText(
                                                    textLabel: '${index + 1}'),
                                              ),
                                              // Text('${history[index].productName} ${history[index].price} ${history[index].date}')
                                              Container(
                                                child: Column(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.start,
                                                  children: [
                                                    DefaultText(
                                                        textLabel:
                                                            '${history[index].productName}'),
                                                    DefaultText(
                                                        textLabel: Helper
                                                            .formatCurrencyIdr(
                                                                history[index]
                                                                    .price
                                                                    .toString()))
                                                  ],
                                                ),
                                              ),
                                              GestureDetector(
                                                onTap: () {
                                                  isLoading = true;
                                                  setState(() {
                                                    _delete(history[index].id);
                                                    hitung();
                                                    Future.delayed(Duration(
                                                            seconds: 1))
                                                        .then((value) {
                                                      setState(() {
                                                        isLoading = false;
                                                      });
                                                    });
                                                    _queryAll();
                                                  });
                                                },
                                                child: Container(
                                                    alignment:
                                                        Alignment.centerRight,
                                                    child: Icon(Icons.cancel,
                                                        color: Colors.red)),
                                              )
                                            ],
                                          ),
                                        )
                                      ],
                                    );
                                  })),
                        ])
                ],
              ),
            ),
          ),
        ));
  }

  //add
  void _insert(productName, price, date) async {
    // row to insert
    Map<String, dynamic> row = {
      DatabaseHelper.columnProductName: productName,
      DatabaseHelper.columnPrice: price,
      DatabaseHelper.columnDate: date
    };
    hitung();
    History history = History.fromMap(row);
    final id = await dbHelper.insert(history);
    _showMessageInScaffold('inserted row id: $id');
  }

  //getall
  void _queryAll() async {
    final allRows = await dbHelper.queryAllRows();
    history.clear();
    hitung();
    allRows.forEach((row) => history.add(History.fromMap(row)));
    _showMessageInScaffold('Query done.');
    setState(() {});
  }

  //deletebyid
  void _delete(id) async {
    // Assuming that the number of rows is the id for the last row.
    final rowsDeleted = await dbHelper.delete(id);
    history.forEach((element) {
      totalSisa += element.price;
    });
    _showMessageInScaffold('deleted $rowsDeleted row(s): row $id');
  }

  //filter by date
  void _query(date) async {
    final allRows = await dbHelper.queryRows(date);
    history.clear();
    allRows.forEach((row) => history.add(History.fromMap(row)));
    setState(() {});
  }

  void hitung() async {
    final allRows = await dbHelper.queryAllRows();
    totalPengeluaran = 0;
    history.clear();
    allRows.forEach((element) {
      history.add(History.fromMap(element));
    });
    history.forEach((element) {
      setState(() {
        // ignore: unnecessary_statements
        totalPengeluaran += element.price;
        totalSisa = int.parse(widget.total) - totalPengeluaran;
        if (element.price == null) {
          totalSisa = int.parse(widget.total);
        }
      });
    });
  }

  void openDatePicker() {
    setState(() {
      print('openCalendar');
      DatePicker.showDatePicker(context,
          showTitleActions: true, locale: LocaleType.id, onChanged: (date) {
            _date = Helper.formatToDateTimetoString(date);
            print('confirm $_date');
            _query(_date);
            setState(() {});
      }, onConfirm: (date) {
        setState(() {
          isLoading = true;
        });
        Future.delayed(Duration(seconds: 1)).then((value) {
          setState(() {
            isLoading = false;
            _date = Helper.formatToDateTimetoString(date);
            print('confirm $_date');
            _query(_date);
            setState(() {});
          });
        });
      }, currentTime: DateTime.now());
    });
  }
}