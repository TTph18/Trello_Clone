import 'package:floor/floor.dart';

@entity
class File
{
  @primaryKey
  String fileid;

  @ColumnInfo(name: 'duong dan file')
  String link;

  File(this.fileid, this.link);
}