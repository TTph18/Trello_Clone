// @dart=2.12
import 'package:floor/floor.dart';

@entity
class Card
{
  @primaryKey
  int cardid;

  //@ColumnInfo(name: 'ten the')
  String cardname;

 // @ColumnInfo(name: 'noi dung')
  String content;

  //@ColumnInfo(name: 'binh luan')
  String comment;

  //@ColumnInfo(name: 'ngay bat dau')
  String begindate;

  //@ColumnInfo(name: 'ngay ket thuc')
  String finishdate;

  //@ColumnInfo(name: 'so thu tu')
  int number;

  Card(this.cardid, this.cardname, this.content, this.comment, this.begindate, this.finishdate, this.number);
}