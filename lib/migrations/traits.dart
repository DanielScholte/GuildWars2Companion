import 'package:sqflite_migration/sqflite_migration.dart';

class TraitsMigrations {
  static final List<String> _initializationScripts = [
    '''
      CREATE TABLE traits(
        id INTEGER PRIMARY KEY,
        name TEXT,
        description TEXT,
        icon TEXT,
        type TEXT,
        slot TEXT,
        chatLink TEXT,
        tier INTEGER,
        facts TEXT,
        traitedFacts TEXT,
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