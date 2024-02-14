import 'package:flutter/material.dart';
import 'package:temi_special_flutter/utils/dimensions.dart';

class NotificationPage extends StatefulWidget {
  const NotificationPage({Key? key}) : super(key: key);

  @override
  State<NotificationPage> createState() => _NotificationPageState();
}

class _NotificationPageState extends State<NotificationPage> with AutomaticKeepAliveClientMixin {

  @override
  bool get wantKeepAlive => true;

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Center(child: Text("No Notifications", style: TextStyle(fontSize: Dimensions.font26),));
  }
}
