import 'package:sqflite/sqflite.dart';
import 'database_manager.dart';

class movies {
  late int id;
  String title;
  String image;
  String director;
  movies({required this.title, required this.image, required this.director});

  movies.fromDbMap(Map<String, dynamic> map)
      : id = map['id'],
        title = map['title'],
        image = map['image'],
        director = map['director'];

  Map<String, dynamic> toDbMap() {
    var map = Map<String, dynamic>();
    map['title'] = title;
    map['image'] = image;
    map['director'] = director;
    return map;
  }
}
