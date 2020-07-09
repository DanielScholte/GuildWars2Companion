import 'package:flutter/widgets.dart';
import 'package:guildwars2_companion/models/build/build.dart';
import 'package:guildwars2_companion/models/build/skill_trait.dart';
import 'package:guildwars2_companion/models/build/specialization.dart';
import 'package:guildwars2_companion/services/build.dart';

class BuildRepository {
  final BuildService buildService;

  BuildRepository({
    @required this.buildService
  });

  Future<List<Build>> getBuildStorage() async {
    List networkResults = await Future.wait([
      buildService.getSpecializations(),
      buildService.getBuildStorage(),
    ]);

    List<Specialization> specializations = networkResults[0];
    List<Build> builds = networkResults[1];

    await fillBuildInformation(builds, fetchedSpecializations: specializations);

    return builds;
  }

  Future<void> fillBuildInformation(List<Build> builds, { List<Specialization> fetchedSpecializations }) async {
    List<Specialization> specializations = fetchedSpecializations != null ? fetchedSpecializations : await buildService.getSpecializations();

    List<int> traitIds = [];
    List<int> skillIds = [];

    builds.forEach((build) {
      if (build.specializations != null) {
        build.specializations.forEach((specialization) {
          specialization.specializationDetails = specializations.firstWhere((s) => s.id == specialization.id, orElse: () => null);

          if (specialization.specializationDetails != null) {
            traitIds.addAll(specialization.specializationDetails.minorTraits);
            traitIds.addAll(specialization.specializationDetails.majorTraits);
          }
        });
      }

      [
        build.skills,
        build.aquaticSkills
      ] .where((skills) => skills != null)
        .forEach((skills) {
          if (skills.heal != null) {
            skillIds.add(skills.heal);
          }

          if (skills.elite != null) {
            skillIds.add(skills.elite);
          }

          if (skills.utilities != null) {
            skillIds.addAll(skills.utilities.where((u) => u != null).toList());
          }
        });
    });

    traitIds = traitIds.toSet().toList();
    skillIds = skillIds.toSet().toList();

    List skillTraitNetworkResults = await Future.wait([
      buildService.getTraits(traitIds),
      buildService.getSkills(skillIds),
    ]);

    List<SkillTrait> traits = skillTraitNetworkResults[0];
    List<SkillTrait> skills = skillTraitNetworkResults[1];

    specializations.forEach((specialization) {
      specialization.minorTraitDetails = specialization.minorTraits
        .where((id) => id != null)
        .map((id) => traits.firstWhere((t) => t.id == id, orElse: () => null))
        .where((t) => t != null)
        .toList();
      
      specialization.majorTraitDetails = specialization.majorTraits
        .where((id) => id != null)
        .map((id) => traits.firstWhere((t) => t.id == id, orElse: () => null))
        .where((t) => t != null)
        .toList();
    });

    builds.forEach((build) {
      [
        build.skills,
        build.aquaticSkills
      ] .where((skills) => skills != null)
        .forEach((selectedSkills) {
          if (selectedSkills.heal != null) {
            selectedSkills.healDetails = skills.firstWhere((s) => s.id == selectedSkills.heal, orElse: () => null);
          }

          if (selectedSkills.elite != null) {
            selectedSkills.eliteDetails = skills.firstWhere((s) => s.id == selectedSkills.elite, orElse: () => null);
          }

          if (selectedSkills.utilities != null) {
            selectedSkills.utilityDetails = selectedSkills.utilities
              .where((id) => id != null)
              .map((id) => skills.firstWhere((s) => s.id == id, orElse: () => null))
              .where((s) => s != null)
              .toList();
          }
        });
    });
  }
}