import 'package:fancy_shimmer_image/fancy_shimmer_image.dart';
import 'package:flutter/material.dart';
import 'package:temi_special_flutter/utils/dimensions.dart';

class DiscountProductCard extends StatelessWidget {
  final String image;
  final String title;
  final String subTitle;
  final String prepTime;
  final String rating;
  final int price;
  final String discount;
  final Function() onTap;
  const DiscountProductCard({Key? key,
    required this.image,
    required this.title,
    required this.subTitle,
    required this.prepTime,
    required this.rating,
    required this.price,
    required this.discount,
    required this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(left: Dimensions.width10, right: Dimensions.width10, bottom: Dimensions.height15),
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          height: Dimensions.height10*12,
          width: double.maxFinite,
          decoration: BoxDecoration(
              color: Colors.grey.shade100,
              borderRadius: BorderRadius.circular(5)
          ),
          child: Padding(
            padding: EdgeInsets.all(Dimensions.width10),
            child: Row(
              children: [
                FancyShimmerImage(
                  imageUrl: image,
                  width: Dimensions.width10*12,
                ),
                Padding(
                  padding: EdgeInsets.all(Dimensions.width10),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(title,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(color: Colors.black,
                            fontWeight: FontWeight.bold, fontSize: Dimensions.font14),),
                      SizedBox(height: Dimensions.height1*3,),
                      Text(subTitle,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(color: Colors.black,
                            fontSize: Dimensions.font14),),
                      SizedBox(height: Dimensions.height1*3,),
                      Row(
                        children: [
                          Icon(Icons.access_time_outlined, color: Colors.blue.shade400, size: 16,),
                          SizedBox(width: Dimensions.width1*2,),
                          SizedBox(
                            width: Dimensions.width50,
                            child: Text(prepTime,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(color: Colors.grey.shade500,
                                  fontSize: Dimensions.font12),),
                          )
                        ],
                      ),
                      SizedBox(height: Dimensions.height1*3,),
                      Row(
                        children: [
                          Row(
                            children: [
                              Icon(Icons.star, color: Colors.yellow.shade400, size: 16,),
                              SizedBox(width: Dimensions.width1*2,),
                              SizedBox(
                                width: Dimensions.width50,
                                child: Text(rating,
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                  style: TextStyle(color: Colors.grey.shade500,
                                      fontSize: Dimensions.font12),),
                              )
                            ],
                          ),
                          Text("$discount off for N $price",
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(color: Colors.green,
                                fontWeight: FontWeight.bold, fontSize: Dimensions.font14),)
                        ],
                      ),
                    ],
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
