import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:guildwars2_companion/core/widgets/info_card.dart';
import 'package:guildwars2_companion/features/build/models/build.dart';
import 'package:guildwars2_companion/features/build/widgets/skill_trait_box.dart';

class BuildSkillCard extends StatelessWidget {
  final Build characterBuild;

  BuildSkillCard({
    @required this.characterBuild
  });

  @override
  Widget build(BuildContext context) {
    return CompanionInfoCard(
      title: 'Skills',
      child: Column(
        children: [
          if (characterBuild.skills != null)
            _SkillRow(
              skills: characterBuild.skills,
              type: _SkillRowType.GROUND,
            ),
          if (characterBuild.aquaticSkills != null)
            _SkillRow(
              skills: characterBuild.aquaticSkills,
              type: _SkillRowType.WATER,
            )
        ],
      ),
    );
  }
}

enum _SkillRowType {
  GROUND,
  WATER
}

class _SkillRow extends StatelessWidget {
  final BuildSkillset skills;
  final _SkillRowType type;

  _SkillRow({
    @required this.skills,
    @required this.type
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        Icon(
          type == _SkillRowType.GROUND ? FontAwesomeIcons.mountain : FontAwesomeIcons.water,
          color: Theme.of(context).brightness == Brightness.light ? Colors.black : Colors.white,
        ),
        Container(width: 8.0,),
        BuildSkillTraitBox(
          hero: '${type}_heal',
          skillTrait: skills.healDetails,
        ),
        ...Iterable.generate(skills.utilities.length, (index) => BuildSkillTraitBox(
          hero: '${type}_util_$index',
          skillTrait: skills.utilities[index] != null ? skills.utilityDetails.firstWhere((u) => u.id == skills.utilities[index], orElse: () => null) : null,
          horizontalMargin: 2.0,
        )).toList(),
        BuildSkillTraitBox(
          hero: '${type}_elite',
          skillTrait: skills.eliteDetails,
        ),
      ],
    );
  }

}