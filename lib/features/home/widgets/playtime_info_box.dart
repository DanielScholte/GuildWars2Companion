import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:guildwars2_companion/core/utils/guild_wars.dart';
import 'package:guildwars2_companion/core/widgets/info_box.dart';
import 'package:guildwars2_companion/features/account/bloc/account_bloc.dart';

class HomePlaytimeInfoBox extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AccountBloc, AccountState>(
      builder: (context, state) {
        if (state is AuthenticatedState) {
          return CompanionInfoBox(
            header: 'Playtime',
            text: GuildWarsUtil.calculatePlayTime(state.account.age).toString() + 'h',
            loading: false,
          );
        }

        return CompanionInfoBox(
          header: 'Playtime',
        );
      },
    );
  }
}