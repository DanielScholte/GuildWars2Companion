part of 'bank_bloc.dart';

@immutable
abstract class BankEvent {}

class LoadBankEvent extends BankEvent {
  final bool loadBank;
  final bool loadBuilds;

  LoadBankEvent({
    this.loadBank,
    this.loadBuilds
  });
}