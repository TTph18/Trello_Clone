// @dart=2.12
import 'package:floor/floor.dart';

@entity
class AttachmentDetail
{
  @primaryKey
  int fileid;

  @ColumnInfo(name: 'ma nhan')
  int tagid;

  @ColumnInfo(name: 'ma binh luan')
  int commentid;

  AttachmentDetail(this.fileid, this.tagid, this.commentid);
}