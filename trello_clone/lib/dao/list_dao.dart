import 'package:floor/floor.dart';
import '../entity/list_item.dart';
@dao
abstract class ListDao
{
  @Query('SELECT * FROM CHECKLIST WHERE ListID = :id')
  Stream<ListItem?> findById(int id);

  @insert
  Future<void> insertList(ListItem list);
}