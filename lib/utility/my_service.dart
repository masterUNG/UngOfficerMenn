import 'package:shared_preferences/shared_preferences.dart';

class MyService {
  Future<List<String>> findDatas() async {
    var results = <String>[];

    SharedPreferences preferences = await SharedPreferences.getInstance();
    results = preferences.getStringList('data')!;


    return results;
  }
}
