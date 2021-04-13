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
            'CREATE TABLE IF NOT EXISTS `User` (`account` TEXT NOT NULL, `mat khau` TEXT NOT NULL, `ten nguoi dung` TEXT NOT NULL, PRIMARY KEY (`account`))');
        await database.execute(
            'CREATE TABLE IF NOT EXISTS `AttachmentDetail` (`fileid` INTEGER NOT NULL, `ma nhan` INTEGER NOT NULL, `ma binh luan` INTEGER NOT NULL, PRIMARY KEY (`fileid`))');
        await database.execute(
            'CREATE TABLE IF NOT EXISTS `Board` (`boardid` TEXT NOT NULL, `ten bang` TEXT NOT NULL, `mo ta` TEXT NOT NULL, `tai khoan cua nguoi tao bang` TEXT NOT NULL, `ma nhom` TEXT NOT NULL, PRIMARY KEY (`boardid`))');
        await database.execute(
            'CREATE TABLE IF NOT EXISTS `Card` (`cardid` INTEGER NOT NULL, `ten the` TEXT NOT NULL, `noi dung` TEXT NOT NULL, `binh luan` TEXT NOT NULL, `ngay bat dau` TEXT NOT NULL, `ngay ket thuc` TEXT NOT NULL, `so thu tu` INTEGER NOT NULL, PRIMARY KEY (`cardid`))');
        await database.execute(
            'CREATE TABLE IF NOT EXISTS `CheckList` (`cardid` TEXT NOT NULL, `noi dung` TEXT NOT NULL, `trang thai (done = 1)` INTEGER NOT NULL, `so thu tu` INTEGER NOT NULL, PRIMARY KEY (`cardid`))');
        await database.execute(
            'CREATE TABLE IF NOT EXISTS `Comment` (`commentid` TEXT NOT NULL, `noi dung` TEXT NOT NULL, `nguoi binh luan` TEXT NOT NULL, PRIMARY KEY (`commentid`))');
        await database.execute(
            'CREATE TABLE IF NOT EXISTS `CommentDetail` (`account` TEXT NOT NULL, `tuong tac` TEXT NOT NULL, `noi dung` TEXT NOT NULL, `ma binh luan` TEXT NOT NULL, PRIMARY KEY (`account`))');
        await database.execute(
            'CREATE TABLE IF NOT EXISTS `File` (`fileid` TEXT NOT NULL, `duong dan file` TEXT NOT NULL, PRIMARY KEY (`fileid`))');
        await database.execute(
            'CREATE TABLE IF NOT EXISTS `Group` (`groupid` TEXT NOT NULL, `ten nhom` TEXT NOT NULL, `mo ta` TEXT NOT NULL, PRIMARY KEY (`groupid`))');
        await database.execute(
            'CREATE TABLE IF NOT EXISTS `GroupDetail` (`groupid` TEXT NOT NULL, `account` TEXT NOT NULL, PRIMARY KEY (`groupid`, `account`))');
        await database.execute(
            'CREATE TABLE IF NOT EXISTS `History` (`activityid` TEXT NOT NULL, `tai khoan` TEXT NOT NULL, `noi dung` TEXT NOT NULL, PRIMARY KEY (`activityid`))');
        await database.execute(
            'CREATE TABLE IF NOT EXISTS `ListItem` (`listid` TEXT NOT NULL, `ten danh sach` TEXT NOT NULL, `so thu tu` INTEGER NOT NULL, `ma bang` TEXT NOT NULL, PRIMARY KEY (`listid`))');
        await database.execute(
            'CREATE TABLE IF NOT EXISTS `Tag` (`tagid` TEXT NOT NULL, `color` TEXT NOT NULL, PRIMARY KEY (`tagid`))');
        await database.execute(
            'CREATE TABLE IF NOT EXISTS `TagDetail` (`tagid` TEXT NOT NULL, `mau` TEXT NOT NULL, `noi dung` TEXT NOT NULL, PRIMARY KEY (`tagid`))');

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
                  'mat khau': item.password,
                  'ten nguoi dung': item.user_name
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
            row['mat khau'] as String, row['ten nguoi dung'] as String));
  }

  @override
  Stream<User?> findPersonById(String id) {
    return _queryAdapter.queryStream('SELECT * FROM USER WHERE Account = ?1',
        mapper: (Map<String, Object?> row) => User(row['account'] as String,
            row['mat khau'] as String, row['ten nguoi dung'] as String),
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
                  'ma nhan': item.tagid,
                  'ma binh luan': item.commentid
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
            row['ma nhan'] as int,
            row['ma binh luan'] as int));
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
                  'ten bang': item.boardname,
                  'mo ta': item.discribe,
                  'tai khoan cua nguoi tao bang': item.creator,
                  'ma nhom': item.groupid
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
            row['boardid'] as String,
            row['ten bang'] as String,
            row['mo ta'] as String,
            row['tai khoan cua nguoi tao bang'] as String,
            row['ma nhom'] as String));
  }

  @override
  Stream<Board?> findById(int id) {
    return _queryAdapter.queryStream('SELECT * FROM BOARD WHERE BoardID = ?1',
        mapper: (Map<String, Object?> row) => Board(
            row['boardid'] as String,
            row['ten bang'] as String,
            row['mo ta'] as String,
            row['tai khoan cua nguoi tao bang'] as String,
            row['ma nhom'] as String),
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
                  'ten the': item.cardname,
                  'noi dung': item.content,
                  'binh luan': item.comment,
                  'ngay bat dau': item.begindate,
                  'ngay ket thuc': item.finishdate,
                  'so thu tu': item.number
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
            row['ten the'] as String,
            row['noi dung'] as String,
            row['binh luan'] as String,
            row['ngay bat dau'] as String,
            row['ngay ket thuc'] as String,
            row['so thu tu'] as int));
  }

  @override
  Stream<Card?> findById(int id) {
    return _queryAdapter.queryStream('SELECT * FROM CARD WHERE CARDID = ?1',
        mapper: (Map<String, Object?> row) => Card(
            row['cardid'] as int,
            row['ten the'] as String,
            row['noi dung'] as String,
            row['binh luan'] as String,
            row['ngay bat dau'] as String,
            row['ngay ket thuc'] as String,
            row['so thu tu'] as int),
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
                  'noi dung': item.content,
                  'trang thai (done = 1)': item.state,
                  'so thu tu': item.number
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
            row['cardid'] as String,
            row['noi dung'] as String,
            row['so thu tu'] as int,
            row['trang thai (done = 1)'] as int));
  }

  @override
  Stream<CheckList?> findById(int id) {
    return _queryAdapter.queryStream(
        'SELECT * FROM CHECKLIST WHERE CardID = ?1',
        mapper: (Map<String, Object?> row) => CheckList(
            row['cardid'] as String,
            row['noi dung'] as String,
            row['so thu tu'] as int,
            row['trang thai (done = 1)'] as int),
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
                  'noi dung': item.content,
                  'nguoi binh luan': item.account
                },
            changeListener);

  final sqflite.DatabaseExecutor database;

  final StreamController<String> changeListener;

  final QueryAdapter _queryAdapter;

  final InsertionAdapter<Comment> _commentInsertionAdapter;

  @override
  Future<List<Comment>> findAll() async {
    return _queryAdapter.queryList('SELECT * FROM COMMENT',
        mapper: (Map<String, Object?> row) => Comment(
            row['nguoi binh luan'] as String,
            row['noi dung'] as String,
            row['commentid'] as String));
  }

  @override
  Stream<Comment?> findById(int id) {
    return _queryAdapter.queryStream(
        'SELECT * FROM COMMENT WHERE CommentID = ?1',
        mapper: (Map<String, Object?> row) => Comment(
            row['nguoi binh luan'] as String,
            row['noi dung'] as String,
            row['commentid'] as String),
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
                  'tuong tac': item.interactive,
                  'noi dung': item.content,
                  'ma binh luan': item.commentid
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
            row['tuong tac'] as String,
            row['noi dung'] as String,
            row['ma binh luan'] as String));
  }

  @override
  Stream<CommentDetail?> findById(int id) {
    return _queryAdapter.queryStream(
        'SELECT * FROM COMMENTDETAIL WHERE CommentID = ?1',
        mapper: (Map<String, Object?> row) => CommentDetail(
            row['account'] as String,
            row['tuong tac'] as String,
            row['noi dung'] as String,
            row['ma binh luan'] as String),
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
            (File item) => <String, Object?>{
                  'fileid': item.fileid,
                  'duong dan file': item.link
                },
            changeListener);

  final sqflite.DatabaseExecutor database;

  final StreamController<String> changeListener;

  final QueryAdapter _queryAdapter;

  final InsertionAdapter<File> _fileInsertionAdapter;

  @override
  Future<List<File>> findAll() async {
    return _queryAdapter.queryList('SELECT * FROM FILE',
        mapper: (Map<String, Object?> row) =>
            File(row['fileid'] as String, row['duong dan file'] as String));
  }

  @override
  Stream<File?> findById(int id) {
    return _queryAdapter.queryStream(
        'SELECT * FROM CHECKLIST WHERE FileID = ?1',
        mapper: (Map<String, Object?> row) =>
            File(row['fileid'] as String, row['duong dan file'] as String),
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
                  'ten nhom': item.groupname,
                  'mo ta': item.discribe
                },
            changeListener);

  final sqflite.DatabaseExecutor database;

  final StreamController<String> changeListener;

  final QueryAdapter _queryAdapter;

  final InsertionAdapter<Group> _groupInsertionAdapter;

  @override
  Future<List<Group>> findAll() async {
    return _queryAdapter.queryList('SELECT * FROM GROUP',
        mapper: (Map<String, Object?> row) => Group(row['groupid'] as String,
            row['ten nhom'] as String, row['mo ta'] as String));
  }

  @override
  Stream<Group?> findById(int id) {
    return _queryAdapter.queryStream(
        'SELECT * FROM CHECKLIST WHERE GroupID = ?1',
        mapper: (Map<String, Object?> row) => Group(row['groupid'] as String,
            row['ten nhom'] as String, row['mo ta'] as String),
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
            GroupDetail(row['groupid'] as String, row['account'] as String));
  }

  @override
  Stream<GroupDetail?> findById(int id) {
    return _queryAdapter.queryStream(
        'SELECT * FROM CHECKLIST WHERE GroupID = ?1',
        mapper: (Map<String, Object?> row) =>
            GroupDetail(row['groupid'] as String, row['account'] as String),
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
                  'tai khoan': item.account,
                  'noi dung': item.content
                },
            changeListener);

  final sqflite.DatabaseExecutor database;

  final StreamController<String> changeListener;

  final QueryAdapter _queryAdapter;

  final InsertionAdapter<History> _historyInsertionAdapter;

  @override
  Future<List<History>> findAll() async {
    return _queryAdapter.queryList('SELECT * FROM HISTORY',
        mapper: (Map<String, Object?> row) => History(
            row['activityid'] as String,
            row['tai khoan'] as String,
            row['noi dung'] as String));
  }

  @override
  Stream<History?> findById(int id) {
    return _queryAdapter.queryStream(
        'SELECT * FROM HISTORY WHERE ActivityID = ?1',
        mapper: (Map<String, Object?> row) => History(
            row['activityid'] as String,
            row['tai khoan'] as String,
            row['noi dung'] as String),
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
                  'ten danh sach': item.listname,
                  'so thu tu': item.number,
                  'ma bang': item.boardid
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
            row['ten danh sach'] as String,
            row['so thu tu'] as int,
            row['ma bang'] as String),
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
            Tag(row['tagid'] as String, row['color'] as String));
  }

  @override
  Stream<Tag?> findById(int id) {
    return _queryAdapter.queryStream('SELECT * FROM CHECKLIST WHERE TagID = ?1',
        mapper: (Map<String, Object?> row) =>
            Tag(row['tagid'] as String, row['color'] as String),
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
                  'mau': item.color,
                  'noi dung': item.content
                },
            changeListener);

  final sqflite.DatabaseExecutor database;

  final StreamController<String> changeListener;

  final QueryAdapter _queryAdapter;

  final InsertionAdapter<TagDetail> _tagDetailInsertionAdapter;

  @override
  Future<List<TagDetail>> findAll() async {
    return _queryAdapter.queryList('SELECT * FROM CHECKLIST',
        mapper: (Map<String, Object?> row) => TagDetail(row['tagid'] as String,
            row['mau'] as String, row['noi dung'] as String));
  }

  @override
  Stream<TagDetail?> findById(int id) {
    return _queryAdapter.queryStream('SELECT * FROM CHECKLIST WHERE TagID = ?1',
        mapper: (Map<String, Object?> row) => TagDetail(row['tagid'] as String,
            row['mau'] as String, row['noi dung'] as String),
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
