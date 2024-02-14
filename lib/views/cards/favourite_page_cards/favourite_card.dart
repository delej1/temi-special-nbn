import 'package:fancy_shimmer_image/fancy_shimmer_image.dart';
import 'package:flutter/material.dart';
import 'package:temi_special_flutter/utils/dimensions.dart';

class FavouriteCard extends StatelessWidget {
  final String image;
  final String title;
  final Function() onTap;
  final Function() deleteFav;
  const FavouriteCard({
    Key? key,
    required this.onTap,
    required this.image,
    required this.title,
    required this.deleteFav
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
                  child: Text(title,style: TextStyle(color: Colors.black,
                      fontWeight: FontWeight.bold, fontSize: Dimensions.font16),),
                ),
                IconButton(onPressed:deleteFav, icon: const Icon(Icons.remove_circle_outline, color: Colors.redAccent,))
              ],
            ),
          ),
        ),
      ),
    );
  }
}
