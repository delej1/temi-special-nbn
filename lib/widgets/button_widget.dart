import 'package:flutter/material.dart';
import 'package:temi_special_flutter/utils/colors.dart';
import 'package:temi_special_flutter/utils/dimensions.dart';

class ButtonWidget extends StatelessWidget {
  final Function() onTap;
  final String buttonText;
  const ButtonWidget({Key? key,
    required this.onTap,
    required this.buttonText
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(Dimensions.width5),
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          width: Dimensions.screenWidth/2.5,
          height: Dimensions.screenHeight/13,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(Dimensions.radius30),
            color: AppColors.mainColor,
          ),
          child: Center(
            child: Text(buttonText,
              style: TextStyle(
                fontSize: Dimensions.font20,
                color: Colors.white,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
