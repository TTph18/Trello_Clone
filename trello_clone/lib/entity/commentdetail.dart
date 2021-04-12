// @dart=2.12
import 'package:floor/floor.dart';

@Entity(primaryKeys: ['account','commentid'])
class CommentDetail
{
  String account;
  String commentid;

  @ColumnInfo(name: 'tuong tac')
  String interactive;

  CommentDetail(this.account, this.interactive, this.commentid);
}