import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:guildwars2_companion/core/widgets/accent.dart';
import 'package:guildwars2_companion/core/widgets/appbar.dart';
import 'package:guildwars2_companion/features/error/widgets/error.dart';
import 'package:guildwars2_companion/core/widgets/list_view.dart';
import 'package:guildwars2_companion/features/achievement/bloc/achievement_bloc.dart';
import 'package:guildwars2_companion/features/achievement/models/daily.dart';
import 'package:guildwars2_companion/features/achievement/widgets/achievement_button.dart';

class DailiesPage extends StatelessWidget {
  final String category;

  DailiesPage(this.category);

  @override
  Widget build(BuildContext context) {
    return CompanionAccent(
      lightColor: _getColor(),
      child: DefaultTabController(
        length: 2,
        child: Scaffold(
          appBar: CompanionAppBar(
            title: '$category Dailies',
            color: _getColor(),
            elevation: 0.0,
          ),
          body: Column(
            children: <Widget>[
              Material(
                color: Theme.of(context).brightness == Brightness.light ? _getColor() : Theme.of(context).cardColor,
                elevation: Theme.of(context).brightness == Brightness.light ? 4.0 : 0.0,
                child: TabBar(
                  indicatorColor: Colors.white,
                  tabs: [
                    Tab(
                      child: Text(
                        'Today',
                        style: TextStyle(
                          fontSize: 16.0
                        ),
                      ),
                    ),
                    Tab(
                      child: Text(
                        'Tomorrow',
                        style: TextStyle(
                          fontSize: 16.0
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Expanded(
                child: BlocBuilder<AchievementBloc, AchievementState>(
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
                      return TabBarView(
                        children: <Widget>[
                          _DailyTab(
                            category: category,
                            dailies: _getDailies(state.dailies),
                            prefix: 'today',
                            includeProgression: state.includesProgress
                          ),
                          _DailyTab(
                            category: category,
                            dailies: _getDailies(state.dailiesTomorrow),
                            prefix: 'tomorrow',
                            includeProgression: state.includesProgress
                          ),
                        ],
                      );
                    }

                    return Center(
                      child: CircularProgressIndicator(),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Color _getColor() {
    switch (category) {
      case 'PvE':
        return Colors.green[600];
      case 'PvP':
        return Colors.blue;
      case 'WvW':
        return Colors.red[600];
      case 'Fractals':
        return Colors.deepPurple;
      default:
        return Colors.blueGrey;
    }
  }

  List<Daily> _getDailies(DailyGroup group) {
    switch (category) {
      case 'PvE':
        return group.pve;
      case 'PvP':
        return group.pvp;
      case 'WvW':
        return group.wvw;
      case 'Fractals':
        return group.fractals;
      default:
        return [];
    }
  }
}

class _DailyTab extends StatelessWidget {
  final String category;
  final List<Daily> dailies;
  final String prefix;
  final bool includeProgression;

  _DailyTab({
    @required this.category,
    @required this.dailies,
    @required this.prefix,
    @required this.includeProgression
  });

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      backgroundColor: Theme.of(context).accentColor,
      color: Theme.of(context).cardColor,
      onRefresh: () async {
        BlocProvider.of<AchievementBloc>(context).add(LoadAchievementsEvent(
          includeProgress: includeProgression
        ));
        await Future.delayed(Duration(milliseconds: 200), () {});
      },
      child: CompanionListView(
        children: dailies
          .map((d) => AchievementButton(
            achievement: d.achievementInfo,
            hero: '$prefix ${d.id} ${dailies.indexOf(d)}',
            includeProgression: includeProgression,
            levels: d.level.min == 80 ? 'Level 80' : 'Level ${d.level.min} - ${d.level.max}',
            categoryIcon: _getIcon(),
          ))
          .toList(),
      )
    );
  }

  String _getIcon() {
    switch (category) {
      case 'PvE':
        return 'assets/button_headers/pve.png';
      case 'PvP':
        return 'assets/button_headers/pvp.png';
      case 'WvW':
        return 'assets/button_headers/wvw.png';
      case 'Fractals':
        return 'assets/button_headers/fractals.png';
      default:
        return 'assets/button_headers/pve.png';
    }
  }
}