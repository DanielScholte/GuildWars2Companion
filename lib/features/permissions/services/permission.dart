import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:guildwars2_companion/features/achievement/bloc/achievement_bloc.dart';
import 'package:guildwars2_companion/features/bank/bloc/bank_bloc.dart';
import 'package:guildwars2_companion/features/character/bloc/character_bloc.dart';
import 'package:guildwars2_companion/features/trading_post/bloc/bloc.dart';
import 'package:guildwars2_companion/features/wallet/bloc/bloc.dart';

class PermissionService {
  void loadBlocsWithPermissions(BuildContext context, List<String> permissions) {
    if (permissions.contains('characters')) {
      BlocProvider.of<CharacterBloc>(context).add(LoadCharactersEvent());
    }

    if (permissions.contains('inventories') || permissions.contains('builds')) {
      BlocProvider.of<BankBloc>(context).add(LoadBankEvent(
        loadBank: permissions.contains('inventories'),
        loadBuilds: permissions.contains('builds')
      ));
    }

    if (permissions.contains('tradingpost')) {
      BlocProvider.of<TradingPostBloc>(context).add(LoadTradingPostEvent());
    }

    BlocProvider.of<AchievementBloc>(context).add(LoadAchievementsEvent(
      includeProgress: permissions.contains('progression')
    ));

    if (permissions.contains('wallet')) {
      BlocProvider.of<WalletBloc>(context).add(LoadWalletEvent());
    }
  }
}