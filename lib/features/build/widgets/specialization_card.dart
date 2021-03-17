import 'package:flutter/material.dart';
import 'package:guildwars2_companion/core/widgets/cached_image.dart';
import 'package:guildwars2_companion/core/widgets/info_card.dart';
import 'package:guildwars2_companion/features/build/models/build.dart';
import 'package:guildwars2_companion/features/build/models/skill_trait.dart';
import 'package:guildwars2_companion/features/build/models/specialization.dart';
import 'package:guildwars2_companion/features/build/widgets/skill_trait_box.dart';

class BuildSpecializationCard extends StatelessWidget {
  final Build characterBuild;

  BuildSpecializationCard({
    @required this.characterBuild
  });

  @override
  Widget build(BuildContext context) {
    return CompanionInfoCard(
      title: 'Skills',
      child: Column(
        children: Iterable.generate(
          characterBuild.specializations.length,
          (index) => _SpecializationRow(
            buildSpecialization: characterBuild.specializations[index],
            index: index
          )
        )
        .toList()
      ),
    );
  }
}

class _SpecializationRow extends StatelessWidget {
  final BuildSpecialization buildSpecialization;
  final int index;

  _SpecializationRow({
    @required this.buildSpecialization,
    @required this.index
  });

  @override
  Widget build(BuildContext context) {
    Specialization specialization = buildSpecialization.specializationDetails;

    return Container(
      width: double.infinity,
      child: Column(
        children: <Widget>[
          Padding(
            padding: EdgeInsets.all(4.0),
            child: Text(
              specialization != null ? specialization.name : 'No specialization chosen',
              style: Theme.of(context).textTheme.bodyText1,
            ),
          ),
          Container(
            width: double.infinity,
            child: Wrap(
              alignment: WrapAlignment.center,
              crossAxisAlignment: WrapCrossAlignment.center,
              children: <Widget>[
                if (specialization != null)
                  Container(
                    width: 48,
                    height: 48,
                    child: CompanionCachedImage(
                      imageUrl: specialization.icon,
                      height: 48,
                      width: 48,
                      color: Colors.white,
                      iconSize: 28,
                      fit: BoxFit.cover,
                    ),
                  )
                else
                  Image.asset(
                    'assets/images/specialization/specialization_placeholder.png',
                    width: 48,
                    height: 48,
                  ),
                BuildSkillTraitBox(
                  hero: 'spec_${index}_minor_0',
                  skillTrait: specialization != null ? specialization.minorTraitDetails[0] : null,
                  size: 32.0,
                  horizontalMargin: 4.0,
                  skillTraitType: 'Minor trait',
                ),
                _TraitColumn(
                  specialization: specialization,
                  specializationIndex: index,
                  traitIndex: 0,
                  activatedTraitId: buildSpecialization.traits[0],
                ),
                BuildSkillTraitBox(
                  hero: 'spec_${index}_minor_1',
                  skillTrait: specialization != null ? specialization.minorTraitDetails[1] : null,
                  size: 32.0,
                  horizontalMargin: 4.0,
                  skillTraitType: 'Minor trait',
                ),
                _TraitColumn(
                  specialization: specialization,
                  specializationIndex: index,
                  traitIndex: 3,
                  activatedTraitId: buildSpecialization.traits[1],
                ),
                BuildSkillTraitBox(
                  hero: 'spec_${index}_minor_2',
                  skillTrait: specialization != null ? specialization.minorTraitDetails[2] : null,
                  size: 32.0,
                  horizontalMargin: 4.0,
                  skillTraitType: 'Minor trait',
                ),
                _TraitColumn(
                  specialization: specialization,
                  specializationIndex: index,
                  traitIndex: 6,
                  activatedTraitId: buildSpecialization.traits[2],
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}

class _TraitColumn extends StatelessWidget {
  final Specialization specialization;
  final int specializationIndex;
  final int traitIndex;
  final int activatedTraitId;

  _TraitColumn({
    @required this.specialization,
    @required this.specializationIndex,
    @required this.traitIndex,
    @required this.activatedTraitId
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: Iterable.generate(3, (index) {
        if (specialization == null) {
          return BuildSkillTraitBox(
            hero: 'spec_${specializationIndex}_major_${traitIndex}_$index',
            skillTrait: null,
            size: 38.0,
            horizontalMargin: 4.0,
          );
        }

        SkillTrait major = specialization.majorTraitDetails[traitIndex + index];

        return BuildSkillTraitBox(
          hero: 'spec_${specializationIndex}_major_${traitIndex}_$index',
          skillTrait: major,
          greyedOut: major.id != activatedTraitId,
          size: 38.0,
          horizontalMargin: 4.0,
          skillTraitType: 'Major trait',
        );
      }).toList(),
    );
  }
}