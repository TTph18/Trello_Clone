import 'package:floor/floor.dart';

@entity
class Comment
{
  @primaryKey
  String commentid;

  @ColumnInfo(name: 'noi dung')
  String content;

  @ColumnInfo(name: 'nguoi binh luan')
  String account;

  Comment(this.account, this.content, this.commentid);
}