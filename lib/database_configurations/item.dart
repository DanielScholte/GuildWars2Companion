import 'package:sqflite_migration/sqflite_migration.dart';

import 'base.dart';

class ItemConfiguration extends DatabaseConfiguration {
  static final List<String> _initializationScripts = [
    '''
      CREATE TABLE items(
        id INTEGER PRIMARY KEY,
        name TEXT,
        description TEXT,
        type TEXT,
        rarity TEXT,
        icon TEXT,
        level INTEGER,
        vendorValue INTEGER,
        expiration_date DATE,
        details_type TEXT,
        details_description TEXT,
        details_weightClass TEXT,
        details_unlockType TEXT,
        details_name TEXT,
        details_defense INTEGER,
        details_size INTEGER,
        details_durationMs INTEGER,
        details_charges INTEGER,
        details_minPower INTEGER,
        details_maxPower INTEGER
      )
    '''
  ];

  static final List<String> _migrationScripts = [
    'ALTER TABLE items ADD COLUMN cache_version INTEGER DEFAULT 1',
    'ALTER TABLE items ADD COLUMN flags TEXT'
  ];

  ItemConfiguration() : super(
    name: 'items.db',
    tableName: 'items',
    migrationConfig: MigrationConfig(
      initializationScript: _initializationScripts,
      migrationScripts: _migrationScripts
    )
  );
}