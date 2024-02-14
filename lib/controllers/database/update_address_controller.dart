import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:temi_special_flutter/utils/constants.dart';

class UpdateAddressController extends GetxController{
  updateData(id,address) async{
    var reqBody = {
      "id": id,
      "address": address,
    };
    try {
      http.Response response = await http.post(Uri.parse(updateUserAddress),
        headers: {"Content-Type":"application/json"},
        body: jsonEncode(reqBody),
      );

      if (response.statusCode == 200) {
        var jsonResponse = jsonDecode(response.body);
        if(jsonResponse['status']){
          debugPrint(jsonResponse['message'].toString());
        }
      } else {
        debugPrint("Error fetching data");
      }
    } catch (e) {
      debugPrint("Error $e getting while fetching data");
    }
  }
}