import 'package:floor/floor.dart';

@entity
class Comment
{
  @primaryKey
  String account;

  @ColumnInfo(name: 'noi dung', nullable: false)
  String content;

  @ColumnInfo(name: 'ma binh luan', nullable: false)
  int commentid;

  Comment(this.account, this.content, this.commentid);
}