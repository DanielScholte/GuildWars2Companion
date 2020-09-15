import 'package:sqflite_migration/sqflite_migration.dart';

class ItemMigrations {
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
        details_maxPower INTEGER,
        flags_AccountBindOnUse INTEGER,
        flags_AccountBound INTEGER,
        flags_Attuned INTEGER,
        flags_BulkConsume INTEGER,
        flags_DeleteWarning INTEGER,
        flags_HideSuffix INTEGER,
        flags_Infused INTEGER,
        flags_MonsterOnly INTEGER,
        flags_NoMysticForge INTEGER,
        flags_NoSalvage INTEGER,
        flags_NoSell INTEGER,
        flags_NotUpgradeable INTEGER,
        flags_NoUnderwater INTEGER,
        flags_SoulbindOnAcquire INTEGER,
        flags_SoulBindOnUse INTEGER,
        flags_Tonic INTEGER,
        flags_Unique INTEGER
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