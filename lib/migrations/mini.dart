import 'package:sqflite_migration/sqflite_migration.dart';

class MiniMigrations {
  static final List<String> _initializationScripts = [
    '''
      CREATE TABLE minis(
        id INTEGER PRIMARY KEY,
        name TEXT,
        icon TEXT,
        display_order INTEGER,
        itemId INTEGER,
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