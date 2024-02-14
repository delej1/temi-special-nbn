import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:temi_special_flutter/utils/constants.dart';


class RetrieveAllKeysController extends GetxController{
  late SharedPreferences prefs;
  List pub = [];
  List sec = [];
  List map = [];

  Future<void> getPrefs()async {
    prefs = await SharedPreferences.getInstance();
  }

  @override
  Future<void> onInit() async {
    super.onInit();
    retrieveData();
  }

  retrieveData() async{
    getPrefs().then((value) async{
      try {
        http.Response response = await http.get(Uri.parse(retrieveAllKeysUrl),
          headers: {"Content-Type":"application/json"},
        );

        if (response.statusCode == 200) {
          var jsonResponse = jsonDecode(response.body);
          if(jsonResponse['status']){
            var i = 0;
            List prod = jsonResponse['message'];
            for (i;i<prod.length;i++){
              pub.add(prod[i]["paystack_public"]);
              sec.add(prod[i]["paystack_secret"]);
              map.add(prod[i]["map_key"]);
              await prefs.setString('fcm_key', prod[i]["fcm_key"]);
            }
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