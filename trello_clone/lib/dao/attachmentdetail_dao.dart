import 'package:floor/floor.dart';
import '../entity/attachmentdetail.dart';
@dao
abstract class AttachmentDetailDao
{
  @Query('SELECT * FROM ATTACHMENTDETAIL')
  Future<List<AttachmentDetail>> findAll();

  @Query('SELECT * FROM ATTACHMENTDETAIL WHERE AttachmentID = :id')
  Stream<AttachmentDetail?> findById(int id);

  @insert
  Future<void> insertAttachmentDetail(AttachmentDetail attachmentDetail);
}