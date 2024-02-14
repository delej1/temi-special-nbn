import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:jwt_decoder/jwt_decoder.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:temi_special_flutter/cart/cart.dart';
import 'package:temi_special_flutter/controllers/database/retrieve_keys_controller.dart';
import 'package:temi_special_flutter/controllers/database/update_fcm_controller.dart';
import 'package:temi_special_flutter/controllers/payment/payment_controller.dart';
import 'package:temi_special_flutter/utils/constants.dart';
import 'package:temi_special_flutter/utils/dimensions.dart';
import 'package:temi_special_flutter/views/cards/cart_page_cards/cart_card.dart';
import 'package:temi_special_flutter/widgets/button_widget.dart';
import 'package:temi_special_flutter/widgets/custom_app_bar.dart';
import 'package:temi_special_flutter/widgets/custom_snackbar.dart';

class CartPage extends StatefulWidget {
  const CartPage({Key? key}) : super(key: key);

  @override
  State<CartPage> createState() => _CartPageState();
}

class _CartPageState extends State<CartPage> with AutomaticKeepAliveClientMixin {
  @override
  bool get wantKeepAlive => false;

  FirebaseAuth auth = FirebaseAuth.instance;
  late SharedPreferences prefs;
  List secretKey = Get.find<RetrieveAllKeysController>().sec;
  List publicKey = Get.find<RetrieveAllKeysController>().pub;

  List<Map> cartItems = [];
  List totalAmounts = [];
  List newKey = [];
  num sum = 0;

  String id = "";
  String name = "";
  String email = "";
  String address = "";
  String userToken = "";
  int phone = 0;

  Future<void> getPrefs()async {
    prefs = await SharedPreferences.getInstance();
  }

  void getCartTotal(){
    var i = 0;
    for(i; i<boxCarts.length; i++){
      Cart cart = boxCarts.getAt(i);
      totalAmounts.add(cart.price*cart.quantity);
      Map item = {"price":cart.price,"item":cart.title,"quantity":cart.quantity};
      cartItems.add(item);
    }
  }

  deleteCart(){
    var i = 0;
    for(i; i<boxCarts.length; i++){
      setState(() {
        boxCarts.deleteAt(i);
        totalAmounts.clear();
      });
    }
  }

  void retrieveInfo(){
    try{
      Map<String, dynamic> jwtDecodedToken = JwtDecoder.decode(prefs.getString('user_token')!);
      id = jwtDecodedToken['_id'];
      name = jwtDecodedToken['name'];
      email = jwtDecodedToken['email'];
      address = jwtDecodedToken['address'];
      phone = jwtDecodedToken['phone'];
    }catch(e){
      rethrow;
    }
  }

  @override
  void initState() {
    super.initState();
    getCartTotal();
    getPrefs().then((value){retrieveInfo(); userToken = prefs.getString('messaging_token')!;});
    plugin.initialize(publicKey: publicKey[0]);
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    //sum the list of totals
    sum = totalAmounts.fold(0, (e, t) => e + t);
    return totalAmounts.isEmpty?Center(child: Text("Cart is Empty", style: TextStyle(fontSize: Dimensions.font26),),):Scaffold(
      appBar: const CustomAppBar(title: "Cart"),
      body: Column(
        children: [
          Flexible(
            child: ListView.builder(
                physics: const BouncingScrollPhysics(),
                itemCount: boxCarts.length,
                itemBuilder: (context, index){
                  Cart cart = boxCarts.getAt(index);
                  return CartCard(
                      onTap: (){
                        Get.toNamed('/cart-item-page', arguments: cart.title);
                      },
                      image: cart.image,
                      quantity: cart.quantity,
                      price: cart.price,
                      title: cart.title,
                      removeCart: (){
                        if(cart.quantity!=0){
                          setState(() {
                            boxCarts.put(
                                "key_${cart.title}",
                                Cart(
                                    image: cart.image,
                                    title: cart.title,
                                    quantity: cart.quantity-1,
                                    price: cart.price
                                ));
                          });
                        }
                        if(cart.quantity==1){setState(() {boxCarts.deleteAt(index);});}
                        totalAmounts.clear();
                        getCartTotal();
                      },
                      addCart: (){
                        if(cart.quantity<10){
                          setState(() {
                            boxCarts.put(
                                "key_${cart.title}",
                                Cart(
                                    image: cart.image,
                                    title: cart.title,
                                    quantity: cart.quantity+1,
                                    price: cart.price
                                ));
                          });
                        }
                        totalAmounts.clear();
                        getCartTotal();
                      },
                    deleteCart: (){
                        setState(() {
                          boxCarts.deleteAt(index);
                        });
                        totalAmounts.clear();
                        getCartTotal();
                    },
                  );
            }),
          ),
          SizedBox(
            height: Dimensions.height20*10,
            child: Padding(
              padding: EdgeInsets.all(Dimensions.width20),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      SizedBox(
                        child: Text("Subtotal", style: TextStyle(
                          fontSize: Dimensions.font20, color: Colors.black
                        ),),
                      ),
                      SizedBox(
                        child: Text("N $sum", textDirection: TextDirection.rtl, style: TextStyle(
                            fontSize: Dimensions.font20, color: Colors.black
                        ),),
                      ),
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      SizedBox(
                        child: Text("Handling", style: TextStyle(
                            fontSize: Dimensions.font20, color: Colors.black
                        ),),
                      ),
                      SizedBox(
                        width: Dimensions.width50*4,
                        child: Text("N ${(sum*.1).round()}", textDirection: TextDirection.rtl, style: TextStyle(
                            fontSize: Dimensions.font20, color: Colors.black
                        ),),
                      ),
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      SizedBox(
                        child: Text("Total", style: TextStyle(
                            fontSize: Dimensions.font20, color: Colors.black, fontWeight: FontWeight.bold
                        ),),
                      ),
                      SizedBox(
                        child: Text("N ${(sum+(sum*.1)).round()}", textDirection: TextDirection.rtl, style: TextStyle(
                            fontSize: Dimensions.font20, color: Colors.black, fontWeight: FontWeight.bold
                        ),),
                      ),
                    ],
                  ),
                  ButtonWidget(onTap: (){
                    String fcmKey = prefs.getString('fcm_key')!;
                    if(auth.currentUser!=null){
                      if(sum>=2500){
                        if(address.isNotEmpty){
                          UpdateFcmController().updateData(fcmKey)
                              .then((value) {
                            RetrieveAllKeysController().retrieveData().then((value) {
                              PaymentController(
                                ctx: context,
                                email: email,
                                secretKey: secretKey[0],
                                userToken: userToken,
                                fcmKey: fcmKey,
                                userId: id,
                                address: address,
                                cart: cartItems,
                                name: name,
                                orderAmount: (sum+(sum*.1)).round(),
                                orderStatus: 'Preparing',
                                phone: phone,
                              ).chargeCard().then((value) => deleteCart());
                            });
                          });
                        }else{showCustomSnackBar("Kindly update your location");}
                      }else{showCustomSnackBar("Minimum order is N2500");}
                    }else{showCustomSnackBar("Sign In to checkout");}
                  }, buttonText: "Checkout")
                ],
              ),
            ),
          )
        ],
      ),
    );
  }
}
