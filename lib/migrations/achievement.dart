import 'package:sqflite_migration/sqflite_migration.dart';

class AchievementMigrations {
  static final List<String> _initializationScripts = [
    '''
      CREATE TABLE achievements(
        id INTEGER PRIMARY KEY,
        icon TEXT,
        name TEXT,
        description TEXT,
        requirement TEXT,
        lockedText TEXT,
        prerequisites TEXT,
        pointCap INTEGER,
        bits TEXT,
        tiers TEXT,
        rewards TEXT,
        expiration_date DATE
      )
    '''
  ];

  static final List<String> _migrationScripts = [

  ];

  static final MigrationConfig config = MigrationConfig(
    initializationScript: _initializationScripts,
    migrationScripts: _migrationScripts,
  );
}