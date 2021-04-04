import 'package:floor/floor.dart';
@dao
abstract class NguoiDungDao {
  @Query('SELECT * FROM NguoiDung')
  Future<List<Person>> findAllPersons();

  @insert
  Future<void> insertPerson(NguoiDung nguoidung);

  @transaction
  Future<void> replaceUsers(List<Person> users) async {
    await deleteAllUsers();
    await insertUsers(users);
  }
}