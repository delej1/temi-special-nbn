import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:temi_special_flutter/utils/dimensions.dart';

void showCustomSnackBar(String message, {bool isError = true, String title = ''}){
  Get.snackbar(title, message,
    titleText: Center(child: Text(title, style: TextStyle(color: Colors.white, fontSize: Dimensions.font20),)),
    messageText: Center(
      child: Text(message, textAlign: TextAlign.center,
        style: TextStyle(color: Colors.white, fontSize: Dimensions.font16),
      ),
    ),
    colorText: Colors.white,
    snackPosition: SnackPosition.BOTTOM,
    backgroundColor: Colors.black,
    dismissDirection: DismissDirection.vertical,
    isDismissible: true,
    duration: const Duration(seconds: 2),
    maxWidth: Dimensions.width100*2.5,
    borderRadius: Dimensions.width5,
  );
}