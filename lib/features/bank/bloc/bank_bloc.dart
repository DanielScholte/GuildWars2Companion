import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:flutter/widgets.dart';
import 'package:guildwars2_companion/features/bank/models/bank_data.dart';
import 'package:guildwars2_companion/features/bank/repositories/bank.dart';
import 'package:guildwars2_companion/features/build/models/build.dart';
import 'package:guildwars2_companion/features/build/repositories/build.dart';
import './bloc.dart';

class BankBloc extends Bloc<BankEvent, BankState> {
  final BankRepository bankRepository;
  final BuildRepository buildRepository;

  bool loadBank;
  bool loadBuilds;

  BankBloc({
    @required this.bankRepository,
    @required this.buildRepository,
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

        BankData bankData;
        List<Build> builds;

        if (loadBank) {
          bankData = await bankRepository.getBankData();
        }

        if (loadBuilds) {
          builds = await buildRepository.getBuildStorage();
        }

        yield LoadedBankState(
          bank: loadBank ? bankData.bank : null,
          inventory: loadBank ? bankData.inventory : null,
          materialCategories: loadBank ? bankData.materialCategories : null,
          builds: loadBuilds ? builds : null,
        );
      } catch (_) {
        yield ErrorBankState();
      }
    }
  }
}
