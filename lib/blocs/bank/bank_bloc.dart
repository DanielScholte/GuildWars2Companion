import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:flutter/widgets.dart';
import 'package:guildwars2_companion/models/bank/bank_data.dart';
import 'package:guildwars2_companion/repositories/bank.dart';
import './bloc.dart';

class BankBloc extends Bloc<BankEvent, BankState> {
  final BankRepository bankRepository;

  bool loadBank;
  bool loadBuilds;

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

        if (event.loadBank != null) {
          loadBank = event.loadBank;
          loadBuilds = event.loadBuilds;
        }

        BankData bankData = await bankRepository.getBankData();

        yield LoadedBankState(bankData.bank, bankData.inventory, bankData.materialCategories);
      } catch (_) {
        yield ErrorBankState();
      }
    }
  }
}
