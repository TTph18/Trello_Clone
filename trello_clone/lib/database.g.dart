// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'database.dart';

// **************************************************************************
// FloorGenerator
// **************************************************************************

class $FloorAppDatabase {
  /// Creates a database builder for a persistent database.
  /// Once a database is built, you should keep a reference to it and re-use it.
  static _$AppDatabaseBuilder databaseBuilder(String name) =>
      _$AppDatabaseBuilder(name);

  /// Creates a database builder for an in memory database.
  /// Information stored in an in memory database disappears when the process is killed.
  /// Once a database is built, you should keep a reference to it and re-use it.
  static _$AppDatabaseBuilder inMemoryDatabaseBuilder() =>
      _$AppDatabaseBuilder(null);
}

class _$AppDatabaseBuilder {
  _$AppDatabaseBuilder(this.name);

  final String? name;

  final List<Migration> _migrations = [];

  Callback? _callback;

  /// Adds migrations to the builder.
  _$AppDatabaseBuilder addMigrations(List<Migration> migrations) {
    _migrations.addAll(migrations);
    return this;
  }

  /// Adds a database [Callback] to the builder.
  _$AppDatabaseBuilder addCallback(Callback callback) {
    _callback = callback;
    return this;
  }

  /// Creates the database and initializes it.
  Future<AppDatabase> build() async {
    final path = name != null
        ? await sqfliteDatabaseFactory.getDatabasePath(name!)
        : ':memory:';
    final database = _$AppDatabase();
    database.database = await database.open(
      path,
      _migrations,
      _callback,
    );
    return database;
  }
}

class _$AppDatabase extends AppDatabase {
  _$AppDatabase([StreamController<String>? listener]) {
    changeListener = listener ?? StreamController<String>.broadcast();
  }

  UserDao? _userDaoInstance;

  AttachmentDetailDao? _attachmentdetailDaoInstance;

  BoardDao? _boardDaoInstance;

  CardDao? _cardDaoInstance;

  CheckListDao? _checklistDaoInstance;

  CommentDao? _commentDaoInstance;

  CommentDetailDao? _commentdetailDaoInstance;

  FileDao? _fileDaoInstance;

  GroupDao? _groupDaoInstance;

  GroupDetailDao? _groupdetailDaoInstance;

  HistoryDao? _historyDaoInstance;

  ListDao? _listDaoInstance;

  TagDao? _tagDaoInstance;

  TagDetailDao? _tagDetailDaoInstance;

