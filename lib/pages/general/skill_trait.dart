import 'package:flutter/material.dart';
import 'package:guildwars2_companion/models/build/skill_trait.dart';
import 'package:guildwars2_companion/utils/guild_wars.dart';
import 'package:guildwars2_companion/widgets/cached_image.dart';
import 'package:guildwars2_companion/widgets/card.dart';
import 'package:guildwars2_companion/widgets/header.dart';
import 'package:guildwars2_companion/widgets/info_column.dart';
import 'package:guildwars2_companion/widgets/info_row.dart';
import 'package:guildwars2_companion/widgets/list_view.dart';
import 'package:guildwars2_companion/widgets/skill_trait_box.dart';

class SkillTraitPage extends StatelessWidget {
  final SkillTrait skillTrait;
  final String hero;
  final String slotType;

  SkillTraitPage({
    @required this.skillTrait,
    @required this.hero,
    this.slotType,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: <Widget>[
          _buildHeader(context),
          Expanded(
            child: CompanionListView(
              children: <Widget>[
                if (skillTrait.description != null)
                  _buildDescription(context),
                _buildDetails(context),
                _buildEffects(context)
              ],
            ),
          )
        ],
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    return CompanionHeader(
      includeBack: true,
      wikiName: skillTrait.name,
      child: Column(
        children: <Widget>[
          Padding(
            padding: EdgeInsets.only(top: 4.0),
            child: CompanionSkillTraitBox(
              skillTrait: skillTrait,
              hero: hero,
              enablePopup: false,
              size: 55.0,
            ),
          ),
          Padding(
            padding: EdgeInsets.all(4.0),
            child: Text(
              skillTrait.name,
              style: Theme.of(context).textTheme.headline1,
              textAlign: TextAlign.center,
            ),
          ),
          if (skillTrait.type != null || slotType != null)
            Text(
              skillTrait.type ?? slotType,
              style: Theme.of(context).textTheme.bodyText1.copyWith(
                color: Colors.white
              ),
              textAlign: TextAlign.center,
            ),
        ],
      ),
    );
  }

  Widget _buildDescription(BuildContext context) {
    return CompanionCard(
      child: Column(
        children: <Widget>[
          Padding(
            padding: EdgeInsets.only(bottom: 8.0),
            child: Text(
              'Description',
              style: Theme.of(context).textTheme.headline2,
            ),
          ),
          Text(
            GuildWarsUtil.removeOnlyHtml(skillTrait.description),
            style: Theme.of(context).textTheme.bodyText1,
          ),
        ],
      ),
    );
  }

  Widget _buildDetails(BuildContext context) {
    List<Fact> nonBuffFacts = _getNonBuffFacts();

    if (nonBuffFacts.isEmpty) {
      return Container();
    }

    return CompanionCard(
      child: Column(
        children: <Widget>[
          Padding(
            padding: EdgeInsets.only(bottom: 8.0),
            child: Text(
              'Stats',
              style: Theme.of(context).textTheme.headline2,
            ),
          ),
          ...nonBuffFacts
            .map((f) => _getFactWidget(f))  
            .toList()
        ],
      ),
    );
  }

  Widget _buildEffects(BuildContext context) {
    List<Fact> buffFacts = _getBuffFacts();

    if (buffFacts.isEmpty) {
      return Container();
    }

    return CompanionCard(
      child: Column(
        children: <Widget>[
          Padding(
            padding: EdgeInsets.only(bottom: 8.0),
            child: Text(
              'Effects',
              style: Theme.of(context).textTheme.headline2,
            ),
          ),
          ...buffFacts
            .map((f) => _getFactWidget(f))  
            .toList()
        ],
      ),
    );
  }

  Widget _getFactWidget(Fact fact) {
    switch (fact.type) {
      case 'AttributeAdjust':
        return CompanionInfoRow(
          leadingWidget: _getLeadingIcon(fact),
          header: fact.target,
          text: '+${fact.value}',
        );
      case 'BuffConversion':
        return CompanionInfoRow(
          leadingWidget: _getLeadingIcon(fact),
          header: fact.target,
          text: '+${fact.percent}%',
        );
      case 'Buff':
      case 'PrefixedBuff':
        return CompanionInfoColumn(
          leadingWidget: _getLeadingIcon(fact),
          header: '${fact.status ?? ''}'
            + (fact.applyCount != null && fact.applyCount > 1 ? ' x${fact.applyCount}' : '')
            + (fact.duration != null && fact.duration > 0 ? ' (${fact.duration}s)' : ''),
          text: GuildWarsUtil.removeOnlyHtml(fact.description),
        );
      case 'ComboField':
        return CompanionInfoRow(
          leadingWidget: _getLeadingIcon(fact),
          header: fact.text,
          text: fact.fieldType,
        );
      case 'ComboFinisher':
        return CompanionInfoRow(
          leadingWidget: _getLeadingIcon(fact),
          header: fact.text,
          text: fact.finisherType,
        );
      case 'Distance':
        return CompanionInfoRow(
          leadingWidget: _getLeadingIcon(fact),
          header: fact.text,
          text: fact.distance.toString(),
        );
      case 'Duration':
      case 'Time':
        return CompanionInfoRow(
          leadingWidget: _getLeadingIcon(fact),
          header: fact.text,
          text: '${fact.duration}s',
        );
      case 'NoData':
        return CompanionInfoRow(
          leadingWidget: _getLeadingIcon(fact),
          header: fact.text,
          text: '',
        );
      case 'Range':
      case 'Number':
        return CompanionInfoRow(
          leadingWidget: _getLeadingIcon(fact),
          header: fact.text,
          text: fact.value.toString(),
        );
      case 'Percent':
        return CompanionInfoRow(
          leadingWidget: _getLeadingIcon(fact),
          header: fact.text,
          text: '${fact.percent}%',
        );
      case 'Recharge':
        return CompanionInfoRow(
          leadingWidget: _getLeadingIcon(fact),
          header: fact.text,
          text: '${fact.value}s',
        );
      default: return Container();
    }
  }

  Widget _getLeadingIcon(Fact fact) {
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

  List<Fact> _getBuffFacts() {
    return skillTrait.facts != null ? skillTrait.facts.where((f) => f.type == 'Buff' || f.type == 'PrefixedBuff').toList() : [];
  }

  List<Fact> _getNonBuffFacts() {
    return skillTrait.facts != null ? skillTrait.facts.where((f) => f.type != 'Buff' && f.type != 'PrefixedBuff').toList() : [];
  }
}