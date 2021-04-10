import 'package:floor/floor.dart';
import 'package:trello_clone/entity/commentdetail.dart';

@dao
abstract class CommentDetailDao
{
  @Query('SELECT * FROM COMMENTDETAIL')
  Future<List<CommentDetail>> findAll();

  @Query('SELECT * FROM COMMENTDETAIL WHERE CommentID = :id')
  Stream<CommentDetail> findById(int id);

  @insert
  Future<void> insertCommentDetail(CommentDetail commentDetail);
}