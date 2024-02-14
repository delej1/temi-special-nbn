import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:temi_special_flutter/controllers/auth/auth_controller.dart';
import 'package:temi_special_flutter/utils/dimensions.dart';
import 'package:temi_special_flutter/widgets/button_widget.dart';
import 'package:temi_special_flutter/widgets/custom_snackbar.dart';
import 'package:temi_special_flutter/widgets/form_field_widget.dart';

class SignUpPage extends StatefulWidget {
  const SignUpPage({Key? key}) : super(key: key);

  @override
  State<SignUpPage> createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {

  final nameController = TextEditingController();
  final emailController = TextEditingController();
  final phoneController = TextEditingController();
  final passwordController = TextEditingController();
  final verifyPasswordController = TextEditingController();

  bool formOkay = false;

  @override
  void initState() {
    super.initState();
    nameController.text = "";
    emailController.text = "";
    phoneController.text = "";
    passwordController.text = "";
    verifyPasswordController.text = "";
  }

  @override
  void dispose() {
    nameController.dispose();
    emailController.dispose();
    phoneController.dispose();
    passwordController.dispose();
    verifyPasswordController.dispose();
    super.dispose();
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        child: Container(
          margin: EdgeInsets.only(top: Dimensions.height45*2),
          child: Column(
            children: [
              Center(child: Image.asset(
                "asset/image/temi_special_logo.png",
                width: Dimensions.width20*7,
              )),
              SizedBox(height: Dimensions.height10/2,),
              FormFieldWidget(
                  subject: "Name",
                  textEditingController: nameController,
                  icon: const Icon(Icons.person_2_outlined),
              ),
              FormFieldWidget(
                  subject: "Email",
                  textEditingController: emailController,
                  icon: const Icon(Icons.alternate_email_outlined),
                textInputType: TextInputType.emailAddress,
              ),
              FormFieldWidget(
                  subject: "Phone",
                  textEditingController: phoneController,
                  icon: const Icon(Icons.phone_outlined),
                  textInputType: TextInputType.phone,
                  inputFormatters:[FilteringTextInputFormatter.deny(
                  RegExp(r"\s\b|\b\s"))]
              ),
              FormFieldWidget(
                subject: "Password",
                textEditingController: passwordController,
                icon: const Icon(Icons.visibility_off_outlined),
                isObscure: true,
              ),
              FormFieldWidget(
                subject: "Verify Password",
                textEditingController: verifyPasswordController,
                icon: const Icon(Icons.visibility_off_outlined),
                isObscure: true,
              ),
              SizedBox(height: Dimensions.height20,),
              ButtonWidget(
                  onTap: (){
                    formCheck();
                    if(formOkay){
                      AuthController()
                          .register(emailController.text,
                          passwordController.text,
                          nameController.text,
                          phoneController.text
                      );
                    }
                  },
                  buttonText: "Sign Up",
              )
            ],
          ),
        ),
      ),
    );
  }
  void formCheck(){
    String name = nameController.text.trim();
    String phone = phoneController.text.trim();
    String email = emailController.text.trim();
    String password = passwordController.text.trim();
    String verifyPassword = verifyPasswordController.text.trim();

    if(name.isEmpty){
      showCustomSnackBar("Type in your name");
      formOkay = false;
    }else if(phone.isEmpty){
      showCustomSnackBar("Type in your phone number");
      formOkay = false;
    }else if(email.isEmpty){
      showCustomSnackBar("Type in your email address");
      formOkay = false;
    }else if(!GetUtils.isEmail(email)){
      showCustomSnackBar("Type in a valid email address");
      formOkay = false;
    }else if(password.isEmpty){
      showCustomSnackBar("Type in your password");
      formOkay = false;
    }else if(password.length<6){
      showCustomSnackBar("Password can't be less than six characters");
      formOkay = false;
    }else if(phone.length<11 || phone.length>11){
      showCustomSnackBar("Enter correct phone number");
      formOkay = false;
    }else if(!phoneController.text.isNum){
      showCustomSnackBar("Enter correct characters");
      formOkay = false;
    }else if(password!=verifyPassword){
      showCustomSnackBar("Password does not match");
      formOkay = false;
    }else{
      formOkay = true;
    }
  }
}
