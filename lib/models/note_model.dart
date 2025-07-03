import 'package:hive/hive.dart';

part 'note_model.g.dart';

@HiveType(typeId: 0)
class NoteModel extends HiveObject {
  @HiveField(0)
  String id;

  @HiveField(1)
  String title;

  @HiveField(2)
  String content;

  @HiveField(3)
  int backgroundColor;

  @HiveField(4)
  String? imagePath;

  @HiveField(5)
  DateTime createdDate;

  @HiveField(6)
  DateTime updatedDate;

  NoteModel({required this.id, required this.title, required this.content, required this.backgroundColor, this.imagePath, required this.createdDate, required this.updatedDate});
}
