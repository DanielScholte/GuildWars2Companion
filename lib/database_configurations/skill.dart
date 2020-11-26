import 'package:sqflite_migration/sqflite_migration.dart';

import 'base.dart';

class SkillConfiguration extends DatabaseConfiguration {
  static final List<String> _initializationScripts = [
    '''
      CREATE TABLE skills(
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
    'ALTER TABLE skills RENAME COLUMN expiration_date TO cache_expiration_date',
    'ALTER TABLE skills ADD COLUMN cache_version INTEGER DEFAULT 2'
  ];

  SkillConfiguration() : super(
    name: 'skills.db',
    tableName: 'skills',
    migrationConfig: MigrationConfig(
      initializationScript: _initializationScripts,
      migrationScripts: _migrationScripts
    )
  );
}