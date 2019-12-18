import 'package:guildwars2_companion/models/account/account.dart';
import 'package:guildwars2_companion/models/account/token_info.dart';
import 'package:meta/meta.dart';

@immutable
abstract class AccountState {}

class UnauthenticatedState extends AccountState {}

class LoadingAccountState extends AccountState {}

class LoadedAccountState extends AccountState {
  final Account account;
  final TokenInfo tokenInfo;

  LoadedAccountState(this.account, this.tokenInfo);
}