import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:temi_special_flutter/utils/colors.dart';
import 'package:temi_special_flutter/utils/dimensions.dart';

class FormFieldWidget extends StatelessWidget {
  final String subject;
  final TextEditingController textEditingController;
  final Icon icon;
  final TextInputType? textInputType;
  final List<TextInputFormatter>? inputFormatters;
  final bool isObscure;
  const FormFieldWidget({
    Key? key,
    required this.subject,
    required this.textEditingController,
    required this.icon,
    this.textInputType,
    this.inputFormatters,
    this.isObscure = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(left: Dimensions.width30, right: Dimensions.width30, top: Dimensions.width30,),
      child: Container(
        decoration: BoxDecoration(
            color: Colors.white70,
            borderRadius: BorderRadius.circular(Dimensions.radius20/4),
            boxShadow: [
              BoxShadow(
                blurRadius: 13,
                spreadRadius: 1,
                offset: const Offset(1,1),
                color: Colors.grey.withOpacity(0.2),
              )
            ]
        ),
        child: TextField(
          controller: textEditingController,
          keyboardType: textInputType,
          inputFormatters: inputFormatters,
          obscureText: isObscure?true:false,
          decoration: InputDecoration(
            labelText: subject,
            suffixIcon: icon,
            focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(Dimensions.radius20/4),
                borderSide: const BorderSide(
                  width: 1.0,
                  color: AppColors.mainColor,
                )
            ),
            enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(Dimensions.radius20/4),
                borderSide: const BorderSide(
                  width: 1.0,
                  color: Colors.white,
                )
            ),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(Dimensions.radius20/4),
            ),
          ),
        ),
      ),
    );
  }
}
