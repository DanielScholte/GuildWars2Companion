import 'package:sqflite_migration/sqflite_migration.dart';

class SkinMigrations {
  static final List<String> _initializationScripts = [
    '''
      CREATE TABLE skins(
        id INTEGER PRIMARY KEY,
        name TEXT,
        type TEXT,
        rarity TEXT,
        icon TEXT,
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