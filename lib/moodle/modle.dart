import 'package:hive/hive.dart';

part 'modle.g.dart';

@HiveType(typeId: 1)
class nots extends HiveObject {
  @HiveField(0)
  String title;
  @HiveField(1)
  String discription;
  nots({required this.title, required this.discription});
}
