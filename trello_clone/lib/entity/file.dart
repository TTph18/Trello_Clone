import 'package:floor/floor.dart';

@entity
class File
{
  @primaryKey
  int fileid;

  @ColumnInfo(name: 'anh dai dien file', nullable: true)
  var picture;

  @ColumnInfo(name: 'duong dan file', nullable: false)
  String link;

  @ColumnInfo(name: 'file', nullable: false)
  File file;

  File(this.fileid, this.picture, this.link, this.file);
}