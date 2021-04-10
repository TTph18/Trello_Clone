import 'package:floor/floor.dart';

@entity
class AttachmentDetail
{
  @primaryKey
  int fileid;

  @ColumnInfo(name: 'ma nhan', nullable: true)
  int tagid;

  @ColumnInfo(name: 'ma binh luan', nullable: false)
  int commentid;

  AttachmentDetail(this.fileid, this.tagid, this.commentid);
}