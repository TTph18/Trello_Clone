// @dart=2.12
import 'package:floor/floor.dart';
import 'package:trello_clone/entity/user.dart';

@entity
class Comment
{
  @Entity(
    tableName: 'comment',
    foreignKeys: [
      ForeignKey(
        childColumns: ['account'],
        parentColumns: ['commentid'],
        entity: User,
      )
    ],
  )
  @PrimaryKey()
  String commentid;

  @ColumnInfo(name: 'noi dung')
  String content;

  @ColumnInfo(name: 'nguoi binh luan')
  int account;

  Comment(this.commentid, this.content, this.account);
}