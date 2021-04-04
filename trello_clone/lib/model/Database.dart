import 'dart:async';
import 'package:floor/floor.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart' as sqflite;

import 'dao/person_dao.dart';
import 'model/person.dart';

part 'database.g.dart'; // the generated code will be there

@Database(version: 1, entities: [NguoiDung])
abstract class AppDatabase extends FloorDatabase {
  NguoiDungDao get nguoidungDao;
}