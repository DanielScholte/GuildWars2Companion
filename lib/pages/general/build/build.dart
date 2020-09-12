import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:guildwars2_companion/models/build/build.dart';
import 'package:guildwars2_companion/models/build/skill_trait.dart';
import 'package:guildwars2_companion/models/build/specialization.dart';
import 'package:guildwars2_companion/utils/guild_wars.dart';
import 'package:guildwars2_companion/widgets/accent.dart';
import 'package:guildwars2_companion/widgets/appbar.dart';
import 'package:guildwars2_companion/widgets/cached_image.dart';
import 'package:guildwars2_companion/widgets/card.dart';
import 'package:guildwars2_companion/widgets/list_view.dart';
import 'package:guildwars2_companion/widgets/skill_trait_box.dart';

class BuildPage extends StatelessWidget {
  final Build _build;
  final bool singular;

  BuildPage(this._build, { this.singular = false });

  @override
  Widget build(BuildContext context) {
    return CompanionAccent(
      lightColor: singular ? Colors.purple : GuildWarsUtil.getProfessionColor(_build.profession),
      child: Scaffold(
        appBar: CompanionAppBar(
          title: _build.name != null && _build.name.isNotEmpty ? _build.name : 'Nameless build',
          color: singular ? Colors.purple : GuildWarsUtil.getProfessionColor(_build.profession),
        ),
        body: CompanionListView(
          children: <Widget>[
            _buildSkillCard(context),
            SafeArea(child: _buildSpecializationsCard(context), top: false, right: false, left: false,)
          ],
        ),
      ),
    );
  }

  Widget _buildSkillCard(BuildContext context) {
    return CompanionCard(
      child: Column(
        children: <Widget>[
          Padding(
            padding: EdgeInsets.only(bottom: 8.0),
            child: Text(
              'Skills',
              style: Theme.of(context).textTheme.headline2,
            ),
          ),
          if (_build.skills != null)
            _buildSkillRow(context, _build.skills, 'ground'),
          if (_build.aquaticSkills != null)
            _buildSkillRow(context, _build.aquaticSkills, 'water'),
        ],
      ),
    );
  }

  Widget _buildSkillRow(BuildContext context, BuildSkillset skills, String type) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        Icon(
          type == 'ground' ? FontAwesomeIcons.mountain : FontAwesomeIcons.water,
          color: Theme.of(context).brightness == Brightness.light ? Colors.black : Colors.white,
        ),
        Container(width: 8.0,),
        CompanionSkillTraitBox(
          hero: '${type}_heal',
          skillTrait: skills.healDetails,
        ),
        ...Iterable.generate(skills.utilities.length, (index) => CompanionSkillTraitBox(
          hero: '${type}_util_$index',
          skillTrait: skills.utilities[index] != null ? skills.utilityDetails.firstWhere((u) => u.id == skills.utilities[index], orElse: () => null) : null,
          horizontalMargin: 2.0,
        )).toList(),
        CompanionSkillTraitBox(
          hero: '${type}_elite',
          skillTrait: skills.eliteDetails,
        ),
      ],
    );
  }

  Widget _buildSpecializationsCard(BuildContext context) {
    return CompanionCard(
      child: Column(
        children: <Widget>[
          Padding(
            padding: EdgeInsets.only(bottom: 4.0),
            child: Text(
              'Specializations',
              style: Theme.of(context).textTheme.headline2,
            ),
          ),
          ...Iterable.generate(_build.specializations.length,
            (index) => _buildSpecialization(context, _build.specializations[index], index))
            .toList(),
        ],
      ),
    );
  }

  Widget _buildSpecialization(BuildContext context, BuildSpecialization specialization, int index) {
    Specialization details = specialization.specializationDetails;

    return Container(
      width: double.infinity,
      child: Column(
        children: <Widget>[
          Padding(
            padding: EdgeInsets.all(4.0),
            child: Text(
              details != null ? details.name : 'No specialization chosen',
              style: Theme.of(context).textTheme.bodyText1,
            ),
          ),
          Container(
            width: double.infinity,
            child: Wrap(
              alignment: WrapAlignment.center,
              crossAxisAlignment: WrapCrossAlignment.center,
              children: <Widget>[
                if (details != null)
                  Container(
                    width: 48,
                    height: 48,
                    child: CompanionCachedImage(
                      imageUrl: details.icon,
                      height: 48,
                      width: 48,
                      color: Colors.white,
                      iconSize: 28,
                      fit: BoxFit.cover,
                    ),
                  )
                else
                  Image.asset(
                    'assets/specialization_placeholder.png',
                    width: 48,
                    height: 48,
                  ),
                CompanionSkillTraitBox(
                  hero: 'spec_${index}_minor_0',
                  skillTrait: details != null ? details.minorTraitDetails[0] : null,
                  size: 32.0,
                  horizontalMargin: 4.0,
                  skillTraitType: 'Minor trait',
                ),
                _buildTraitColumn(index, 0, details, specialization.traits[0]),
                CompanionSkillTraitBox(
                  hero: 'spec_${index}_minor_1',
                  skillTrait: details != null ? details.minorTraitDetails[1] : null,
                  size: 32.0,
                  horizontalMargin: 4.0,
                  skillTraitType: 'Minor trait',
                ),
                _buildTraitColumn(index, 3, details, specialization.traits[1]),
                CompanionSkillTraitBox(
                  hero: 'spec_${index}_minor_2',
                  skillTrait: details != null ? details.minorTraitDetails[2] : null,
                  size: 32.0,
                  horizontalMargin: 4.0,
                  skillTraitType: 'Minor trait',
                ),
                _buildTraitColumn(index, 6, details, specialization.traits[2]),
              ],
            ),
          )
        ],
      ),
    );
  }

  Widget _buildTraitColumn(int specIndex, int offset, Specialization details, int chosen) {
    return Column(
      children: Iterable.generate(3, (index) {
        if (details == null) {
          return CompanionSkillTraitBox(
            hero: 'spec_${specIndex}_major_${offset}_$index',
            skillTrait: null,
            size: 38.0,
            horizontalMargin: 4.0,
          );
        }

        SkillTrait major = details.majorTraitDetails[offset + index];

        return CompanionSkillTraitBox(
          hero: 'spec_${specIndex}_major_${offset}_$index',
          skillTrait: major,
          greyedOut: major.id != chosen,
          size: 38.0,
          horizontalMargin: 4.0,
          skillTraitType: 'Major trait',
        );
      }).toList(),
    );
  }
}