  Future<sqflite.Database> open(String path, List<Migration> migrations,
      [Callback? callback]) async {
    final databaseOptions = sqflite.OpenDatabaseOptions(
      version: 1,
      onConfigure: (database) async {
        await database.execute('PRAGMA foreign_keys = ON');
      },
      onOpen: (database) async {
        await callback?.onOpen?.call(database);
      },
      onUpgrade: (database, startVersion, endVersion) async {
        await MigrationAdapter.runMigrations(
            database, startVersion, endVersion, migrations);

        await callback?.onUpgrade?.call(database, startVersion, endVersion);
      },
      onCreate: (database, version) async {
        await database.execute(
            'CREATE TABLE IF NOT EXISTS `User` (`account` TEXT NOT NULL, `password` TEXT NOT NULL, `user_name` TEXT NOT NULL, PRIMARY KEY (`account`))');
        await database.execute(
            'CREATE TABLE IF NOT EXISTS `AttachmentDetail` (`fileid` INTEGER NOT NULL, `tagid` INTEGER NOT NULL, `commentid` INTEGER NOT NULL, PRIMARY KEY (`fileid`))');
        await database.execute(
            'CREATE TABLE IF NOT EXISTS `Board` (`boardid` INTEGER NOT NULL, `boardname` TEXT NOT NULL, `discribe` TEXT NOT NULL, `creator` TEXT NOT NULL, `groupid` INTEGER NOT NULL, PRIMARY KEY (`boardid`))');
        await database.execute(
            'CREATE TABLE IF NOT EXISTS `Card` (`cardid` INTEGER NOT NULL, `cardname` TEXT NOT NULL, `content` TEXT NOT NULL, `comment` TEXT NOT NULL, `begindate` TEXT NOT NULL, `finishdate` TEXT NOT NULL, `number` INTEGER NOT NULL, PRIMARY KEY (`cardid`))');
        await database.execute(
            'CREATE TABLE IF NOT EXISTS `CheckList` (`cardid` INTEGER NOT NULL, `content` TEXT NOT NULL, `state` INTEGER NOT NULL, `number` INTEGER NOT NULL, PRIMARY KEY (`cardid`))');
        await database.execute(
            'CREATE TABLE IF NOT EXISTS `Comment` (`commentid` INTEGER NOT NULL, `content` TEXT NOT NULL, `account` TEXT NOT NULL, PRIMARY KEY (`commentid`))');
        await database.execute(
            'CREATE TABLE IF NOT EXISTS `CommentDetail` (`account` TEXT NOT NULL, `interactive` TEXT NOT NULL, `content` TEXT NOT NULL, `commentid` INTEGER NOT NULL, PRIMARY KEY (`account`, `commentid`))');
        await database.execute(
            'CREATE TABLE IF NOT EXISTS `File` (`fileid` INTEGER NOT NULL, `link` TEXT NOT NULL, PRIMARY KEY (`fileid`))');
        await database.execute(
            'CREATE TABLE IF NOT EXISTS `Group` (`groupid` INTEGER NOT NULL, `groupname` TEXT NOT NULL, `discribe` TEXT NOT NULL, PRIMARY KEY (`groupid`))');
        await database.execute(
            'CREATE TABLE IF NOT EXISTS `GroupDetail` (`groupid` INTEGER NOT NULL, `account` TEXT NOT NULL, PRIMARY KEY (`groupid`, `account`))');
        await database.execute(
            'CREATE TABLE IF NOT EXISTS `History` (`activityid` INTEGER NOT NULL, `account` TEXT NOT NULL, `content` TEXT NOT NULL, PRIMARY KEY (`activityid`))');
        await database.execute(
            'CREATE TABLE IF NOT EXISTS `ListItem` (`listid` TEXT NOT NULL, `listname` TEXT NOT NULL, `number` INTEGER NOT NULL, `boardid` INTEGER NOT NULL, PRIMARY KEY (`listid`))');
        await database.execute(
            'CREATE TABLE IF NOT EXISTS `Tag` (`tagid` INTEGER NOT NULL, `color` TEXT NOT NULL, PRIMARY KEY (`tagid`))');
        await database.execute(
            'CREATE TABLE IF NOT EXISTS `TagDetail` (`tagid` INTEGER NOT NULL, `color` TEXT NOT NULL, `content` TEXT NOT NULL, PRIMARY KEY (`tagid`))');

        await callback?.onCreate?.call(database, version);
      },
    );
    return sqfliteDatabaseFactory.openDatabase(path, options: databaseOptions);
  }

  @override
  UserDao get userDao {
    return _userDaoInstance ??= _$UserDao(database, changeListener);
  }

  @override
  AttachmentDetailDao get attachmentdetailDao {
    return _attachmentdetailDaoInstance ??=
        _$AttachmentDetailDao(database, changeListener);
  }

  @override
  BoardDao get boardDao {
    return _boardDaoInstance ??= _$BoardDao(database, changeListener);
  }

  @override
  CardDao get cardDao {
    return _cardDaoInstance ??= _$CardDao(database, changeListener);
  }

  @override
  CheckListDao get checklistDao {
    return _checklistDaoInstance ??= _$CheckListDao(database, changeListener);
  }

  @override
  CommentDao get commentDao {
    return _commentDaoInstance ??= _$CommentDao(database, changeListener);
  }

  @override
  CommentDetailDao get commentdetailDao {
    return _commentdetailDaoInstance ??=
        _$CommentDetailDao(database, changeListener);
  }

  @override
  FileDao get fileDao {
    return _fileDaoInstance ??= _$FileDao(database, changeListener);
  }

  @override
  GroupDao get groupDao {
    return _groupDaoInstance ??= _$GroupDao(database, changeListener);
  }

  @override
  GroupDetailDao get groupdetailDao {
    return _groupdetailDaoInstance ??=
        _$GroupDetailDao(database, changeListener);
  }

