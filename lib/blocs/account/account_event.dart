import 'package:meta/meta.dart';

@immutable
abstract class AccountEvent {}

class AuthenticateEvent extends AccountEvent {
  final String token;

  AuthenticateEvent(this.token);
}