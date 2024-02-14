import 'package:hive/hive.dart';

part 'cart.g.dart';

@HiveType(typeId: 1)
class Cart {
  Cart({
    required this.image,
    required this.title,
    required this.quantity,
    required this.price,
  });

  @HiveField(0)
  String image;

  @HiveField(1)
  String title;

  @HiveField(2)
  int quantity;

  @HiveField(3)
  int price;
}
