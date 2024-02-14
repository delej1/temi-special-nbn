import 'package:flutter/material.dart';
import 'package:temi_special_flutter/utils/dimensions.dart';

class SearchCard extends StatelessWidget {
  final Function() onTap;
  const SearchCard({Key? key, required this.onTap}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(Dimensions.width20),
      child: GestureDetector(
        onTap: onTap,
        child: Material(
          elevation: 2,
          child: Container(
            height: Dimensions.height30*2,
            width: double.maxFinite,
            decoration: BoxDecoration(
              color: Colors.grey.shade100,
              borderRadius: BorderRadius.circular(Dimensions.radius20/4),
            ),
            child: Padding(
              padding:  EdgeInsets.all(Dimensions.width8),
              child: Row(
                children: [
                  const Icon(Icons.search, size: 20,),
                  SizedBox(width: Dimensions.width5,),
                  const Text("Search"),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
