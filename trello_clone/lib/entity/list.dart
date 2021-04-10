import 'package:floor/floor.dart';

@entity
class List
{
  @primaryKey
  int listid;

  @ColumnInfo(name: 'ten danh sach', nullable: false)
  String listname;

  @ColumnInfo(name: 'so thu tu', nullable: false)
  int number;

  @ColumnInfo(name: 'ma bang', nullable: false)
  int boardid;

  List(this.listid, this.listname, this.number, this.boardid);
}