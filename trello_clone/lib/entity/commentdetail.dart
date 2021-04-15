import 'package:floor/floor.dart';

@Entity(primaryKeys: ['account','commentid'])
class CommentDetail
{
  String account;

  //@ColumnInfo(name: 'tuong tac')
  String interactive;

  //@ColumnInfo(name: 'noi dung')
  String content;

  //@ColumnInfo(name: 'ma binh luan')
  int commentid;

  CommentDetail(this.account, this.interactive, this.content, this.commentid);
}