// @dart=2.12
import 'package:floor/floor.dart';

@entity
class File
{
  @primaryKey
  int fileid;

  @ColumnInfo(name: 'duong dan file')
  String link;

  File(this.fileid, this.link);
}