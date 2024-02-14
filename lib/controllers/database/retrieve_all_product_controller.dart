import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:temi_special_flutter/utils/constants.dart';


class RetrieveAllProductController extends GetxController{
  var isLoading = true.obs;
  List cat = [];
  List item = [];

  @override
  Future<void> onInit() async {
    super.onInit();
    retrieveData();
  }

  retrieveData() async{
    try {
      http.Response response = await http.get(Uri.parse(retrieveAllProductUrl),
        headers: {"Content-Type":"application/json"},
      );

      if (response.statusCode == 200) {
        var jsonResponse = jsonDecode(response.body);
        if(jsonResponse['status']){
          var i = 0;
          List prod = jsonResponse['message'];
          for (i;i<prod.length;i++){
            cat.add(prod[i]["category"]);
            item.add(prod[i]["title"]);
          }
        }
      } else {
        debugPrint("Error fetching data");
      }
    } catch (e) {
      debugPrint("Error $e getting while fetching data");
    }finally{
      isLoading(false);
    }
  }
}