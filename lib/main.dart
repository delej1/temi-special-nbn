import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:temi_special_flutter/cart/cart.dart';
import 'package:temi_special_flutter/controllers/database/retrieve_all_discount_prod_controller.dart';
import 'package:temi_special_flutter/controllers/database/retrieve_all_product_controller.dart';
import 'package:temi_special_flutter/controllers/database/retrieve_keys_controller.dart';
import 'package:temi_special_flutter/favourite/favourite.dart';
import 'package:temi_special_flutter/routes/route_helper.dart';
import 'package:temi_special_flutter/utils/colors.dart';
import 'package:temi_special_flutter/utils/constants.dart';

Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async{
  debugPrint('Handling a background message ${message.messageId}');
}

void main() async{
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  await FirebaseMessaging.instance.getInitialMessage();
  FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);
  Get.put(RetrieveAllProductController());
  Get.put(RetrieveAllDiscountProdController());
  Get.put(RetrieveAllKeysController());
  await Hive.initFlutter();
  Hive.registerAdapter(CartAdapter());
  Hive.registerAdapter(FavouriteAdapter());
  boxCarts = await Hive.openBox<Cart>('cartBox');
  boxFavourites = await Hive.openBox<Favourite>('favouriteBox');
  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp])
      .then((_) {
    runApp(const MyApp());
  });
  if (kReleaseMode) {
    debugPrint = (String? message, {int? wrapWidth}) {};
  }
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Temi Special Snacks',
      initialRoute: RouteHelper.getInitial(),
      getPages: RouteHelper.routes,
      theme: ThemeData(
        primaryColor: AppColors.mainColor,
        textTheme: GoogleFonts.comicNeueTextTheme(
          Theme.of(context).textTheme.apply(
          ),
        ),
      ),
    );
  }
}