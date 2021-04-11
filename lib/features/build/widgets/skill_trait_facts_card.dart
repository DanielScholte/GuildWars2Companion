import 'package:flutter/material.dart';
import 'package:guildwars2_companion/core/utils/guild_wars.dart';
import 'package:guildwars2_companion/core/widgets/cached_image.dart';
import 'package:guildwars2_companion/core/widgets/info_card.dart';
import 'package:guildwars2_companion/core/widgets/info_row.dart';
import 'package:guildwars2_companion/features/build/models/skill_trait.dart';

enum FactsType {
  STATS,
  EFFECTS
}

class BuildSkillTraitFactsCard extends StatelessWidget {
  final List<Fact> facts;
  final FactsType type;

  BuildSkillTraitFactsCard({@required this.facts, @required this.type});

  @override
  Widget build(BuildContext context) {
    if (facts.isEmpty) {
      return Container();
    }

    return CompanionInfoCard(
      title: type == FactsType.EFFECTS ? 'Effects': 'Stats',
      child: Column(
        children: facts
          .map((f) => _FactRow(fact: f))  
          .toList()
      ),
    );
  }
}

class _FactRow extends StatelessWidget {
  final Fact fact;

  _FactRow({@required this.fact});

  @override
  Widget build(BuildContext context) {
    switch (fact.type) {
      case 'AttributeAdjust':
        return CompanionInfoRow(
          leadingWidget: _FactRowLeading(fact: fact),
          header: fact.target,
          text: '+${fact.value}',
        );
      case 'BuffConversion':
        return CompanionInfoRow(
          leadingWidget: _FactRowLeading(fact: fact),
          header: fact.target,
          text: '+${fact.percent}%',
        );
      case 'Buff':
      case 'PrefixedBuff':
        return CompanionInfoRow(
          leadingWidget: _FactRowLeading(fact: fact),
          header: '${fact.status ?? ''}'
            + (fact.applyCount != null && fact.applyCount > 1 ? ' x${fact.applyCount}' : '')
            + (fact.duration != null && fact.duration > 0 ? ' (${fact.duration}s)' : ''),
          text: GuildWarsUtil.removeOnlyHtml(fact.description),
        );
      case 'ComboField':
        return CompanionInfoRow(
          leadingWidget: _FactRowLeading(fact: fact),
          header: fact.text,
          text: fact.fieldType,
        );
      case 'ComboFinisher':
        return CompanionInfoRow(
          leadingWidget: _FactRowLeading(fact: fact),
          header: fact.text,
          text: fact.finisherType,
        );
      case 'Distance':
        return CompanionInfoRow(
          leadingWidget: _FactRowLeading(fact: fact),
          header: fact.text,
          text: fact.distance.toString(),
        );
      case 'Duration':
      case 'Time':
        return CompanionInfoRow(
          leadingWidget: _FactRowLeading(fact: fact),
          header: fact.text,
          text: '${fact.duration}s',
        );
      case 'NoData':
        return CompanionInfoRow(
          leadingWidget: _FactRowLeading(fact: fact),
          header: fact.text,
          text: '',
        );
      case 'Range':
      case 'Number':
        return CompanionInfoRow(
          leadingWidget: _FactRowLeading(fact: fact),
          header: fact.text,
          text: fact.value.toString(),
        );
      case 'Percent':
        return CompanionInfoRow(
          leadingWidget: _FactRowLeading(fact: fact),
          header: fact.text,
          text: '${fact.percent}%',
        );
      case 'Recharge':
        return CompanionInfoRow(
          leadingWidget: _FactRowLeading(fact: fact),
          header: fact.text,
          text: '${fact.value}s',
        );
      default: return Container();
    }
  }
}

class _FactRowLeading extends StatelessWidget {
  final Fact fact;

  _FactRowLeading({@required this.fact});

  @override
  Widget build(BuildContext context) {
    if (fact.icon == null) {
      return Container();
    }

    return Container(
      width: 18,
      height: 18,
      margin: EdgeInsets.only(right: 6.0),
      child: CompanionCachedImage(
        height: 18,
        width: 18,
        imageUrl: fact.icon,
        iconSize: 12,
        color: Colors.black,
        fit: BoxFit.cover,
      ),
    );
  }
}