import 'package:shared_preferences/shared_preferences.dart';

class Preferences {

  static String Key_id = "id";
  static String Key_tabungan = "tabungan";

  static void setId(String id) async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    await pref.setString(Key_id, id);
  }

  static Future<String> getId() async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    return '${pref.getString(Key_id)}';
  }

  static void setTabungan(String tabungan) async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    await pref.setString(Key_tabungan, tabungan);
  }

  static Future<String> getTabungan() async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    return '${pref.getString(Key_tabungan)}';
  }

  static void logout() async{
    setId('');
    setTabungan('');
  }

}