import 'package:flutter/material.dart';
import 'package:random_avatar/random_avatar.dart';
import 'package:temi_special_flutter/utils/constants.dart';
import 'package:temi_special_flutter/utils/dimensions.dart';

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String title;
  const CustomAppBar({Key? key, required this.title}) : super(key: key);

  @override
  Size get preferredSize => Size.fromHeight(Dimensions.height56);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: Colors.grey.shade100,
      automaticallyImplyLeading: false,
      elevation: 0,
      title: Center(child: Text(title, style: const TextStyle(color: Colors.black, fontWeight: FontWeight.bold),)),
      leading: Padding(
        padding: EdgeInsets.all(Dimensions.width8),
        child: RandomAvatar(profilePic),
      ),
      actions: [
        IconButton(onPressed: (){},
            icon: const Icon(Icons.notifications_none, color: Colors.black,)
        )
      ],
    );
  }
}
