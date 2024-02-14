import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:temi_special_flutter/utils/colors.dart';
import 'package:temi_special_flutter/utils/dimensions.dart';
import 'package:temi_special_flutter/views/home/navigation/cart_page.dart';
import 'package:temi_special_flutter/views/home/navigation/notification_page.dart';
import 'package:temi_special_flutter/views/home/navigation/product_page.dart';
import 'package:temi_special_flutter/views/home/navigation/profile_page.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {

  late SharedPreferences prefs;
  late int _selectedPageIndex;
  late List<Widget> _pages;
  late PageController _pageController;

  String? mToken = "";

  Future<void> requestPermission() async{
    FirebaseMessaging messaging = FirebaseMessaging.instance;
    prefs = await SharedPreferences.getInstance();

    NotificationSettings settings = await messaging.requestPermission(
      alert: true,
      announcement: false,
      badge: true,
      carPlay: false,
      criticalAlert: false,
      provisional: false,
      sound: true,
    );
    if(settings.authorizationStatus == AuthorizationStatus.authorized){
      debugPrint('User granted permission');
    }else if(settings.authorizationStatus == AuthorizationStatus.provisional){
      debugPrint('User granted provisional permission');
    }else{
      debugPrint('User declined or has not accepted permission');
    }
  }

  Future<void> getToken() async{
    await FirebaseMessaging.instance.getToken().then((token){
      setState(() {
        mToken = token;
      });
      saveToken(token!);
    });
  }

  void saveToken(String token) async{
    await prefs.setString('messaging_token', token);
  }

  initInfo()async{
    FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
    FlutterLocalNotificationsPlugin();
    const AndroidInitializationSettings initializationSettingsAndroid =
    AndroidInitializationSettings('@mipmap/ic_launcher');
    final DarwinInitializationSettings initializationSettingsDarwin =
    DarwinInitializationSettings(
        onDidReceiveLocalNotification: onDidReceiveLocalNotification);
    final InitializationSettings initializationSettings = InitializationSettings(
      android: initializationSettingsAndroid,
      iOS: initializationSettingsDarwin,
      macOS: initializationSettingsDarwin,);
    await flutterLocalNotificationsPlugin.initialize(initializationSettings,
        onDidReceiveNotificationResponse: onDidReceiveNotificationResponse);

    FirebaseMessaging.onMessage.listen((RemoteMessage message) async{
      BigTextStyleInformation bigTextStyleInformation = BigTextStyleInformation(
        message.notification!.body.toString(), htmlFormatBigText: true,
        contentTitle: message.notification!.title.toString(), htmlFormatContentTitle: true,
      );
      AndroidNotificationDetails androidNotificationDetails = AndroidNotificationDetails(
        "Temi Special", "Temi Special", importance: Importance.high,
        styleInformation: bigTextStyleInformation, priority: Priority.high, playSound: true,
      );
      DarwinNotificationDetails darwinNotificationDetails = const DarwinNotificationDetails(
          presentAlert: true, presentBadge: true, presentSound: true, badgeNumber: 1
      );
      NotificationDetails notificationDetails = NotificationDetails(android: androidNotificationDetails, iOS: darwinNotificationDetails);
      await flutterLocalNotificationsPlugin.show(0, message.notification?.title,
          message.notification?.body, notificationDetails,
          payload: message.data['body']);
    });

  }

  void onDidReceiveNotificationResponse(NotificationResponse notificationResponse) async {
    final String? payload = notificationResponse.payload;
    if (notificationResponse.payload != null) {
      debugPrint('notification payload: $payload');
    }
    await Navigator.push(
      context,
      MaterialPageRoute<void>(builder: (context) => const HomePage()),
    );
  }

  void onDidReceiveLocalNotification(
      int id, String? title, String? body, String? payload) async {
    // display a dialog with the notification details, tap ok to go to another page
    showDialog(
      context: context,
      builder: (BuildContext context) => CupertinoAlertDialog(
        title: Text(title!),
        content: Text(body!),
        actions: [
          CupertinoDialogAction(
            isDefaultAction: true,
            child: const Text('Ok'),
            onPressed: () async {
              Navigator.of(context, rootNavigator: true).pop();
              await Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const HomePage(),
                ),
              );
            },
          )
        ],
      ),
    );
  }

  @override
  void initState(){
    super.initState();
    _selectedPageIndex = 0;
    _pages = [
      const ProductPage(),
      const CartPage(),
      const ProfilePage(),
      const NotificationPage(),
    ];
    _pageController = PageController(initialPage: _selectedPageIndex);

    requestPermission().then((value){
      getToken().then((value){initInfo();});
    });
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: PageView(
        controller: _pageController,
        physics: const NeverScrollableScrollPhysics(),
        onPageChanged: (selectedPageIndex) {
          setState(() {
            _selectedPageIndex = selectedPageIndex;
          });
        },
        children: _pages,
      ),
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: Colors.grey.shade100,
        selectedItemColor: Colors.white,
        currentIndex: _selectedPageIndex,
        type: BottomNavigationBarType.fixed,
        showUnselectedLabels: false,
        showSelectedLabels: false,
        onTap: (selectedPageIndex) {
          setState(() {
            _selectedPageIndex = selectedPageIndex;
            _pageController.animateTo(selectedPageIndex.toDouble(), duration: const Duration(milliseconds: 200), curve: Curves.bounceOut);
          });
          _pageController.jumpToPage(selectedPageIndex);
        },
        items: [
          BottomNavigationBarItem(
            icon: Icon(Icons.home_outlined, size: Dimensions.iconSize15*2),
            activeIcon: Container(
                decoration: BoxDecoration(
                  color: AppColors.mainColor,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Icon(Icons.home_outlined, size: Dimensions.iconSize15*2),
                )
            ),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.shopping_cart_outlined, size: Dimensions.iconSize15*2),
            activeIcon: Container(
                decoration: BoxDecoration(
                  color: AppColors.mainColor,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Icon(Icons.shopping_cart_outlined, size: Dimensions.iconSize15*2),
                )
            ),
            label: 'Cart',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.people_outline, size: Dimensions.iconSize15*2),
            activeIcon: Container(
                decoration: BoxDecoration(
                  color: AppColors.mainColor,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Icon(Icons.people_outline, size: Dimensions.iconSize15*2),
                )
            ),
            label: 'Profile',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.notifications_none, size: Dimensions.iconSize15*2),
            activeIcon: Container(
                decoration: BoxDecoration(
                  color: AppColors.mainColor,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Icon(Icons.notifications_none, size: Dimensions.iconSize15*2),
                )
            ),
            label: 'Notification',
          ),
        ],
      ),
    );
  }
}
