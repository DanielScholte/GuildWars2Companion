part of 'account_bloc.dart';

@immutable
abstract class AccountEvent {}

class AuthenticateEvent extends AccountEvent {
  final String token;

  AuthenticateEvent(this.token);
}

class SetupAccountEvent extends AccountEvent {}

class AddTokenEvent extends AccountEvent {
  final String token;

  AddTokenEvent(this.token);
}

class RemoveTokenEvent extends AccountEvent {
  final int tokenId;

  RemoveTokenEvent(this.tokenId);
}

class UnauthenticateEvent extends AccountEvent {}