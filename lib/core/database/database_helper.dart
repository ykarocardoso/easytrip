import 'dart:io';
import 'package:path/path.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';

class DatabaseHelper {
  // ─── Singleton ───────────────────────────────────────────────────────────
  DatabaseHelper._();
  static final DatabaseHelper instance = DatabaseHelper._();

  static Database? _db;

  // ─── Initialisation ──────────────────────────────────────────────────────
  /// Must be called once before any DB operation (in main()).
  static Future<void> init() async {
    if (Platform.isWindows || Platform.isLinux || Platform.isMacOS) {
      sqfliteFfiInit();
      databaseFactory = databaseFactoryFfi;
    }
  }

  Future<Database> get database async {
    if (_db != null) return _db!;
    _db = await _openDatabase();
    return _db!;
  }

  Future<Database> _openDatabase() async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, 'easytrip.db');

    return openDatabase(
      path,
      version: 1,
      onCreate: _onCreate,
    );
  }

  // ─── Schema ──────────────────────────────────────────────────────────────
  Future<void> _onCreate(Database db, int version) async {
    await db.execute('''
      CREATE TABLE IF NOT EXISTS user_profile (
        id              INTEGER PRIMARY KEY,
        name            TEXT    NOT NULL DEFAULT 'Usuário EasyTrip',
        email           TEXT    NOT NULL DEFAULT 'usuario@easytrip.com',
        avatar_url      TEXT    NOT NULL DEFAULT 'https://images.unsplash.com/photo-1544005313-94ddf0286df2?q=80&w=300',
        avatar_file_path TEXT
      )
    ''');

    await db.execute('''
      CREATE TABLE IF NOT EXISTS favorites (
        place_id TEXT PRIMARY KEY
      )
    ''');

    // Insert default profile row so we always have one record.
    await db.insert('user_profile', {
      'id': 1,
      'name': 'Usuário EasyTrip',
      'email': 'usuario@easytrip.com',
      'avatar_url':
          'https://images.unsplash.com/photo-1544005313-94ddf0286df2?q=80&w=300',
      'avatar_file_path': null,
    });
  }

  // ─── user_profile CRUD ───────────────────────────────────────────────────
  Future<Map<String, dynamic>?> getUserProfile() async {
    final db = await database;
    final rows = await db.query('user_profile', where: 'id = ?', whereArgs: [1]);
    return rows.isEmpty ? null : rows.first;
  }

  Future<void> saveUserProfile({
    String? name,
    String? email,
    String? avatarUrl,
    String? avatarFilePath,
    bool clearFilePath = false,
  }) async {
    final db = await database;

    // Build update map with only provided fields.
    final Map<String, dynamic> values = {};
    if (name != null) values['name'] = name;
    if (email != null) values['email'] = email;
    if (avatarUrl != null) values['avatar_url'] = avatarUrl;
    if (avatarFilePath != null) values['avatar_file_path'] = avatarFilePath;
    if (clearFilePath) values['avatar_file_path'] = null;

    if (values.isEmpty) return;

    final count = await db.update(
      'user_profile',
      values,
      where: 'id = ?',
      whereArgs: [1],
    );

    // If no row existed yet, insert it (defensive).
    if (count == 0) {
      await db.insert('user_profile', {'id': 1, ...values});
    }
  }

  // ─── favorites CRUD ──────────────────────────────────────────────────────
  Future<Set<String>> getFavoriteIds() async {
    final db = await database;
    final rows = await db.query('favorites');
    return rows.map((r) => r['place_id'] as String).toSet();
  }

  Future<void> setFavorite(String placeId, {required bool isFavorited}) async {
    final db = await database;
    if (isFavorited) {
      await db.insert(
        'favorites',
        {'place_id': placeId},
        conflictAlgorithm: ConflictAlgorithm.ignore,
      );
    } else {
      await db.delete('favorites', where: 'place_id = ?', whereArgs: [placeId]);
    }
  }
}
