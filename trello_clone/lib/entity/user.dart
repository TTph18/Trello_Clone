// @dart=2.12
import 'package:floor/floor.dart';

@entity
class User
{
  @primaryKey
  String account;

  //@ColumnInfo(name: 'mat khau')
  String password;

  //@ColumnInfo(name: 'ten nguoi dung')
  String user_name;

  User(this.account, this.password, this.user_name);
}