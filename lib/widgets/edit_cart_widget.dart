import 'package:flutter/material.dart';
import 'package:temi_special_flutter/utils/dimensions.dart';

class EditCartWidget extends StatelessWidget {
  final Function() removeCart;
  final Function() addCart;
  final int count;
  final double? iconSize;
  final double? texSize;
  const EditCartWidget({Key? key,
    required this.removeCart,
    required this.addCart,
    required this.count,
    this.iconSize,
    this.texSize
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        GestureDetector(
          onTap: removeCart,
          child: Icon(Icons.remove_circle_outline, color: Colors.black, size: iconSize??30,),),
        SizedBox(width: Dimensions.width10*3, child: Center(child: Text(count.toString(), style: TextStyle(fontSize: texSize??Dimensions.font20),))),
        GestureDetector(
          onTap: addCart,
          child: Icon(Icons.add_circle_outline, color: Colors.black, size: iconSize??30,),),
      ],
    );
  }
}
