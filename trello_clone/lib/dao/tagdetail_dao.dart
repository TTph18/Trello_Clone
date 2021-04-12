import 'package:floor/floor.dart';
import '../entity/tagdetail.dart';
@dao
abstract class TagDetailDao
{
  @Query('SELECT * FROM CHECKLIST')
  Future<List<TagDetail>> findAll();

  @Query('SELECT * FROM CHECKLIST WHERE TagID = :id')
  Stream<TagDetail?> findById(int id);

  @insert
  Future<void> insertTagDetail(TagDetail tagDetail);
}