  @override
  HistoryDao get historyDao {
    return _historyDaoInstance ??= _$HistoryDao(database, changeListener);
  }

  @override
  ListDao get listDao {
    return _listDaoInstance ??= _$ListDao(database, changeListener);
  }

  @override
  TagDao get tagDao {
    return _tagDaoInstance ??= _$TagDao(database, changeListener);
  }

  @override
  TagDetailDao get tagDetailDao {
    return _tagDetailDaoInstance ??= _$TagDetailDao(database, changeListener);
  }
}

class _$UserDao extends UserDao {
  _$UserDao(this.database, this.changeListener)
      : _queryAdapter = QueryAdapter(database, changeListener),
        _userInsertionAdapter = InsertionAdapter(
            database,
            'User',
            (User item) => <String, Object?>{
                  'account': item.account,
                  'password': item.password,
                  'user_name': item.user_name
                },
            changeListener);

  final sqflite.DatabaseExecutor database;

  final StreamController<String> changeListener;

  final QueryAdapter _queryAdapter;

  final InsertionAdapter<User> _userInsertionAdapter;

  @override
  Future<List<User>> findAllPersons() async {
    return _queryAdapter.queryList('SELECT * FROM USER',
        mapper: (Map<String, Object?> row) => User(row['account'] as String,
            row['password'] as String, row['user_name'] as String));
  }

  @override
  Stream<User?> findUserById(String id) {
    return _queryAdapter.queryStream('SELECT * FROM USER WHERE Account = ?1',
        mapper: (Map<String, Object?> row) => User(row['account'] as String,
            row['password'] as String, row['user_name'] as String),
        arguments: [id],
        queryableName: 'User',
        isView: false);
  }

  @override
  Future<void> insertUser(User user) async {
    await _userInsertionAdapter.insert(user, OnConflictStrategy.abort);
  }
}

class _$AttachmentDetailDao extends AttachmentDetailDao {
  _$AttachmentDetailDao(this.database, this.changeListener)
      : _queryAdapter = QueryAdapter(database),
        _attachmentDetailInsertionAdapter = InsertionAdapter(
            database,
            'AttachmentDetail',
            (AttachmentDetail item) => <String, Object?>{
                  'fileid': item.fileid,
                  'tagid': item.tagid,
                  'commentid': item.commentid
                });

  final sqflite.DatabaseExecutor database;

  final StreamController<String> changeListener;

  final QueryAdapter _queryAdapter;

  final InsertionAdapter<AttachmentDetail> _attachmentDetailInsertionAdapter;

  @override
  Future<List<AttachmentDetail>> findAll() async {
    return _queryAdapter.queryList('SELECT * FROM ATTACHMENTDETAIL',
        mapper: (Map<String, Object?> row) => AttachmentDetail(
            row['fileid'] as int,
            row['tagid'] as int,
            row['commentid'] as int));
  }

  @override
  Future<void> insertAttachmentDetail(AttachmentDetail attachmentDetail) async {
    await _attachmentDetailInsertionAdapter.insert(
        attachmentDetail, OnConflictStrategy.abort);
  }
}

class _$BoardDao extends BoardDao {
  _$BoardDao(this.database, this.changeListener)
      : _queryAdapter = QueryAdapter(database, changeListener),
        _boardInsertionAdapter = InsertionAdapter(
            database,
            'Board',
            (Board item) => <String, Object?>{
                  'boardid': item.boardid,
                  'boardname': item.boardname,
                  'discribe': item.discribe,
                  'creator': item.creator,
                  'groupid': item.groupid
                },
            changeListener);

  final sqflite.DatabaseExecutor database;

  final StreamController<String> changeListener;

  final QueryAdapter _queryAdapter;

  final InsertionAdapter<Board> _boardInsertionAdapter;

  @override
  Future<List<Board>> findAll() async {
    return _queryAdapter.queryList('SELECT * FROM BOARD',
        mapper: (Map<String, Object?> row) => Board(
            row['boardid'] as int,
            row['boardname'] as String,
            row['discribe'] as String,
            row['creator'] as String,
            row['groupid'] as int));
  }

