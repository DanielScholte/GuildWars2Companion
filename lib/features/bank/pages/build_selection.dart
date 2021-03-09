import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:guildwars2_companion/core/utils/guild_wars.dart';
import 'package:guildwars2_companion/core/widgets/accent.dart';
import 'package:guildwars2_companion/core/widgets/appbar.dart';
import 'package:guildwars2_companion/core/widgets/button.dart';
import 'package:guildwars2_companion/features/error/widgets/error.dart';
import 'package:guildwars2_companion/core/widgets/list_view.dart';
import 'package:guildwars2_companion/features/bank/bloc/bank_bloc.dart';
import 'package:guildwars2_companion/features/build/pages/build.dart';

class BankBuildSelectionPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return CompanionAccent(
      lightColor: Colors.purple,
      child: Scaffold(
        appBar: CompanionAppBar(
          title: 'Build storage',
          color: Colors.purple,
        ),
        body: BlocBuilder<BankBloc, BankState>(
          builder: (context, state) {
            if (state is ErrorBankState) {
              return Center(
                child: CompanionError(
                  title: 'the build storage',
                  onTryAgain: () => BlocProvider.of<BankBloc>(context).add(LoadBankEvent()),
                ),
              );
            }

            if (state is LoadedBankState) {
              return RefreshIndicator(
                backgroundColor: Theme.of(context).accentColor,
                color: Theme.of(context).cardColor,
                onRefresh: () async {
                  BlocProvider.of<BankBloc>(context).add(LoadBankEvent());
                  await Future.delayed(Duration(milliseconds: 200), () {});
                },
                child: CompanionListView(
                  children: state.builds
                    .map((b) => CompanionButton(
                      color: GuildWarsUtil.getProfessionColor(b.profession),
                      title: b.name != null && b.name.isNotEmpty ? b.name : 'Nameless build',
                      height: 64,
                      onTap: () => Navigator.of(context).push(MaterialPageRoute(
                        builder: (context) => BuildPage(b)
                      )),
                      leading: ColorFiltered(
                        child: Image.asset(
                          'assets/professions/${b.profession.toLowerCase()}.png',
                          width: 48,
                          height: 48,
                        ),
                        colorFilter: ColorFilter.mode(Colors.white, BlendMode.srcATop),
                      ),
                    ))
                    .toList()
                ),
              );
            }

            return Center(
              child: CircularProgressIndicator(),
            );
          },
        ),
      ),
    );
  }
}