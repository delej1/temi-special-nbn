import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_places_flutter/google_places_flutter.dart';
import 'package:google_places_flutter/model/prediction.dart';
import 'package:jwt_decoder/jwt_decoder.dart';
import 'package:random_avatar/random_avatar.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:temi_special_flutter/controllers/auth/auth_controller.dart';
import 'package:temi_special_flutter/controllers/database/retrieve_keys_controller.dart';
import 'package:temi_special_flutter/controllers/database/retrieve_user_controller.dart';
import 'package:temi_special_flutter/controllers/database/update_address_controller.dart';
import 'package:temi_special_flutter/utils/colors.dart';
import 'package:temi_special_flutter/utils/constants.dart';
import 'package:temi_special_flutter/utils/dimensions.dart';
import 'package:temi_special_flutter/widgets/button_widget.dart';
import 'package:temi_special_flutter/widgets/custom_snackbar.dart';
import 'package:temi_special_flutter/widgets/form_field_widget.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({Key? key}) : super(key: key);

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> with AutomaticKeepAliveClientMixin {

  @override
  bool get wantKeepAlive => false;

  FirebaseAuth auth = FirebaseAuth.instance;
  List mapKey = Get.find<RetrieveAllKeysController>().map;

  late SharedPreferences prefs;
  bool isLoading = true;
  String id = "";
  String name = "";
  String email = "";
  String dbAddress = "";
  String updatedAddress = "";
  TextEditingController locationController = TextEditingController();
  TextEditingController deleteAccController = TextEditingController();

  Future<void> getPrefs()async {
    prefs = await SharedPreferences.getInstance();
  }

  void retrieveInfo(){
    try{
      Map<String, dynamic> jwtDecodedToken = JwtDecoder.decode(prefs.getString('user_token')!);
      id = jwtDecodedToken['_id'];
      name = jwtDecodedToken['name'];
      email = jwtDecodedToken['email'];
      dbAddress = jwtDecodedToken['address'];
    }catch(e){
      rethrow;
    }finally{
      setState(() {
        isLoading = false;
      });
    }
  }

  Future<void> updateAddress(id, address) async{
    UpdateAddressController().updateData(id, address);
  }

  @override
  void initState() {
    super.initState();
    getPrefs().then((value){retrieveInfo();});
    locationController.text = "";
    deleteAccController.text = "";
  }

  @override
  void dispose() {
    locationController.dispose();
    deleteAccController.dispose();
    super.dispose();
  }


  @override
  Widget build(BuildContext context) {
    super.build(context);
    return auth.currentUser==null?
    Center(child: ButtonWidget(onTap: (){Get.toNamed('/sign-in');}, buttonText:"Sign In")) :Scaffold(
      extendBodyBehindAppBar: true,
      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        child: Column(
          children: [
            SizedBox(
              height: Dimensions.height56*5,
              child: Stack(
                children: [
                  Image.asset(
                    "asset/image/header_image.jpeg",
                  ),
                  Positioned(
                    top: Dimensions.height56*2.7,
                      left: Dimensions.screenWidth/2.5,
                      child: RandomAvatar(profilePic, width: Dimensions.width50*2)
                  ),
                ],
              ),
            ),
            SizedBox(
                width: Dimensions.width350,
                child: Center(
                  child: Text(name, maxLines: 1, overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      fontSize: Dimensions.font26,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                )),
            SizedBox(height: Dimensions.height45,),
            Container(
              width: Dimensions.screenWidth*0.8,
              color: Colors.grey.shade100,
              child: Column(
                children: [
                  GestureDetector(
                    onTap: (){
                      Get.toNamed('/favourite-item-page');
                    },
                    child: Card(
                      child: Padding(
                        padding: EdgeInsets.all(Dimensions.width10),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Row(
                              children: [
                                Icon(Icons.favorite_outline, size: Dimensions.iconSize24),
                                SizedBox(width: Dimensions.width10),
                                Text("Favourites", style: TextStyle(fontSize: Dimensions.font20),),
                              ],
                            ),
                            Icon(Icons.arrow_forward_ios, size: Dimensions.iconSize16,),
                          ],
                        ),
                      ),
                    ),
                  ),
                  GestureDetector(
                    onTap: (){
                      showLocationDialogue();
                    },
                    child: Card(
                      child: Padding(
                        padding: EdgeInsets.all(Dimensions.width10),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Row(
                              children: [
                                Icon(Icons.location_on_outlined, size: Dimensions.iconSize24),
                                SizedBox(width: Dimensions.width10),
                                Text("Location", style: TextStyle(fontSize: Dimensions.font20),),
                              ],
                            ),
                            Icon(Icons.arrow_forward_ios, size: Dimensions.iconSize16,),
                          ],
                        ),
                      ),
                    ),
                  ),
                  GestureDetector(
                    onTap: (){},
                    child: Card(
                      child: Padding(
                        padding: EdgeInsets.all(Dimensions.width10),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Row(
                              children: [
                                Icon(Icons.history, size: Dimensions.iconSize24),
                                SizedBox(width: Dimensions.width10),
                                Text("History", style: TextStyle(fontSize: Dimensions.font20),),
                              ],
                            ),
                            Icon(Icons.arrow_forward_ios, size: Dimensions.iconSize16,),
                          ],
                        ),
                      ),
                    ),
                  ),
                  GestureDetector(
                    onTap: (){},
                    child: Card(
                      child: Padding(
                        padding: EdgeInsets.all(Dimensions.width10),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Row(
                              children: [
                                Icon(Icons.question_mark, size: Dimensions.iconSize24),
                                SizedBox(width: Dimensions.width10),
                                Text("About", style: TextStyle(fontSize: Dimensions.font20),),
                              ],
                            ),
                            Icon(Icons.arrow_forward_ios, size: Dimensions.iconSize16,),
                          ],
                        ),
                      ),
                    ),
                  ),
                  GestureDetector(
                    onTap: (){
                      showDeleteAccDialogue();
                    },
                    child: SizedBox(
                      width: Dimensions.screenWidth*0.8,
                      child: Card(
                        child: Padding(
                          padding: EdgeInsets.all(Dimensions.width10),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Row(
                                children: [
                                  Icon(Icons.delete_forever, size: Dimensions.iconSize24),
                                  SizedBox(width: Dimensions.width10),
                                  Text("Delete Account", style: TextStyle(fontSize: Dimensions.font20),),
                                ],
                              ),
                              Icon(Icons.arrow_forward_ios, size: Dimensions.iconSize16,),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: Dimensions.height45,),
            GestureDetector(
              onTap: (){
                AuthController().signOut();
              },
              child: SizedBox(
                width: Dimensions.screenWidth*0.8,
                child: Card(
                  child: Padding(
                    padding: EdgeInsets.all(Dimensions.width10),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
                            Icon(Icons.power_settings_new, size: Dimensions.iconSize24, color: Colors.redAccent,),
                            SizedBox(width: Dimensions.width10),
                            Text("Logout", style: TextStyle(fontSize: Dimensions.font20),),
                          ],
                        ),
                        Icon(Icons.arrow_forward_ios, size: Dimensions.iconSize16,),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void showLocationDialogue() {
    showDialog(context: context, builder: (context) => AlertDialog(
      content: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        child: GooglePlaceAutoCompleteTextField(
          textEditingController: locationController,
          googleAPIKey: mapKey[0],
          inputDecoration: InputDecoration(
            hintText: dbAddress!=""?dbAddress:"Update Location",
            border: InputBorder.none,
          ),
          countries: const ["ng"],
          itemClick: (Prediction prediction) {
            locationController.text=prediction.description!;
            locationController.selection = TextSelection.fromPosition(TextPosition(offset: prediction.description!.length));
            updatedAddress = prediction.description!;
          },
          itemBuilder: (context, index, Prediction prediction) {
            return Container(
              padding: EdgeInsets.all(Dimensions.width10),
              child: Row(
                children: [
                  const Icon(Icons.location_on),
                  SizedBox(
                    width: Dimensions.width10,
                  ),
                  Expanded(child: Text(prediction.description??""))
                ],
              ),
            );
          },
          seperatedBuilder: const Divider(),
          isCrossBtnShown: true,
        ),
      ),
      actions: [
        ElevatedButton(
          onPressed: () {
            Navigator.pop(context);
            locationController.clear();
          },
          style: ElevatedButton.styleFrom(
            backgroundColor: AppColors.mainColor,
          ),
          child: const Text('Close'),
        ),
        ElevatedButton(
          onPressed: () {
            if(updatedAddress!=""){
              setState(() {
                updateAddress(id, updatedAddress).then((value) => RetrieveUserController().retrieveData(email));
              });
              showCustomSnackBar("Location updated successfully");
              Navigator.pop(context);
              locationController.clear();
            }else{showCustomSnackBar("Kindly select location");}
          },
          style: ElevatedButton.styleFrom(
            backgroundColor: AppColors.mainColor,
          ),
          child: const Text('Update'),
        ),
      ],
    ));
  }

  void showDeleteAccDialogue() {
    showDialog(context: context, builder: (context) => AlertDialog(
      title: const Text("Delete Account", style: TextStyle(color: Colors.black),),
      content: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          child: Column(
            children: [
              Text("Enter password to delete account",
                style: TextStyle(fontSize: Dimensions.font14),),
              FormFieldWidget(
                subject: "Password",
                textEditingController: deleteAccController,
                icon: const Icon(Icons.visibility_off_outlined),
                isObscure: true,
              ),
            ],
          )
      ),
      actions: [
        ElevatedButton(
          onPressed: (){
            Navigator.of(context).pop();
          },
          style: ElevatedButton.styleFrom(
            backgroundColor: AppColors.mainColor,
          ),
          child: const Text('Cancel'),
        ),
        ElevatedButton(
          onPressed: () async{
            if(deleteAccController.text.isNotEmpty){
              AuthController().delete(deleteAccController.text,id,context);
            }else{showCustomSnackBar("Enter your password");}
          },
          style: ElevatedButton.styleFrom(
            backgroundColor: AppColors.mainColor,
          ),
          //return false when click on "NO"
          child: const Text('Delete'),
        ),
      ],
    ));
  }
}
