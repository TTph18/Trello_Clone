import 'dart:async';
import 'package:floor/floor.dart';
import 'package:sqflite/sqflite.dart' as sqflite;
import 'package:trello_clone/dao/group_dao.dart';
import 'package:trello_clone/dao/history_dao.dart';
import 'package:trello_clone/entity/attachmentdetail.dart';
import 'package:trello_clone/entity/board.dart';
import 'package:trello_clone/entity/card.dart';
import 'package:trello_clone/entity/checklist.dart';
import 'package:trello_clone/entity/comment.dart';
import 'package:trello_clone/entity/commentdetail.dart';
import 'package:trello_clone/entity/file.dart';
import 'package:trello_clone/entity/group.dart';
import 'package:trello_clone/entity/groupdetail.dart';
import 'package:trello_clone/entity/history.dart';
import 'package:trello_clone/entity/list.dart';
import 'package:trello_clone/entity/tag.dart';
import 'package:trello_clone/entity/tagdetail.dart';
import 'dao/user_dao.dart';
import 'dao/attachmentdetail_dao.dart';
import 'dao/board_dao.dart';
import 'dao/card_dao.dart';
import 'dao/checklist_dao.dart';
import 'dao/comment_dao.dart';
import 'dao/commentdetail_dao.dart';
import 'dao/file_dao.dart';
import 'dao/group_dao.dart';
import 'dao/groupdetail_dao.dart';
import 'dao/history_dao.dart';
import 'dao/list_dao.dart';
import 'dao/tag_dao.dart';
import 'dao/tagdetail_dao.dart';

import 'entity/user.dart';

@Database(version: 1, entities: [User, AttachmentDetail, Board, Card, CheckList, Comment, CommentDetail, File, Group, GroupDetail, History, List, Tag, TagDetail])
abstract class AppDatabase extends FloorDatabase {
  UserDao get userDao;
  AttachmentDetailDao get attachmentdetailDao;
  BoardDao get boardDao;
  CardDao get cardDao;
  CheckListDao get checklistDao;
  CommentDao get commentDao;
  CommentDetailDao get commentdetailDao;
  FileDao get fileDao;
  GroupDao get groupDao;
  GroupDetailDao get groupdetailDao;
  HistoryDao get historyDao;
  ListDao get listDao;
  TagDao get tagDao;
  TagDetailDao get tagDetailDao;
}