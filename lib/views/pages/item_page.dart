import 'package:fancy_shimmer_image/fancy_shimmer_image.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:temi_special_flutter/cart/cart.dart';
import 'package:temi_special_flutter/favourite/favourite.dart';
import 'package:temi_special_flutter/utils/colors.dart';
import 'package:temi_special_flutter/utils/constants.dart';
import 'package:temi_special_flutter/utils/dimensions.dart';
import 'package:temi_special_flutter/widgets/button_widget.dart';
import 'package:temi_special_flutter/widgets/custom_snackbar.dart';
import 'package:temi_special_flutter/widgets/edit_cart_widget.dart';

class ItemPage extends StatefulWidget {
  const ItemPage({Key? key}) : super(key: key);

  @override
  State<ItemPage> createState() => _ItemPageState();
}

class _ItemPageState extends State<ItemPage> {

  List<dynamic> itemDetails = Get.arguments;
  int count = 0;
  FirebaseAuth auth = FirebaseAuth.instance;

  void addFav(){
    setState(() {
      boxFavourites.put(
          "key_${itemDetails[1]}",
          Favourite(
            image: itemDetails[0],
            title: itemDetails[1],
          )
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.grey.shade100,
        automaticallyImplyLeading: false,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: Colors.black),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: Center(child: Text(itemDetails[1], style: const TextStyle(color: Colors.black, fontWeight: FontWeight.bold),)),
      ),
      body: Padding(
        padding: EdgeInsets.all(Dimensions.width10),
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: Dimensions.screenWidth,
                height: Dimensions.screenHeight*0.3,
                color: Colors.grey.shade100,
                child: Padding(
                  padding: EdgeInsets.all(Dimensions.width10),
                  child: Center(
                    child: FancyShimmerImage(
                      imageUrl: itemDetails[0],
                      width: Dimensions.width100*2.5,
                      height: Dimensions.height100*2.5,
                    ),
                  ),
                ),
              ),
              Padding(
                padding: EdgeInsets.all(Dimensions.width10),
                child: Text(itemDetails[1],
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(color: Colors.black,
                      fontWeight: FontWeight.bold, fontSize: Dimensions.font26),),
              ),
              Padding(
                padding: EdgeInsets.all(Dimensions.width10),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        const Icon(Icons.location_on_outlined, color: AppColors.blueColor,),
                        SizedBox(width: Dimensions.width1*2,),
                        SizedBox(
                          width: Dimensions.width50,
                          child: Text("Abuja", style: TextStyle(color: Colors.black,
                              fontSize: Dimensions.font16),),
                        )
                      ],),
                    Row(
                      children: [
                        Icon(Icons.star, color: Colors.yellow.shade400),
                        SizedBox(width: Dimensions.width1*2,),
                        SizedBox(
                          width: Dimensions.width50,
                          child: Text(itemDetails[3],
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(color: Colors.black,
                                fontSize: Dimensions.font16),),
                        )
                      ],
                    ),
                    Row(
                      children: [
                        Icon(Icons.access_time_outlined, color: Colors.red.shade400),
                        SizedBox(width: Dimensions.width1*2,),
                        SizedBox(
                          width: Dimensions.width50,
                          child: Text(itemDetails[2],
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(color: Colors.black,
                                fontSize: Dimensions.font16),),
                        )
                      ],
                    ),
                  ],
                ),
              ),
              Padding(
                padding: EdgeInsets.all(Dimensions.width10),
                child: Text("Description",
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(fontWeight: FontWeight.bold, color: Colors.black, fontSize: Dimensions.font20),),
              ),
              Container(
                width: Dimensions.screenWidth,
                height: Dimensions.screenHeight*0.20,
                color: Colors.grey.shade100,
                child: SingleChildScrollView(
                  physics: const BouncingScrollPhysics(),
                  child: Padding(
                    padding: EdgeInsets.all(Dimensions.width10),
                    child: Text(itemDetails[5],
                      style: TextStyle(color: Colors.black, fontSize: Dimensions.font20),),
                  ),
                ),
              ),
              Padding(
                padding: EdgeInsets.all(Dimensions.width10),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text("N ${itemDetails[4].toString()}",
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(color: Colors.black,
                          fontWeight: FontWeight.bold, fontSize: Dimensions.font26),),
                    EditCartWidget(
                      addCart: (){if(count<10){setState(() {count++;});}},
                      removeCart: (){if(count!=0){setState(() {count--;});}},
                      count: count,
                    ),
                  ],
                ),
              ),
              Center(child: ButtonWidget(
                  onTap:(){
                    if(count!=0){
                      setState(() {
                        boxCarts.put(
                            "key_${itemDetails[1]}",
                            Cart(
                                image: itemDetails[0],
                                title: itemDetails[1],
                                quantity: count,
                                price: itemDetails[4]
                            )
                        );
                      });
                      showCustomSnackBar("Item added to cart successfully");
                    }else{showCustomSnackBar("Add at least one item");}
                  },
                  buttonText: "Add to Cart"))
            ],
          ),
        ),
      ),
    );
  }
}
