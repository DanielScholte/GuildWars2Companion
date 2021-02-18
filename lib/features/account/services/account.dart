import 'package:dio/dio.dart';
import 'package:flutter/widgets.dart';
import 'package:guildwars2_companion/features/account/database_configurations/token.dart';
import 'package:guildwars2_companion/models/account/token_entry.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'package:sqflite_migration/sqflite_migration.dart';
import '../../../models/account/account.dart';
import '../../../models/account/token_info.dart';
import '../../../utils/urls.dart';

class AccountService {
  List<TokenEntry> _tokenEntries;

  Dio dio;

  AccountService({
    @required this.dio,
  });

  Future<Database> _getDatabase() async {
    return await openDatabaseWithMigration(
      join(await getDatabasesPath(), 'tokens.db'),
      TokenConfiguration.config
    );
  }

  Future<void> _loadTokens() async {
    Database database = await _getDatabase();

    final List<Map<String, dynamic>> tokens = await database.query('tokens');
    _tokenEntries = List.generate(tokens.length, (i) => TokenEntry.fromDb(tokens[i]));

    database.close();

    return;
  }

  Future<List<TokenEntry>> getTokens() async {
    if (_tokenEntries == null) {
      await _loadTokens();
    }

    return _tokenEntries;
  }

  Future<void> addToken(TokenEntry token) async {
    if (_tokenEntries == null) {
      await _loadTokens();
    }

    Database database = await _getDatabase();

    _tokenEntries.add(token);

    token.id = await database.insert('tokens', token.toDb(), conflictAlgorithm: ConflictAlgorithm.ignore);

    database.close();

    return;
  }

  Future<void> removeToken(int tokenId) async {
    if (_tokenEntries == null) {
      await _loadTokens();
    }

    Database database = await _getDatabase();

    _tokenEntries.removeWhere((t) => t.id == tokenId);

    await database.delete(
      'tokens',
      where: 'id = ?',
      whereArgs: [tokenId],
    );

    database.close();

    return;
  }

  Future<Account> getAccount(String token) async {
    final response = await dio.get(
      Urls.accountUrl,
      options: Options(
        headers: {
          'Authorization': 'Bearer $token',
        },
      ),
    );

    if (response.statusCode == 200) {
      return Account.fromJson(response.data);
    }

    throw Exception();
  }

  Future<TokenInfo> getTokenInfo(String token) async {
    final response = await dio.get(
      Urls.tokenInfoUrl,
      options: Options(
        headers: {
          'Authorization': 'Bearer $token',
        },
      ),
    );

    if (response.statusCode == 200) {
      return TokenInfo.fromJson(response.data);
    }

    throw Exception();
  }
}
