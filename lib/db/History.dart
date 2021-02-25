import 'DatabaseHelper.dart';

class History {
  int id;
  String productName;
  int price;
  String date;

  History({this.id, this.productName, this.price, this.date});

  History.fromMap(Map<String, dynamic> map) {
    id = map['id'];
    productName = map['productName'];
    price = map['price'];
    date = map['date'];
  }

  Map<String, dynamic> toMap() {
    return {
      DatabaseHelper.columnId: id,
      DatabaseHelper.columnProductName: productName,
      DatabaseHelper.columnPrice: price,
      DatabaseHelper.columnDate: date,
    };
  }
}