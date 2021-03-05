import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:guildwars2_companion/core/utils/guild_wars.dart';
import 'package:guildwars2_companion/core/widgets/accent.dart';
import 'package:guildwars2_companion/core/widgets/appbar.dart';
import 'package:guildwars2_companion/core/widgets/cached_image.dart';
import 'package:guildwars2_companion/core/widgets/card.dart';
import 'package:guildwars2_companion/core/widgets/list_view.dart';
import 'package:guildwars2_companion/features/build/models/build.dart';
import 'package:guildwars2_companion/features/build/models/skill_trait.dart';
import 'package:guildwars2_companion/features/build/models/specialization.dart';
import 'package:guildwars2_companion/features/build/widgets/skill_card.dart';
import 'package:guildwars2_companion/features/build/widgets/skill_trait_box.dart';
import 'package:guildwars2_companion/features/build/widgets/specialization_card.dart';

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
            BuildSkillCard(characterBuild: _build),
            BuildSpecializationCard(characterBuild: _build)
          ],
        ),
      ),
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
                BuildSkillTraitBox(
                  hero: 'spec_${index}_minor_0',
                  skillTrait: details != null ? details.minorTraitDetails[0] : null,
                  size: 32.0,
                  horizontalMargin: 4.0,
                  skillTraitType: 'Minor trait',
                ),
                _buildTraitColumn(index, 0, details, specialization.traits[0]),
                BuildSkillTraitBox(
                  hero: 'spec_${index}_minor_1',
                  skillTrait: details != null ? details.minorTraitDetails[1] : null,
                  size: 32.0,
                  horizontalMargin: 4.0,
                  skillTraitType: 'Minor trait',
                ),
                _buildTraitColumn(index, 3, details, specialization.traits[1]),
                BuildSkillTraitBox(
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
    
  }
}