import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:temi_special_flutter/controllers/database/delete_user_controller.dart';
import 'package:temi_special_flutter/controllers/database/retrieve_user_controller.dart';
import 'package:temi_special_flutter/controllers/database/save_user_controller.dart';
import 'package:temi_special_flutter/utils/constants.dart';
import 'package:temi_special_flutter/views/home/home_page.dart';
import 'package:temi_special_flutter/widgets/custom_snackbar.dart';

class AuthController extends GetxController{
  static AuthController instance = Get.find();
  FirebaseAuth auth = FirebaseAuth.instance;

  var isLoading = false.obs;
  var isGoogleSignInLoading = false;

  void register(email, password, name, phone) async{
    try{
      isLoading(true);
      await auth.createUserWithEmailAndPassword(email: email, password: password)
          .then((value) => SaveUserController().saveData(name, email, phone))
          .then((value) => RetrieveUserController().retrieveData(email))
          .then((value) => Get.toNamed("/"));
    }catch(e){
      showCustomSnackBar(e.toString());
    }finally{
      isLoading(false);
    }
  }

  void signIn(String email, password) async{
    try{
      isLoading(true);
      await auth.signInWithEmailAndPassword(email: email, password: password)
          .then((value) => RetrieveUserController().retrieveData(email))
          .then((value) => Get.toNamed("/"));
    }catch(e){
      showCustomSnackBar(e.toString());
    }finally{
      isLoading(false);
    }
  }

  void resetPassword(String email) async{
    try{
      isLoading(true);
      await auth.sendPasswordResetEmail(email: email);
      showCustomSnackBar(title: "Success", "Password reset sent successfully");
    }catch(e){
      showCustomSnackBar(e.toString());
    }finally{
      isLoading(false);
    }
  }

  void delete(password, id, ctx) async{
    try{
      await auth.currentUser!.reauthenticateWithCredential(
        EmailAuthProvider.credential(
          email: auth.currentUser!.email!,
          password: password,
        ),
      ).then((value){
        Navigator.of(ctx).pop();
        auth.currentUser!.delete();
        DeleteUserController().deleteData(id);
        boxCarts.clear();
        boxFavourites.clear();
        showCustomSnackBar("Account deleted successfully");
        signOut();
      });
    }catch(e){
      showCustomSnackBar(e.toString());
    }
  }

  void signOut() async{
    await auth.signOut();
    Get.offAll(()=>const HomePage());
  }

}

