import 'package:fancy_shimmer_image/fancy_shimmer_image.dart';
import 'package:flutter/material.dart';
import 'package:temi_special_flutter/utils/dimensions.dart';
import 'package:temi_special_flutter/widgets/edit_cart_widget.dart';

class CartCard extends StatelessWidget {
  final String image;
  final String title;
  final int quantity;
  final int price;
  final Function() onTap;
  final Function() removeCart;
  final Function() addCart;
  final Function() deleteCart;
  const CartCard({
    Key? key,
    required this.onTap,
    required this.image,
    required this.quantity,
    required this.price,
    required this.title,
    required this.removeCart,
    required this.addCart,
    required this.deleteCart
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: SizedBox(
        width: Dimensions.screenWidth,
        height: Dimensions.height160,
        child: Card(
          color: Colors.grey.shade100,
          child: Padding(
            padding: EdgeInsets.all(Dimensions.width10),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                SizedBox(
                  width: Dimensions.width10*10,
                  height: Dimensions.height10*9,
                  child: FancyShimmerImage(
                    imageUrl: image,
                  ),
                ),
                SizedBox(
                  width: Dimensions.width10*20,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(height: Dimensions.height20,),
                      Text(title,style: TextStyle(color: Colors.black,
                          fontWeight: FontWeight.bold, fontSize: Dimensions.font16),),
                      SizedBox(height: Dimensions.height1*5,),
                      Text("N ${price*quantity}"),
                      SizedBox(height: Dimensions.height20,),
                      EditCartWidget(removeCart: removeCart, addCart: addCart, count: quantity, iconSize: 20, texSize: Dimensions.font14,)
                    ],
                  ),
                ),
                IconButton(onPressed:deleteCart, icon: const Icon(Icons.remove_circle_outline, color: Colors.redAccent,))
              ],
            ),
          ),
        ),
      ),
    );
  }
}
