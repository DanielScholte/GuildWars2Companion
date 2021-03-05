import 'package:flutter/material.dart';
import 'package:guildwars2_companion/core/utils/guild_wars.dart';
import 'package:guildwars2_companion/core/widgets/header.dart';
import 'package:guildwars2_companion/core/widgets/info_card.dart';
import 'package:guildwars2_companion/core/widgets/list_view.dart';
import 'package:guildwars2_companion/features/build/models/skill_trait.dart';
import 'package:guildwars2_companion/features/build/widgets/skill_trait_box.dart';
import 'package:guildwars2_companion/features/build/widgets/skill_trait_facts_card.dart';

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
          _SkillTraitHeader(
            skillTrait: skillTrait,
            hero: hero,
            slotType: slotType,
          ),
          Expanded(
            child: CompanionListView(
              children: <Widget>[
                if (skillTrait.description != null)
                  CompanionInfoCard(title: 'Description', text: GuildWarsUtil.removeOnlyHtml(skillTrait.description)),
                BuildSkillTraitFactsCard(
                  facts: _getNonBuffFacts(),
                  type: FactsType.STATS
                ),
                BuildSkillTraitFactsCard(
                  facts: _getBuffFacts(),
                  type: FactsType.EFFECTS
                ),
              ],
            ),
          )
        ],
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

class _SkillTraitHeader extends StatelessWidget {
  final SkillTrait skillTrait;
  final String hero;
  final String slotType;

  _SkillTraitHeader({
    @required this.skillTrait,
    @required this.hero,
    @required this.slotType,
  });

  @override
  Widget build(BuildContext context) {
    return CompanionHeader(
      includeBack: true,
      wikiName: skillTrait.name,
      child: Column(
        children: <Widget>[
          Padding(
            padding: EdgeInsets.only(top: 4.0),
            child: BuildSkillTraitBox(
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
}