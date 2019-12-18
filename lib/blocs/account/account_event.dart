import 'package:guildwars2_companion/blocs/account/bloc.dart';
import 'package:meta/meta.dart';

@immutable
abstract class AccountEvent {}

class AuthenticateEvent extends AccountEvent {
  final String token;

  AuthenticateEvent(this.token);
}

class SetAccountState extends AccountEvent {
  final AccountState state;

  SetAccountState(this.state);
}