import 'package:floor/floor.dart';

@entity
class User
{
  @primaryKey
  String account;

  @ColumnInfo(name: 'mat khau', nullable: false)
  String password;

  var picture;

  @ColumnInfo(name: 'ten nguoi dung', nullable: false)
  String user_name;

  User(this.account, this.password, this.picture, this.user_name);
}