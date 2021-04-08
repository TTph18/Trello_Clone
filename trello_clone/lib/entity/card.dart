import 'package:floor/floor.dart';

@entity
class Card
{
  @primaryKey
  int cardid;

  @ColumnInfo(name: 'ten the', nullable: false)
  String cardname;

  @ColumnInfo(name: 'noi dung', nullable: true)
  String content;

  @ColumnInfo(name: 'binh luan', nullable: true)
  String comment;

  @ColumnInfo(name: 'ngay bat dau', nullable: true)
  String begindate;

  @ColumnInfo(name: 'ngay ket thuc', nullable: true)
  String finishdate;

  @ColumnInfo(name: 'so thu tu', nullable: true)
  int number;

  Card(this.cardid, this.cardname, this.content, this.comment, this.begindate, this.finishdate, this.number);
}