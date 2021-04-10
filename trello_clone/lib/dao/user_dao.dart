import 'package:floor/floor.dart';
import '../entity/user.dart';
@dao
abstract class UserDao
{
  @Query('SELECT * FROM USER')
  Future<List<User>> findAllPersons();

  @Query('SELECT * FROM USER WHERE Account = :id')
  Stream<User> findPersonById(String id);

  @insert
  Future<void> insertUser(User user);
}