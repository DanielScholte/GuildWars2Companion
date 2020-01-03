import 'package:meta/meta.dart';

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
  final String token;

  RemoveTokenEvent(this.token);
}

class UnauthenticateEvent extends AccountEvent {}