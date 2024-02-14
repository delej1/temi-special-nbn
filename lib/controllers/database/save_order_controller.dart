import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:temi_special_flutter/utils/constants.dart';

class SaveOrderController extends GetxController{
  saveData(userId,address,cart,email,name,orderAmount,orderRef,orderStatus,phone) async{
    var reqBody = {
      "user_id": userId,
      "address": address,
      "cart": cart,
      "email": email,
      "name": name,
      "order_amount": orderAmount,
      "order_ref": orderRef,
      "order_status": orderStatus,
      "phone": phone,
    };
    try {
      http.Response response = await http.post(Uri.parse(saveOrderUrl),
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