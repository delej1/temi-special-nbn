import 'dart:convert';
import 'package:fancy_shimmer_image/fancy_shimmer_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:temi_special_flutter/cart/cart.dart';
import 'package:temi_special_flutter/utils/colors.dart';
import 'package:temi_special_flutter/utils/constants.dart';
import 'package:temi_special_flutter/utils/dimensions.dart';
import 'package:temi_special_flutter/widgets/button_widget.dart';
import 'package:temi_special_flutter/widgets/custom_loader.dart';
import 'package:temi_special_flutter/widgets/custom_snackbar.dart';
import 'package:temi_special_flutter/widgets/edit_cart_widget.dart';
import 'package:http/http.dart' as http;

class SearchItemPage extends StatefulWidget {
  const SearchItemPage({Key? key}) : super(key: key);

  @override
  State<SearchItemPage> createState() => _SearchItemPageState();
}

class _SearchItemPageState extends State<SearchItemPage> {

  String itemTitle = Get.arguments;
  List prod = [];
  List discountProd = [];
  bool isLoading = true;
  int count = 0;

  void retrieveData(title) async{
    setState(() {
      isLoading = true;
    });
    var reqBody = {
      "title": title,
    };
    try {
      http.Response response = await http.post(Uri.parse(retrieveTitleProductUrl),
        headers: {"Content-Type":"application/json"},
        body: jsonEncode(reqBody),
      );
      if (response.statusCode == 200) {
        var jsonResponse = jsonDecode(response.body);
        if(jsonResponse['status']){
          prod = jsonResponse['message'];
        }
      } else {
        debugPrint("Error fetching data");
      }
    } catch (e) {
      debugPrint("Error $e getting while fetching data");
    }finally{
      setState(() {
        isLoading = false;
      });
    }
  }

  void retrieveDiscountData(title) async{
    setState(() {
      isLoading = true;
    });
    var reqBody = {
      "title": title,
    };
    try {
      http.Response response = await http.post(Uri.parse(retrieveTitleDiscountProductUrl),
        headers: {"Content-Type":"application/json"},
        body: jsonEncode(reqBody),
      );
      if (response.statusCode == 200) {
        var jsonResponse = jsonDecode(response.body);
        if(jsonResponse['status']){
          discountProd = jsonResponse['message'];
        }
      } else {
        debugPrint("Error fetching data");
      }
    } catch (e) {
      debugPrint("Error $e getting while fetching data");
    }finally{
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  void initState() {
    super.initState();
    retrieveData(itemTitle);
    retrieveDiscountData(itemTitle);
  }


  @override
  Widget build(BuildContext context) {
    return isLoading?const CustomLoader():Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.grey.shade100,
        automaticallyImplyLeading: false,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: Colors.black),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: Center(child: Text(prod.isEmpty?discountProd[0]["title"]:prod[0]["title"], style: const TextStyle(color: Colors.black, fontWeight: FontWeight.bold),)),
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
                      imageUrl: prod.isEmpty?discountProd[0]["image"]:prod[0]["image"],
                      width: Dimensions.width100*2.5,
                      height: Dimensions.height100*2.5,
                    ),
                  ),
                ),
              ),
              Padding(
                padding: EdgeInsets.all(Dimensions.width10),
                child: Text(prod.isEmpty?discountProd[0]["title"]:prod[0]["title"],
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
                          child: Text(prod.isEmpty?discountProd[0]["rating"]:prod[0]["rating"],
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
                          child: Text(prod.isEmpty?discountProd[0]["prep_time"]:prod[0]["prep_time"],
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
                    child: Text(prod.isEmpty?discountProd[0]["desc"]:prod[0]["desc"],
                      style: TextStyle(color: Colors.black, fontSize: Dimensions.font20),),
                  ),
                ),
              ),
              Padding(
                padding: EdgeInsets.all(Dimensions.width10),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text("N ${prod.isEmpty?discountProd[0]["price"]:prod[0]["price"]}",
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
              Center(child: ButtonWidget(onTap:(){
                if(count!=0){
                  setState(() {
                    boxCarts.put(
                        "key_${prod.isEmpty?discountProd[0]["title"]:prod[0]["title"]}",
                        Cart(
                            image: prod.isEmpty?discountProd[0]["image"]:prod[0]["image"],
                            title: prod.isEmpty?discountProd[0]["title"]:prod[0]["title"],
                            quantity: count,
                            price: prod.isEmpty?discountProd[0]["price"]:prod[0]["price"]
                        )
                    );
                  });
                  showCustomSnackBar("Item added to cart successfully");
                }else{showCustomSnackBar("Add at least one item");}
              }, buttonText: "Add to Cart"))
            ],
          ),
        ),
      ),
    );
  }
}
