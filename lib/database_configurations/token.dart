import 'package:sqflite_migration/sqflite_migration.dart';

class TokenConfiguration {
  static final List<String> _initializationScripts = [
    '''
      CREATE TABLE tokens(
        id INTEGER PRIMARY KEY,
        name TEXT,
        token TEXT,
        date TEXT
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