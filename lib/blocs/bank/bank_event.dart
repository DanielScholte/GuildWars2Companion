import 'package:meta/meta.dart';

@immutable
abstract class BankEvent {}

class LoadBankEvent extends BankEvent {}