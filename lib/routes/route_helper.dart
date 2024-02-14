import 'package:get/get.dart';
import 'package:temi_special_flutter/views/auth/signin_page.dart';
import 'package:temi_special_flutter/views/auth/signup_page.dart';
import 'package:temi_special_flutter/views/home/home_page.dart';
import 'package:temi_special_flutter/views/intro/splash_screen.dart';
import 'package:temi_special_flutter/views/pages/cart_item_page.dart';
import 'package:temi_special_flutter/views/pages/favourite_page.dart';
import 'package:temi_special_flutter/views/pages/item_page.dart';
import 'package:temi_special_flutter/views/pages/search_item_page.dart';



class RouteHelper{
  static const String splashPage = "/splash-page";
  static const String initial = "/";
  static const String signUp = "/sign-up";
  static const String signIn = "/sign-in";
  static const String itemPage = "/item-page";
  static const String searchItemPage = "/search-item-page";
  static const String cartItemPage = "/cart-item-page";
  static const String favouriteItemPage = "/favourite-item-page";



  static String getSplashPage()=>splashPage;
  static String getInitial()=>initial;
  static String getSignUpPage()=>signUp;
  static String getSignInPage()=>signIn;
  static String getItemPage()=>itemPage;
  static String getSearchItemPage()=>searchItemPage;
  static String getCartItemPage()=>cartItemPage;
  static String getFavouriteItemPage()=>favouriteItemPage;



  static List<GetPage>routes=[

    GetPage(name: splashPage, page: ()=>const SplashScreen()),

    GetPage(name: initial, page: (){
      return const HomePage();
    }, transition: Transition.fade),

    GetPage(name: signUp, page: (){
      return const SignUpPage();
    }, transition: Transition.fade),

    GetPage(name: signIn, page: (){
      return const SignInPage();
    }, transition: Transition.fade),

    GetPage(name: itemPage, page: (){
      return const ItemPage();
    }, transition: Transition.fade),

    GetPage(name: searchItemPage, page: (){
      return const SearchItemPage();
    }, transition: Transition.fade),

    GetPage(name: cartItemPage, page: (){
      return const CartItemPage();
    }, transition: Transition.fade),

  GetPage(name: favouriteItemPage, page: (){
      return const FavouritePage();
    }, transition: Transition.fade),
  ];
}