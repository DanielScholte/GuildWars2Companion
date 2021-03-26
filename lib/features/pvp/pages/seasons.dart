import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:guildwars2_companion/features/pvp/bloc/pvp_bloc.dart';
import 'package:guildwars2_companion/features/pvp/models/season.dart';
import 'package:guildwars2_companion/core/widgets/accent.dart';
import 'package:guildwars2_companion/core/widgets/appbar.dart';
import 'package:guildwars2_companion/core/widgets/button.dart';
import 'package:guildwars2_companion/features/error/widgets/error.dart';
import 'package:guildwars2_companion/core/widgets/list_view.dart';
import 'package:guildwars2_companion/features/pvp/widgets/pvp_season_rank.dart';
import 'package:intl/intl.dart';

import 'season.dart';

class SeasonsPage extends StatelessWidget {
  final DateFormat _dateFormat = DateFormat('yyyy-MM-dd');

  @override
  Widget build(BuildContext context) {
    return CompanionAccent(
      lightColor: Colors.orange,
      child: Scaffold(
        appBar: CompanionAppBar(
          color: Colors.orange,
          title: 'Ranked seasons',
        ),
        body: BlocBuilder<PvpBloc, PvpState>(
          builder: (context, state) {
            if (state is ErrorPvpState) {
              return Center(
                child: CompanionError(
                  title: 'PvP Seasons',
                  onTryAgain: () =>
                    BlocProvider.of<PvpBloc>(context).add(LoadPvpEvent()),
                ),
              );
            }

            if (state is LoadedPvpState && state.pvpStandings.isEmpty) {
              return Center(
                child: Text(
                  'No ranked seasons with participation found',
                  style: Theme.of(context).textTheme.headline2,
                ),
              );
            }

            if (state is LoadedPvpState) {
              return CompanionListView(
                children: state.pvpStandings
                  .map((s) {
                    PvpSeasonRank rank = s.season.ranks
                      .lastWhere((r) => 
                        s.current.rating != null && r.tiers.any((t) => t.rating <= s.current.rating),
                        orElse: () => s.season.ranks.first
                      );
                    return CompanionButton(
                      hero: s.seasonId,
                      leading: CompanionPvpSeasonRank(
                        rank: rank,
                        standing: s,
                      ),
                      subtitles: [
                        _dateFormat.format(DateTime.parse(s.season.start)) +
                          (s.season.end != null ? ' - ' + _dateFormat.format(DateTime.parse(s.season.end)) : '')
                      ],
                      color: Colors.blueGrey,
                      title: s.season.name,
                      onTap: () => Navigator.of(context).push(MaterialPageRoute(
                        builder: (context) => SeasonPage(
                          rank: rank,
                          standing: s,
                        )
                      )),
                    );
                  })
                  .toList(),
              );
            }

            return Center(
              child: CircularProgressIndicator()
            );
          },
        ),
      ),
    );
  }
}