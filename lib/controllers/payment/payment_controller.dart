import 'dart:convert';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter_paystack/flutter_paystack.dart';
import 'package:get/get.dart';
import 'package:temi_special_flutter/controllers/database/save_order_controller.dart';
import 'package:temi_special_flutter/utils/constants.dart';
import 'package:temi_special_flutter/utils/dimensions.dart';
import 'package:temi_special_flutter/widgets/custom_snackbar.dart';
import 'package:http/http.dart' as http;


bool isSuccessful = false;

const _chars = 'AaBbCcDdEeFfGgHhIiJjKkLlMmNnOoPpQqRrSsTtUuVvWwXxYyZz1234567890';
Random _rnd = Random();
String getRandomString(int length) => String.fromCharCodes(Iterable.generate(
    length, (_) => _chars.codeUnitAt(_rnd.nextInt(_chars.length))));

final plugin = PaystackPlugin();
String reference = getRandomString(10);

class PaymentController extends GetConnect implements GetxService{
  PaymentController({
    required this.ctx,
    required this.email,
    required this.secretKey,
    required this.userToken,
    required this.fcmKey,
    required this.userId,
    required this.address,
    required this.cart,
    required this.name,
    required this.orderAmount,
    required this.orderStatus,
    required this.phone,
  });
  BuildContext ctx;
  String email;
  String secretKey;
  String userToken;
  String fcmKey;
  String userId;
  String address;
  List<Map> cart;
  String name;
  int orderAmount;
  String orderStatus;
  int phone;

  PaymentCard _getCardUI(){
    return PaymentCard(
        number: "",
        cvc: "",
        expiryMonth: 0,
        expiryYear: 0,
    );
  }

  Future chargeCard() async{
    Charge charge = Charge()
      ..amount = orderAmount * 100
      ..email = email
      ..reference = reference
      ..card = _getCardUI();
    CheckoutResponse response = await plugin.checkout(
        ctx,
        charge: charge,
        method: CheckoutMethod.card,
        fullscreen: false,
        logo: ClipRRect(
            borderRadius: BorderRadius.circular(Dimensions.radius30),
            child: Image.asset("asset/image/temi_special_logo.png", fit: BoxFit.cover,
              height: Dimensions.height10*5,
              width: Dimensions.width10*5,))
    );

    if(response.status == true){
      isSuccessful = true;
      verifyPayment();
    }else{
      isSuccessful = false;
      showCustomSnackBar("Payment failed, please try again");
    }
  }

  Future<Response> verifyPayment() async {
        try {
          Response response = await get(
              'https://api.paystack.co/transaction/verify/$reference',
              headers: {
                'Authorization': 'Bearer $secretKey',
              });
          Map result = response.body;
          if(result["status"] == true){
            try{
              //send order data to mongodb
              SaveOrderController().saveData(
                  userId,
                  address,
                  cart,
                  email,
                  name,
                  orderAmount,
                  reference,
                  orderStatus,
                  phone
              );
              sendPushMessage();
            }catch(e){showCustomSnackBar(e.toString());}
            reference = getRandomString(10);
          }
          return response;
        } catch (e) {
          return Response(statusCode: 1, statusText: e.toString());
        }
    }

    sendPushMessage() async{
    try{
      await http.post(
          Uri.parse(fcmUrl),
          headers: <String, String>{
            'Content-Type': 'application/json',
            'Authorization':'Bearer $fcmKey',
          },
          body: jsonEncode(<String, dynamic>{
            "message":{
              "token": userToken,
              "notification":{
                "body":"Your order of ₦$orderAmount has been placed successfully, you will receive a call shortly.",
                "title":"Order Success"
              }
            }
          })
      );
      showCustomSnackBar(title: "Status", "Transaction successful, thank you");
    }catch(e){
      debugPrint(e.toString());
    }
  }
}