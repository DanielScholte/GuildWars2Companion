import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:guildwars2_companion/blocs/achievement/bloc.dart';
import 'package:guildwars2_companion/widgets/accent.dart';
import 'package:guildwars2_companion/widgets/appbar.dart';
import 'package:guildwars2_companion/widgets/error.dart';
import 'package:guildwars2_companion/widgets/button.dart';
import 'package:guildwars2_companion/widgets/list_view.dart';

import 'dailies.dart';

class DailyCategoriesPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return CompanionAccent(
      lightColor: Colors.indigo,
      child: Scaffold(
        appBar: CompanionAppBar(
          title: 'Dailies',
          color: Colors.indigo,
        ),
        body: BlocBuilder<AchievementBloc, AchievementState>(
          builder: (context, state) {
            if (state is ErrorAchievementsState) {
              return Center(
                child: CompanionError(
                  title: 'the achievements',
                  onTryAgain: () =>
                    BlocProvider.of<AchievementBloc>(context).add(LoadAchievementsEvent(
                      includeProgress: state.includesProgress
                    )),
                ),
              );
            }

            if (state is LoadedAchievementsState) {
              return RefreshIndicator(
                backgroundColor: Theme.of(context).accentColor,
                color: Theme.of(context).cardColor,
                onRefresh: () async {
                  BlocProvider.of<AchievementBloc>(context).add(LoadAchievementsEvent(
                    includeProgress: state.includesProgress
                  ));
                  await Future.delayed(Duration(milliseconds: 200), () {});
                },
                child: CompanionListView(
                  children: [
                    CompanionButton(
                      title: 'PvE',
                      color: Colors.green[600],
                      leading: Image.asset('assets/button_headers/pve.png'),
                      onTap: () => Navigator.of(context).push(MaterialPageRoute(
                        builder: (context) => DailiesPage('PvE')
                      )),
                    ),
                    CompanionButton(
                      title: 'PvP',
                      color: Colors.blue,
                      leading: Image.asset('assets/button_headers/pvp.png'),
                      onTap: () => Navigator.of(context).push(MaterialPageRoute(
                        builder: (context) => DailiesPage('PvP')
                      )),
                    ),
                    CompanionButton(
                      title: 'WvW',
                      color: Colors.red[600],
                      leading: Image.asset('assets/button_headers/wvw.png'),
                      onTap: () => Navigator.of(context).push(MaterialPageRoute(
                        builder: (context) => DailiesPage('WvW')
                      )),
                    ),
                    CompanionButton(
                      title: 'Fractals',
                      color: Colors.deepPurple,
                      leading: Image.asset('assets/button_headers/fractals.png'),
                      onTap: () => Navigator.of(context).push(MaterialPageRoute(
                        builder: (context) => DailiesPage('Fractals')
                      )),
                    ),
                  ]
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
