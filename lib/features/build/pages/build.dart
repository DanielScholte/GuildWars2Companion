import 'package:flutter/material.dart';
import 'package:guildwars2_companion/core/utils/guild_wars.dart';
import 'package:guildwars2_companion/core/widgets/accent.dart';
import 'package:guildwars2_companion/core/widgets/appbar.dart';
import 'package:guildwars2_companion/core/widgets/list_view.dart';
import 'package:guildwars2_companion/features/build/models/build.dart';
import 'package:guildwars2_companion/features/build/widgets/skill_card.dart';
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
}