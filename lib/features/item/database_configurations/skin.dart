import 'package:sqflite_migration/sqflite_migration.dart';

import '../../../core/database_configurations/base.dart';

class SkinConfiguration extends DatabaseConfiguration {
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
    'ALTER TABLE skins ADD COLUMN cache_version INTEGER DEFAULT 1'
  ];

  SkinConfiguration() : super(
    name: 'skins.db',
    tableName: 'skins',
    migrationConfig: MigrationConfig(
      initializationScript: _initializationScripts,
      migrationScripts: _migrationScripts
    )
  );
}