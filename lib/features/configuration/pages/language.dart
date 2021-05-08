import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:guildwars2_companion/core/widgets/accent.dart';
import 'package:guildwars2_companion/features/configuration/bloc/configuration_bloc.dart';
import 'package:guildwars2_companion/features/achievement/repositories/achievement.dart';
import 'package:guildwars2_companion/features/build/repositories/build.dart';
import 'package:guildwars2_companion/features/item/repositories/item.dart';
import 'package:guildwars2_companion/core/widgets/appbar.dart';

class LanguageConfigurationPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return CompanionAccent(
      lightColor: Colors.blue,
      child: Scaffold(
        appBar: CompanionAppBar(
          title: 'Api and Wiki Language',
          color: Colors.blue,
        ),
        body: BlocBuilder<ConfigurationBloc, ConfigurationState>(
          builder: (context, state) {
            List<_Language> languages = [
              _Language('English', 'en'),
              _Language('Spanish', 'es'),
              _Language('German', 'de'),
              _Language('French', 'fr'),
              _Language('Chinese', 'zh'),
            ];

            return ListView(
              children: languages
                .map((language) =>RadioListTile(
                  groupValue: state.configuration.language,
                  value: language.value,
                  title: Text(
                    language.name,
                    style: Theme.of(context).textTheme.bodyText1,
                  ),
                  onChanged: (lang) => _changeLanguageDialog(
                    context: context,
                    achievementRepository: RepositoryProvider.of<AchievementRepository>(context),
                    itemRepository: RepositoryProvider.of<ItemRepository>(context),
                    buildRepository: RepositoryProvider.of<BuildRepository>(context),
                    lang: lang
                  ),
                ))
                .toList(),
            );
          },
        ),
      ),
    );
  }

  _changeLanguageDialog({
    @required BuildContext context,
    @required AchievementRepository achievementRepository,
    @required ItemRepository itemRepository,
    @required BuildRepository buildRepository,
    @required String lang,
  }) async {
    return showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Change language'),
          content: Text(
'''Are you sure that you want to change the language?
This will also clear your cache and require you to restart the app.'''
          ),
          actions: <Widget>[
            TextButton(
              child: Text(
                'Cancel',
                style: TextStyle(
                  fontSize: 18.0
                ),
              ),
              onPressed: () => Navigator.of(context).pop(),
            ),
            TextButton(
              child: Text(
                'Change language',
                style: TextStyle(
                  fontSize: 18.0
                ),
              ),
              onPressed: () async {
                BlocProvider.of<ConfigurationBloc>(context).add(ChangeLanguageEvent(language: lang));

                Navigator.of(context).pop();

                await achievementRepository.clearCache();
                await itemRepository.clearCache();
                await buildRepository.clearCache();
              },
            )
          ],
        );
      },
    );
  }
}

class _Language {
  final String name;
  final String value;

  _Language(this.name, this.value);
}