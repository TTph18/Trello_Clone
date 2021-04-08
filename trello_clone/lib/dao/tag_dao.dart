import 'package:floor/floor.dart';
import '../entity/tag.dart';
@dao
abstract class TagDao
{
  @Query('SELECT * FROM CHECKLIST')
  Future<List<Tag>> findAll();

  @Query('SELECT * FROM CHECKLIST WHERE TagID = :id')
  Stream<Tag> findById(int id);

  @insert
  Future<void> insertTag(Tag tag);
}