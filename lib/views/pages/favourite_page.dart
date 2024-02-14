import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:temi_special_flutter/favourite/favourite.dart';
import 'package:temi_special_flutter/utils/constants.dart';
import 'package:temi_special_flutter/utils/dimensions.dart';
import 'package:temi_special_flutter/views/cards/favourite_page_cards/favourite_card.dart';

class FavouritePage extends StatefulWidget {
  const FavouritePage({Key? key}) : super(key: key);

  @override
  State<FavouritePage> createState() => _FavouritePageState();
}

class _FavouritePageState extends State<FavouritePage> {
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
        title: const Center(child: Text("Favourites", style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),)),
      ),
      body: boxFavourites.isEmpty?Center(child: Text("No Favourites Added", style: TextStyle(fontSize: Dimensions.font26),),):ListView.builder(
          physics: const BouncingScrollPhysics(),
          itemCount: boxFavourites.length,
          itemBuilder: (context, index){
            Favourite favourite = boxFavourites.getAt(index);
            return FavouriteCard(
              onTap: (){
                Get.toNamed('/search-item-page', arguments: favourite.title);
              },
              image: favourite.image,
              title: favourite.title,
              deleteFav: (){
                setState(() {
                  boxFavourites.deleteAt(index);
                });
              },
            );
          }),
    );
  }
}
