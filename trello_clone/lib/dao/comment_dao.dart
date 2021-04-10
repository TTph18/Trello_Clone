import 'package:floor/floor.dart';
import 'package:trello_clone/entity/comment.dart';
@dao
abstract class CommentDao
{
  @Query('SELECT * FROM COMMENT')
  Future<List<Comment>> findAll();

  @Query('SELECT * FROM COMMENT WHERE CommentID = :id')
  Stream<Comment> findById(int id);

  @insert
  Future<void> insertComment(Comment comment);
}