  @override
  Stream<Board?> findById(int id) {
    return _queryAdapter.queryStream('SELECT * FROM BOARD WHERE BoardID = ?1',
        mapper: (Map<String, Object?> row) => Board(
            row['boardid'] as int,
            row['boardname'] as String,
            row['discribe'] as String,
            row['creator'] as String,
            row['groupid'] as int),
        arguments: [id],
        queryableName: 'Board',
        isView: false);
  }

  @override
  Future<void> insertBoard(Board board) async {
    await _boardInsertionAdapter.insert(board, OnConflictStrategy.abort);
  }
}

class _$CardDao extends CardDao {
  _$CardDao(this.database, this.changeListener)
      : _queryAdapter = QueryAdapter(database, changeListener),
        _cardInsertionAdapter = InsertionAdapter(
            database,
            'Card',
            (Card item) => <String, Object?>{
                  'cardid': item.cardid,
                  'cardname': item.cardname,
                  'content': item.content,
                  'comment': item.comment,
                  'begindate': item.begindate,
                  'finishdate': item.finishdate,
                  'number': item.number
                },
            changeListener);

  final sqflite.DatabaseExecutor database;

  final StreamController<String> changeListener;

  final QueryAdapter _queryAdapter;

  final InsertionAdapter<Card> _cardInsertionAdapter;

  @override
  Future<List<Card>> findAll() async {
    return _queryAdapter.queryList('SELECT * FROM CARD',
        mapper: (Map<String, Object?> row) => Card(
            row['cardid'] as int,
            row['cardname'] as String,
            row['content'] as String,
            row['comment'] as String,
            row['begindate'] as String,
            row['finishdate'] as String,
            row['number'] as int));
  }

  @override
  Stream<Card?> findById(int id) {
    return _queryAdapter.queryStream('SELECT * FROM CARD WHERE CARDID = ?1',
        mapper: (Map<String, Object?> row) => Card(
            row['cardid'] as int,
            row['cardname'] as String,
            row['content'] as String,
            row['comment'] as String,
            row['begindate'] as String,
            row['finishdate'] as String,
            row['number'] as int),
        arguments: [id],
        queryableName: 'Card',
        isView: false);
  }

  @override
  Future<void> insertCard(Card card) async {
    await _cardInsertionAdapter.insert(card, OnConflictStrategy.abort);
  }
}

class _$CheckListDao extends CheckListDao {
  _$CheckListDao(this.database, this.changeListener)
      : _queryAdapter = QueryAdapter(database, changeListener),
        _checkListInsertionAdapter = InsertionAdapter(
            database,
            'CheckList',
            (CheckList item) => <String, Object?>{
                  'cardid': item.cardid,
                  'content': item.content,
                  'state': item.state,
                  'number': item.number
                },
            changeListener);

  final sqflite.DatabaseExecutor database;

  final StreamController<String> changeListener;

  final QueryAdapter _queryAdapter;

  final InsertionAdapter<CheckList> _checkListInsertionAdapter;

  @override
  Future<List<CheckList>> findAll() async {
    return _queryAdapter.queryList('SELECT * FROM CHECKLIST',
        mapper: (Map<String, Object?> row) => CheckList(
            row['cardid'] as int,
            row['content'] as String,
            row['number'] as int,
            row['state'] as int));
  }

  @override
  Stream<CheckList?> findById(int id) {
    return _queryAdapter.queryStream(
        'SELECT * FROM CHECKLIST WHERE CardID = ?1',
        mapper: (Map<String, Object?> row) => CheckList(
            row['cardid'] as int,
            row['content'] as String,
            row['number'] as int,
            row['state'] as int),
        arguments: [id],
        queryableName: 'CheckList',
        isView: false);
  }

  @override
  Future<void> insertCheckList(CheckList checkList) async {
    await _checkListInsertionAdapter.insert(
        checkList, OnConflictStrategy.abort);
  }
}

class _$CommentDao extends CommentDao {
  _$CommentDao(this.database, this.changeListener)
      : _queryAdapter = QueryAdapter(database, changeListener),
        _commentInsertionAdapter = InsertionAdapter(
            database,
            'Comment',
            (Comment item) => <String, Object?>{
                  'commentid': item.commentid,
                  'content': item.content,
                  'account': item.account
                },
            changeListener);

