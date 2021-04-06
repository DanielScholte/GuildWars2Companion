import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:guildwars2_companion/core/widgets/cached_image.dart';
import 'package:guildwars2_companion/core/widgets/card.dart';
import 'package:guildwars2_companion/features/achievement/models/achievement.dart';
import 'package:guildwars2_companion/features/item/widgets/item_box.dart';

class AchievementBitsCard extends StatelessWidget {
  final Achievement achievement;
  final bool includeProgression;

  AchievementBitsCard({
    @required this.achievement,
    @required this.includeProgression
  });

  @override
  Widget build(BuildContext context) {
    if (achievement.bits.any((b) => b.type == 'Text')) {
      return CompanionCard(
        child: Column(
          children: <Widget>[
            Padding(
              padding: EdgeInsets.only(bottom: 8.0),
              child: Text(
                'Objectives',
                style: Theme.of(context).textTheme.headline2,
              ),
            ),
            Column(
              children: achievement.bits
                .map((i) => Row(
                  children: <Widget>[
                    if (includeProgression &&
                      achievement.progress != null &&
                      ((achievement.progress.bits != null &&
                      achievement.progress.bits.contains(achievement.bits.indexOf(i)))
                      || achievement.progress.done))
                      Icon(
                        FontAwesomeIcons.check,
                        size: 20.0,
                      )
                    else
                      Container(
                        width: 20.0,
                        child: Icon(
                          FontAwesomeIcons.solidCircle,
                          size: 6.0,
                        ),
                      ),
                  Expanded(
                    child: Padding(
                        padding: EdgeInsets.all(4.0),
                        child: Text(
                          i.text,
                          style: Theme.of(context).textTheme.bodyText1,
                          textAlign: TextAlign.left,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    )
                  ],
                ))
                .toList(),
              ),
          ],
        ),
      );
    }

    return CompanionCard(
      child: Column(
        children: <Widget>[
          Padding(
            padding: EdgeInsets.only(bottom: 8.0),
            child: Text(
              'Collection',
              style: Theme.of(context).textTheme.headline2,
            ),
          ),
          Column(
            children: achievement.bits
              .map((i) {
                switch (i.type) {
                  case 'Item':
                    return _ItemBit(
                      achievement: achievement,
                      bit: i,
                      bitIndex: achievement.bits.indexOf(i),
                      includeProgress: includeProgression
                    );
                  case 'Minipet':
                  case 'Skin':
                    return _SkinItemBit(
                      achievement: achievement,
                      bit: i,
                      includeProgress: includeProgression
                    );
                  default:
                    return Container();
                }
              })
              .toList(),
          ),
        ],
      ),
    );
  }
}

class _ItemBit extends StatelessWidget {
  final Achievement achievement;
  final AchievementBits bit;
  final bool includeProgress;
  final int bitIndex;

  _ItemBit({
    @required this.achievement,
    @required this.bit,
    @required this.includeProgress,
    @required this.bitIndex
  });

  @override
  Widget build(BuildContext context) {
    if (bit.item == null) {
      return Row(
        children: <Widget>[
          Text(
            'Unknown item',
            style: Theme.of(context).textTheme.bodyText1,
          ),
        ],
      );
    }

    return Padding(
      padding: const EdgeInsets.all(2.0),
      child: Row(
        children: <Widget>[
          CompanionItemBox(
            item: bit.item,
            size: 40.0,
            hero: '${bit.id} $bitIndex',
            markCompleted: includeProgress &&
              achievement.progress != null &&
              ((achievement.progress.bits != null &&
              achievement.progress.bits.contains(achievement.bits.indexOf(bit))
              || achievement.progress.done)),
          ),
          Expanded(
            child: Padding(
              padding: EdgeInsets.all(4.0),
              child: Text(
                bit.item.name,
                style: Theme.of(context).textTheme.bodyText1,
                textAlign: TextAlign.left,
                overflow: TextOverflow.ellipsis,
              ),
            ),
          )
        ],
      ),
    );
  }
}

class _SkinItemBit extends StatelessWidget {
  final Achievement achievement;
  final AchievementBits bit;
  final bool includeProgress;

  _SkinItemBit({
    @required this.achievement,
    @required this.bit,
    @required this.includeProgress,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(2.0),
      child: Row(
        children: <Widget>[
          Container(
            width: 40.0,
            height: 40.0,
            child: ClipRRect(
              borderRadius: BorderRadius.circular(6.0),
              child: Stack(
                children: <Widget>[
                  CompanionCachedImage(
                    imageUrl: bit.type == 'Skin' ? bit.skin.icon : bit.mini.icon,
                    color: Colors.black,
                    iconSize: 20,
                    fit: BoxFit.fill,
                  ),
                  if (includeProgress &&
                    achievement.progress != null &&
                    ((achievement.progress.bits != null &&
                    achievement.progress.bits.contains(achievement.bits.indexOf(bit)))
                    || achievement.progress.done))
                    Container(
                      width: double.infinity,
                      height: double.infinity,
                      color: Colors.white60,
                      alignment: Alignment.center,
                      child: Icon(
                        FontAwesomeIcons.check,
                        size: 20.0,
                      ),
                    )
                ],
              ),
            ),
          ),
          Expanded(
            child: Padding(
              padding: EdgeInsets.all(4.0),
              child: Text(
                bit.type == 'Skin' ? bit.skin.name : bit.mini.name,
                style: Theme.of(context).textTheme.bodyText1,
                textAlign: TextAlign.left,
                overflow: TextOverflow.ellipsis,
              ),
            ),
          )
        ],
      ),
    );
  }
}