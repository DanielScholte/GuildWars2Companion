import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:guildwars2_companion/blocs/pvp/pvp_bloc.dart';
import 'package:guildwars2_companion/models/pvp/season.dart';
import 'package:guildwars2_companion/widgets/appbar.dart';
import 'package:guildwars2_companion/widgets/button.dart';
import 'package:guildwars2_companion/widgets/error.dart';
import 'package:intl/intl.dart';

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
                  style: TextStyle(
                    color: Colors.black87,
                    fontWeight: FontWeight.w500,
                    fontSize: 18.0
                  ),
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
                      leading: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          CachedNetworkImage(
                            height: 42.0,
                            imageUrl: rank.overlay,
                            placeholder: (context, url) => Theme(
                              data: Theme.of(context).copyWith(accentColor: Colors.white),
                              child: CircularProgressIndicator(),
                            ),
                            errorWidget: (context, url, error) => Center(child: Icon(
                              FontAwesomeIcons.dizzy,
                              size: 20,
                              color: Colors.white,
                            )),
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: rank.tiers
                              .map((r) => Container(
                                height: 12.0,
                                width: 12.0,
                                margin: EdgeInsets.symmetric(horizontal: 2.0),
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(9.0),
                                  border: Border.all(color: Colors.white, width: 2.0),
                                  color: s.current.rating >= r.rating ? Colors.white : null,
                                ),
                              ))
                              .toList(),
                          )
                        ],
                      ),
                      subtitles: [
                        _dateFormat.format(DateTime.parse(s.season.start)) +
                          (s.season.end != null ? ' - ' + _dateFormat.format(DateTime.parse(s.season.end)) : '')
                      ],
                      color: Colors.blueGrey,
                      title: s.season.name,
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