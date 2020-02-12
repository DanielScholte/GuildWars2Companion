import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:guildwars2_companion/models/pvp/season.dart';
import 'package:guildwars2_companion/models/pvp/standing.dart';

class CompanionPvpSeasonRank extends StatelessWidget {
  final PvpSeasonRank rank;
  final PvpStanding standing;

  CompanionPvpSeasonRank({
    @required this.rank,
    @required this.standing
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 60,
      height: 60,
      child: Column(
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
                  color: standing.current.rating >= r.rating ? Colors.white : null,
                ),
              ))
              .toList(),
          )
        ],
      ),
    );
  }
}