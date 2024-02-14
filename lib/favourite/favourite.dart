import 'package:hive/hive.dart';

part 'favourite.g.dart';

@HiveType(typeId: 2)
class Favourite {
  Favourite({
    required this.image,
    required this.title,
  });

  @HiveField(0)
  String image;

  @HiveField(1)
  String title;
}