  final sqflite.DatabaseExecutor database;

  final StreamController<String> changeListener;

  final QueryAdapter _queryAdapter;

  final InsertionAdapter<Comment> _commentInsertionAdapter;

  @override
  Future<List<Comment>> findAll() async {
    return _queryAdapter.queryList('SELECT * FROM COMMENT',
        mapper: (Map<String, Object?> row) => Comment(row['account'] as String,
            row['content'] as String, row['commentid'] as int));
  }

  @override
  Stream<Comment?> findById(int id) {
    return _queryAdapter.queryStream(
        'SELECT * FROM COMMENT WHERE CommentID = ?1',
        mapper: (Map<String, Object?> row) => Comment(row['account'] as String,
            row['content'] as String, row['commentid'] as int),
        arguments: [id],
        queryableName: 'Comment',
        isView: false);
  }

  @override
  Future<void> insertComment(Comment comment) async {
    await _commentInsertionAdapter.insert(comment, OnConflictStrategy.abort);
  }
}

class _$CommentDetailDao extends CommentDetailDao {
  _$CommentDetailDao(this.database, this.changeListener)
      : _queryAdapter = QueryAdapter(database, changeListener),
        _commentDetailInsertionAdapter = InsertionAdapter(
            database,
            'CommentDetail',
            (CommentDetail item) => <String, Object?>{
                  'account': item.account,
                  'interactive': item.interactive,
                  'content': item.content,
                  'commentid': item.commentid
                },
            changeListener);

  final sqflite.DatabaseExecutor database;

  final StreamController<String> changeListener;

  final QueryAdapter _queryAdapter;

  final InsertionAdapter<CommentDetail> _commentDetailInsertionAdapter;

  @override
  Future<List<CommentDetail>> findAll() async {
    return _queryAdapter.queryList('SELECT * FROM COMMENTDETAIL',
        mapper: (Map<String, Object?> row) => CommentDetail(
            row['account'] as String,
            row['interactive'] as String,
            row['content'] as String,
            row['commentid'] as int));
  }

  @override
  Stream<CommentDetail?> findById(int id) {
    return _queryAdapter.queryStream(
        'SELECT * FROM COMMENTDETAIL WHERE CommentID = ?1',
        mapper: (Map<String, Object?> row) => CommentDetail(
            row['account'] as String,
            row['interactive'] as String,
            row['content'] as String,
            row['commentid'] as int),
        arguments: [id],
        queryableName: 'CommentDetail',
        isView: false);
  }

  @override
  Future<void> insertCommentDetail(CommentDetail commentDetail) async {
    await _commentDetailInsertionAdapter.insert(
        commentDetail, OnConflictStrategy.abort);
  }
}

class _$FileDao extends FileDao {
  _$FileDao(this.database, this.changeListener)
      : _queryAdapter = QueryAdapter(database, changeListener),
        _fileInsertionAdapter = InsertionAdapter(
            database,
            'File',
            (File item) =>
                <String, Object?>{'fileid': item.fileid, 'link': item.link},
            changeListener);

  final sqflite.DatabaseExecutor database;

  final StreamController<String> changeListener;

  final QueryAdapter _queryAdapter;

  final InsertionAdapter<File> _fileInsertionAdapter;

  @override
  Future<List<File>> findAll() async {
    return _queryAdapter.queryList('SELECT * FROM FILE',
        mapper: (Map<String, Object?> row) =>
            File(row['fileid'] as int, row['link'] as String));
  }

  @override
  Stream<File?> findById(int id) {
    return _queryAdapter.queryStream(
        'SELECT * FROM CHECKLIST WHERE FileID = ?1',
        mapper: (Map<String, Object?> row) =>
            File(row['fileid'] as int, row['link'] as String),
        arguments: [id],
        queryableName: 'File',
        isView: false);
  }

  @override
  Future<void> insertCheckList(File file) async {
    await _fileInsertionAdapter.insert(file, OnConflictStrategy.abort);
  }
}

