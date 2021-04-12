// @dart=2.12
import 'package:floor/floor.dart';
import 'package:trello_clone/entity/board.dart';

@entity
class ListItem
{
  @Entity(
    tableName: 'list',
    foreignKeys: [
      ForeignKey(
        childColumns: ['boardid'],
        parentColumns: ['listid'],
        entity: Board,
      )
    ],
  )
  @primaryKey
  late int listid;

  @ColumnInfo(name: 'ten danh sach')
  late String listname;

  @ColumnInfo(name: 'so thu tu')
  late int number;

  @ColumnInfo(name: 'ma bang')
  int boardid;

  ListItem(this.listid, this.listname, this.number, this.boardid);
}