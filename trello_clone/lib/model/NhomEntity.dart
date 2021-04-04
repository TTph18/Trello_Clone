import 'package:floor/floor.dart';

@entity
class Nhom
{
  @primaryKey
  final int id;

  @ColumnInfo(name: 'custom_name', nullable: false)
  final String name;

  Person(this.id, this.name);
}