class _$GroupDao extends GroupDao {
  _$GroupDao(this.database, this.changeListener)
      : _queryAdapter = QueryAdapter(database, changeListener),
        _groupInsertionAdapter = InsertionAdapter(
            database,
            'Group',
            (Group item) => <String, Object?>{
                  'groupid': item.groupid,
                  'groupname': item.groupname,
                  'discribe': item.discribe
                },
            changeListener);

  final sqflite.DatabaseExecutor database;

  final StreamController<String> changeListener;

  final QueryAdapter _queryAdapter;

  final InsertionAdapter<Group> _groupInsertionAdapter;

  @override
  Future<List<Group>> findAll() async {
    return _queryAdapter.queryList('SELECT * FROM GROUP',
        mapper: (Map<String, Object?> row) => Group(row['groupid'] as int,
            row['groupname'] as String, row['discribe'] as String));
  }

  @override
  Stream<Group?> findById(int id) {
    return _queryAdapter.queryStream(
        'SELECT * FROM CHECKLIST WHERE GroupID = ?1',
        mapper: (Map<String, Object?> row) => Group(row['groupid'] as int,
            row['groupname'] as String, row['discribe'] as String),
        arguments: [id],
        queryableName: 'Group',
        isView: false);
  }

  @override
  Future<void> insertGroup(Group group) async {
    await _groupInsertionAdapter.insert(group, OnConflictStrategy.abort);
  }
}

class _$GroupDetailDao extends GroupDetailDao {
  _$GroupDetailDao(this.database, this.changeListener)
      : _queryAdapter = QueryAdapter(database, changeListener),
        _groupDetailInsertionAdapter = InsertionAdapter(
            database,
            'GroupDetail',
            (GroupDetail item) => <String, Object?>{
                  'groupid': item.groupid,
                  'account': item.account
                },
            changeListener);

  final sqflite.DatabaseExecutor database;

  final StreamController<String> changeListener;

  final QueryAdapter _queryAdapter;

  final InsertionAdapter<GroupDetail> _groupDetailInsertionAdapter;

  @override
  Future<List<GroupDetail>> findAll() async {
    return _queryAdapter.queryList('SELECT * FROM CHECKLIST',
        mapper: (Map<String, Object?> row) =>
            GroupDetail(row['groupid'] as int, row['account'] as String));
  }

  @override
  Stream<GroupDetail?> findById(int id) {
    return _queryAdapter.queryStream(
        'SELECT * FROM CHECKLIST WHERE GroupID = ?1',
        mapper: (Map<String, Object?> row) =>
            GroupDetail(row['groupid'] as int, row['account'] as String),
        arguments: [id],
        queryableName: 'GroupDetail',
        isView: false);
  }

  @override
  Future<void> insertGroupDetail(GroupDetail groupDetail) async {
    await _groupDetailInsertionAdapter.insert(
        groupDetail, OnConflictStrategy.abort);
  }
}

class _$HistoryDao extends HistoryDao {
  _$HistoryDao(this.database, this.changeListener)
      : _queryAdapter = QueryAdapter(database, changeListener),
        _historyInsertionAdapter = InsertionAdapter(
            database,
            'History',
            (History item) => <String, Object?>{
                  'activityid': item.activityid,
                  'account': item.account,
                  'content': item.content
                },
            changeListener);

  final sqflite.DatabaseExecutor database;

  final StreamController<String> changeListener;

  final QueryAdapter _queryAdapter;

  final InsertionAdapter<History> _historyInsertionAdapter;

  @override
  Future<List<History>> findAll() async {
    return _queryAdapter.queryList('SELECT * FROM HISTORY',
        mapper: (Map<String, Object?> row) => History(row['activityid'] as int,
            row['account'] as String, row['content'] as String));
  }

  @override
  Stream<History?> findById(int id) {
    return _queryAdapter.queryStream(
        'SELECT * FROM HISTORY WHERE ActivityID = ?1',
        mapper: (Map<String, Object?> row) => History(row['activityid'] as int,
            row['account'] as String, row['content'] as String),
        arguments: [id],
        queryableName: 'History',
        isView: false);
  }

