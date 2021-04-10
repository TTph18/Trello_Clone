import 'package:floor/floor.dart';
import '../entity/card.dart';
@dao
abstract class CardDao
{
  @Query('SELECT * FROM CARD')
  Future<List<Card>> findAll();

  @Query('SELECT * FROM CARD WHERE CARDID = :id')
  Stream<Card> findById(int id);

  @insert
  Future<void> insertCard(Card card);
}