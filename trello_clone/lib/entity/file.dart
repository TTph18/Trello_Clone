import 'package:floor/floor.dart';

@entity
class File
{
  @primaryKey
  String fileid;

  @ColumnInfo(name: 'anh dai dien file')
  var picture;

  @ColumnInfo(name: 'duong dan file')
  String link;

  @ColumnInfo(name: 'file')
  File file;

  File(this.fileid, this.picture, this.link, this.file);
}