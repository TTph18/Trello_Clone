import 'package:floor/floor.dart';

@entity
class CommentDetail
{
  @Entity(primaryKeys: ['account','commentid'])
  String account;

  @ColumnInfo(name: 'tuong tac', nullable: true)
  String interactive;

  @ColumnInfo(name: 'ma binh luan', nullable: true)
  String commentid;

  CommentDetail(this.account, this.interactive, this.commentid);
}