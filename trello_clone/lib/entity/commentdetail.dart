import 'package:floor/floor.dart';

@entity
class CommentDetail
{
  @Entity(primaryKeys: ['account','commentid'])
  String account;

  @ColumnInfo(name: 'tuong tac')
  String interactive;

  @ColumnInfo(name: 'noi dung')
  String content;

  @ColumnInfo(name: 'ma binh luan')
  String commentid;

  CommentDetail(this.account, this.interactive, this.content, this.commentid);
}