  @override
  Future<void> insertCheckList(History history) async {
    await _historyInsertionAdapter.insert(history, OnConflictStrategy.abort);
  }
}

class _$ListDao extends ListDao {
  _$ListDao(this.database, this.changeListener)
      : _queryAdapter = QueryAdapter(database, changeListener),
        _listItemInsertionAdapter = InsertionAdapter(
            database,
            'ListItem',
            (ListItem item) => <String, Object?>{
                  'listid': item.listid,
                  'listname': item.listname,
                  'number': item.number,
                  'boardid': item.boardid
                },
            changeListener);

  final sqflite.DatabaseExecutor database;

  final StreamController<String> changeListener;

  final QueryAdapter _queryAdapter;

  final InsertionAdapter<ListItem> _listItemInsertionAdapter;

  @override
  Stream<ListItem?> findById(int id) {
    return _queryAdapter.queryStream(
        'SELECT * FROM CHECKLIST WHERE ListID = ?1',
        mapper: (Map<String, Object?> row) => ListItem(
            row['listid'] as String,
            row['listname'] as String,
            row['number'] as int,
            row['boardid'] as int),
        arguments: [id],
        queryableName: 'ListItem',
        isView: false);
  }

  @override
  Future<void> insertList(ListItem list) async {
    await _listItemInsertionAdapter.insert(list, OnConflictStrategy.abort);
  }
}

class _$TagDao extends TagDao {
  _$TagDao(this.database, this.changeListener)
      : _queryAdapter = QueryAdapter(database, changeListener),
        _tagInsertionAdapter = InsertionAdapter(
            database,
            'Tag',
            (Tag item) =>
                <String, Object?>{'tagid': item.tagid, 'color': item.color},
            changeListener);

  final sqflite.DatabaseExecutor database;

  final StreamController<String> changeListener;

  final QueryAdapter _queryAdapter;

  final InsertionAdapter<Tag> _tagInsertionAdapter;

  @override
  Future<List<Tag>> findAll() async {
    return _queryAdapter.queryList('SELECT * FROM CHECKLIST',
        mapper: (Map<String, Object?> row) =>
            Tag(row['tagid'] as int, row['color'] as String));
  }

  @override
  Stream<Tag?> findById(int id) {
    return _queryAdapter.queryStream('SELECT * FROM CHECKLIST WHERE TagID = ?1',
        mapper: (Map<String, Object?> row) =>
            Tag(row['tagid'] as int, row['color'] as String),
        arguments: [id],
        queryableName: 'Tag',
        isView: false);
  }

  @override
  Future<void> insertTag(Tag tag) async {
    await _tagInsertionAdapter.insert(tag, OnConflictStrategy.abort);
  }
}

class _$TagDetailDao extends TagDetailDao {
  _$TagDetailDao(this.database, this.changeListener)
      : _queryAdapter = QueryAdapter(database, changeListener),
        _tagDetailInsertionAdapter = InsertionAdapter(
            database,
            'TagDetail',
            (TagDetail item) => <String, Object?>{
                  'tagid': item.tagid,
                  'color': item.color,
                  'content': item.content
                },
            changeListener);

  final sqflite.DatabaseExecutor database;

  final StreamController<String> changeListener;

  final QueryAdapter _queryAdapter;

  final InsertionAdapter<TagDetail> _tagDetailInsertionAdapter;

  @override
  Future<List<TagDetail>> findAll() async {
    return _queryAdapter.queryList('SELECT * FROM CHECKLIST',
        mapper: (Map<String, Object?> row) => TagDetail(row['tagid'] as int,
            row['color'] as String, row['content'] as String));
  }

  @override
  Stream<TagDetail?> findById(int id) {
    return _queryAdapter.queryStream('SELECT * FROM CHECKLIST WHERE TagID = ?1',
        mapper: (Map<String, Object?> row) => TagDetail(row['tagid'] as int,
            row['color'] as String, row['content'] as String),
        arguments: [id],
        queryableName: 'TagDetail',
        isView: false);
  }

  @override
  Future<void> insertTagDetail(TagDetail tagDetail) async {
    await _tagDetailInsertionAdapter.insert(
        tagDetail, OnConflictStrategy.abort);
  }
}
