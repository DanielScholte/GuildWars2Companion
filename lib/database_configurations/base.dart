import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'package:sqflite_migration/sqflite_migration.dart';

abstract class DatabaseConfiguration {
  final String name;
  final String tableName;
  final MigrationConfig migrationConfig;

  DatabaseConfiguration({
    this.name,
    this.tableName,
    this.migrationConfig
  });

  Future<String> getPath() async => join(await getDatabasesPath(), name);
}