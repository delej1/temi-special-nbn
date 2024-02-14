import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:temi_special_flutter/utils/constants.dart';

class UpdateFcmController extends GetxController{
  late SharedPreferences prefs;

  Future<void> getPrefs()async {
    prefs = await SharedPreferences.getInstance();
  }


  updateData(oldKey) async{
    getPrefs().then((value) async{
      var reqBody = {
        "old_key": oldKey,
      };
      try {
        http.Response response = await http.post(Uri.parse(updateFcmKeyUrl),
          headers: {"Content-Type":"application/json"},
          body: jsonEncode(reqBody),
        );

        if (response.statusCode == 200) {
          var jsonResponse = jsonDecode(response.body);
          if(jsonResponse['status']){
            await prefs.setString('fcm_key', jsonResponse['message']['fcm_key']);
          }
        } else {
          debugPrint("Error fetching data");
        }
      } catch (e) {
        debugPrint("Error $e getting while fetching data");
      }
    });
  }
}