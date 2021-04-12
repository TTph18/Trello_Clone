import 'package:floor/floor.dart';
import '../entity/file.dart';
@dao
abstract class FileDao
{
  @Query('SELECT * FROM FILE')
  Future<List<File>> findAll();

  @Query('SELECT * FROM CHECKLIST WHERE FileID = :id')
  Stream<File?> findById(int id);

  @insert
  Future<void> insertCheckList(File file);
}