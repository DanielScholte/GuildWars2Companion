import 'package:guildwars2_companion/core/database_configurations/base.dart';
import 'package:sqflite_migration/sqflite_migration.dart';

class AchievementConfiguration extends DatabaseConfiguration {
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
    'ALTER TABLE achievements ADD COLUMN cache_version INTEGER DEFAULT 1'
  ];

  AchievementConfiguration() : super(
    name: 'achievements.db',
    tableName: 'achievements',
    migrationConfig: MigrationConfig(
      initializationScript: _initializationScripts,
      migrationScripts: _migrationScripts
    )
  );
}