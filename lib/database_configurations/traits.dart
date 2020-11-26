import 'package:sqflite_migration/sqflite_migration.dart';

import 'base.dart';

class TraitConfiguration extends DatabaseConfiguration {
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
        expiration_date DATE
      )
    '''
  ];

  static final List<String> _migrationScripts = [
    'ALTER TABLE traits ADD COLUMN cache_version INTEGER DEFAULT 1'
  ];

  TraitConfiguration() : super(
    name: 'traits.db',
    tableName: 'traits',
    migrationConfig: MigrationConfig(
      initializationScript: _initializationScripts,
      migrationScripts: _migrationScripts
    )
  );
}