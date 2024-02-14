import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:temi_special_flutter/controllers/auth/auth_controller.dart';
import 'package:temi_special_flutter/utils/dimensions.dart';
import 'package:temi_special_flutter/views/auth/signup_page.dart';
import 'package:temi_special_flutter/widgets/button_widget.dart';
import 'package:temi_special_flutter/widgets/custom_snackbar.dart';
import 'package:temi_special_flutter/widgets/form_field_widget.dart';

class SignInPage extends StatefulWidget {
  const SignInPage({Key? key}) : super(key: key);

  @override
  State<SignInPage> createState() => _SignInPageState();
}

class _SignInPageState extends State<SignInPage> {

  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  bool formOkay = false;

  @override
  void initState() {
    super.initState();
    emailController.text = "";
    passwordController.text = "";
  }

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
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
                subject: "Email",
                textEditingController: emailController,
                icon: const Icon(Icons.alternate_email_outlined),
                textInputType: TextInputType.emailAddress,
              ),
              FormFieldWidget(
                subject: "Password",
                textEditingController: passwordController,
                icon: const Icon(Icons.visibility_off_outlined),
                isObscure: true,
              ),
              SizedBox(height: Dimensions.height20,),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: Dimensions.width30),
                child: Align(
                  alignment: Alignment.bottomRight,
                  child: Padding(
                    padding: EdgeInsets.all(Dimensions.width5),
                    child: RichText(text: TextSpan(
                        recognizer: TapGestureRecognizer()..onTap=(){},
                        text: "Forgot Password?",
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: Dimensions.font12,
                          fontWeight: FontWeight.bold,
                        )
                    )),
                  ),
                ),
              ),
              SizedBox(height: Dimensions.height30,),
              ButtonWidget(
                onTap: (){
                  formCheck();
                  if(formOkay){
                    AuthController()
                        .signIn(emailController.text,
                        passwordController.text);}
                  },
                buttonText: "Sign In",
              ),
              SizedBox(height: Dimensions.height20,),
              //sign up options
              RichText(text: TextSpan(
                  text: "Don't have an account?",
                  style: TextStyle(
                    color: Colors.grey,
                    fontSize: Dimensions.font16,
                  ),
                  children:[
                    TextSpan(
                        recognizer: TapGestureRecognizer()..onTap=()=>Get.to(()=>const SignUpPage(), transition: Transition.fade),
                        text: " Sign Up",
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Colors.black,
                          fontSize: Dimensions.font16,
                        )),
                  ]
              )),
            ],
          ),
        ),
      ),
    );
  }
  void formCheck(){
    String email = emailController.text.trim();
    String password = passwordController.text.trim();

    if(email.isEmpty){
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
    }else{
      formOkay = true;
    }
  }
}
