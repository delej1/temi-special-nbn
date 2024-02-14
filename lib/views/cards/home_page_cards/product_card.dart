import 'package:fancy_shimmer_image/fancy_shimmer_image.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:temi_special_flutter/utils/dimensions.dart';
import 'package:temi_special_flutter/widgets/custom_snackbar.dart';


class ProductCard extends StatefulWidget {
  final String image;
  final String title;
  final String prepTime;
  final String rating;
  final int price;
  final Function() onTap;
  final Function() onFav;
  const ProductCard({Key? key,
    required this.image,
    required this.title,
    required this.prepTime,
    required this.rating,
    required this.price,
    required this.onTap,
    required this.onFav,
  }) : super(key: key);

  @override
  State<ProductCard> createState() => _ProductCardState();
}

class _ProductCardState extends State<ProductCard> {
  FirebaseAuth auth = FirebaseAuth.instance;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: widget.onTap,
      child: Column(
        children: [
          SizedBox(
            height: Dimensions.height10*24,
            width: Dimensions.width5*40,
            child: Stack(
              alignment: Alignment.bottomCenter,
              children: [
                SizedBox(
                  height: Dimensions.height10*20,
                  width: Dimensions.width10*19,
                  child: Card(
                    color: Colors.grey.shade100,
                    child: Padding(
                      padding: EdgeInsets.all(Dimensions.width5*2),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              SizedBox(
                                width: Dimensions.width10*10,
                                child: Text(widget.title,
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                  style: TextStyle(color: Colors.black,
                                      fontWeight: FontWeight.bold, fontSize: Dimensions.font14),),
                              ),
                              GestureDetector(
                                  onTap: auth.currentUser!=null?widget.onFav:(){showCustomSnackBar("Sign In to add favourite");},
                                  child: Icon(Icons.favorite, color: Colors.red.shade200, size: Dimensions.iconSize24,)
                              )
                            ],
                          ),
                          SizedBox(height: Dimensions.height10,),
                          Row(
                            children: [
                              Icon(Icons.access_time_outlined, color: Colors.blue.shade400, size: 16,),
                              SizedBox(width: Dimensions.width1*2,),
                              SizedBox(
                                width: Dimensions.width50,
                                child: Text(widget.prepTime,
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                  style: TextStyle(color: Colors.grey.shade500,
                                      fontSize: Dimensions.font12),),
                              )
                            ],
                          ),
                          SizedBox(height: Dimensions.height10,),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Row(
                                children: [
                                  Icon(Icons.star, color: Colors.yellow.shade400, size: 16,),
                                  SizedBox(width: Dimensions.width1*2,),
                                  SizedBox(
                                    width: Dimensions.width50,
                                    child: Text(widget.rating,
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                      style: TextStyle(color: Colors.grey.shade500,
                                          fontSize: Dimensions.font12),),
                                  )
                                ],
                              ),
                              Text("N ${widget.price.toString()}",
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: TextStyle(color: Colors.black,
                                    fontWeight: FontWeight.bold, fontSize: Dimensions.font14),)
                            ],
                          ),
                          SizedBox(height: Dimensions.height10,),
                        ],
                      ),
                    ),
                  ),
                ),
                Positioned(
                  top: Dimensions.height10*2,
                  bottom: Dimensions.height10*12,
                  child: FancyShimmerImage(
                    imageUrl: widget.image,
                    width: Dimensions.width10*12,
                  ),
                )
              ],
            ),
          ),
        ],
      ),
    );
  }
}
