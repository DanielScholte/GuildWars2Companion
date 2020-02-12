import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:guildwars2_companion/blocs/pvp/pvp_bloc.dart';
import 'package:guildwars2_companion/models/pvp/season.dart';
import 'package:guildwars2_companion/widgets/appbar.dart';
import 'package:guildwars2_companion/widgets/button.dart';
import 'package:guildwars2_companion/widgets/error.dart';
import 'package:guildwars2_companion/widgets/pvp_season_rank.dart';
import 'package:intl/intl.dart';

import 'season.dart';

class SeasonsPage extends StatelessWidget {
  
  final DateFormat _dateFormat = DateFormat('yyyy-MM-dd');

  @override
  Widget build(BuildContext context) {
    return Theme(
      data: Theme.of(context).copyWith(accentColor: Colors.orange),
      child: Scaffold(
        appBar: CompanionAppBar(
          color: Colors.orange,
          foregroundColor: Colors.white,
          title: 'Ranked seasons',
          elevation: 4.0,
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
                  style: Theme.of(context).textTheme.display2.copyWith(
                    color: Colors.black
                  )
                ),
              );
            }

            if (state is LoadedPvpState) {
              return ListView(
                padding: EdgeInsets.only(top: 8.0),
                children: state.pvpStandings
                  .map((s) {
                    PvpSeasonRank rank = s.season.ranks
                      .lastWhere((r) => 
                        r.tiers.any((t) => t.rating <= s.current.rating),
                        orElse: () => s.season.ranks.first
                      );
                    return CompanionButton(
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