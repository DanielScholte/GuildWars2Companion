import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:flutter/widgets.dart';
import 'package:guildwars2_companion/models/bank/bank_data.dart';
import 'package:guildwars2_companion/repositories/bank.dart';
import './bloc.dart';

class BankBloc extends Bloc<BankEvent, BankState> {
  final BankRepository bankRepository;

  BankBloc({
    @required this.bankRepository,
  }): super(LoadingBankState());

  @override
  Stream<BankState> mapEventToState(
    BankEvent event,
  ) async* {
    if (event is LoadBankEvent) {
      try {
        yield LoadingBankState();

        BankData bankData = await bankRepository.getBankData();

        yield LoadedBankState(bankData.bank, bankData.inventory, bankData.materialCategories);
      } catch (_) {
        yield ErrorBankState();
      }
    }
  }
}
