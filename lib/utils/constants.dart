import 'dart:math';
import 'package:hive/hive.dart';

String getRandom(int length){
  const ch = 'AaBbCcDdEeFfGgHhIiJjKkLlMmNnOoPpQqRrSsTtUuVvWwXxYyZz';
  Random r = Random();
  return String.fromCharCodes(Iterable.generate(
      length, (_) => ch.codeUnitAt(r.nextInt(ch.length))));
}

late Box boxCarts;
late Box boxFavourites;
String profilePic = getRandom(5);
const url = "http://192.168.8.101:3000/";
const saveUserUrl = "${url}save-user";
const saveOrderUrl = "${url}save-order";
const retrieveUserUrl = "${url}retrieve-user";
const retrieveAllProductUrl = "${url}get-all-product";
const retrieveCategoryProductUrl = "${url}get-category-product";
const retrieveTitleProductUrl = "${url}get-title-product";
const retrieveAllDiscountProductUrl = "${url}get-all-discount-product";
const retrieveTitleDiscountProductUrl = "${url}get-title-discount-product";
const updateUserAddress = "${url}update-user-address";
const retrieveAllKeysUrl = "${url}get-all-keys";
const updateFcmKeyUrl = "${url}update-fcm-key";
const deleteUserUrl = "${url}delete-user";
const fcmUrl = "https://fcm.googleapis.com/v1/projects/temispecial-1034b/messages:send";