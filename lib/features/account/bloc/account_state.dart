import 'package:guildwars2_companion/features/account/models/account.dart';
import 'package:guildwars2_companion/features/account/models/token_entry.dart';
import 'package:guildwars2_companion/features/account/models/token_info.dart';
import 'package:meta/meta.dart';

@immutable
abstract class AccountState {}

class UnauthenticatedState extends AccountState {
  final String message;
  final List<TokenEntry> tokens;
  final bool tokenAdded;

  UnauthenticatedState(this.tokens, this.message, this.tokenAdded);
}

class LoadingAccountState extends AccountState {}

class AuthenticatedState extends AccountState {
  final Account account;
  final TokenInfo tokenInfo;

  AuthenticatedState(this.account, this.tokenInfo);
}