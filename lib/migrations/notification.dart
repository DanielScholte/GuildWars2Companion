import 'package:sqflite_migration/sqflite_migration.dart';

class NotificationMigrations {
  static final List<String> _initializationScripts = [
    '''
      CREATE TABLE notifications(
        id INTEGER PRIMARY KEY,
        type INTEGER,
        event_id TEXT,
        event_name TEXT,
        date_time INTEGER,
        spawn_date_time INTEGER,
        offset INTEGER
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