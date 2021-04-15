// @dart=2.12
import 'package:floor/floor.dart';

@entity
class AttachmentDetail
{
  @primaryKey
  int fileid;

  int tagid; //ma nhan

  int commentid; //ma binh luan

  AttachmentDetail(this.fileid, this.tagid, this.commentid);
}