part of 'account_bloc.dart';

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