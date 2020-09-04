import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:guildwars2_companion/blocs/configuration/configuration_bloc.dart';
import 'package:guildwars2_companion/models/other/configuration.dart';
import 'package:guildwars2_companion/repositories/achievement.dart';
import 'package:guildwars2_companion/repositories/build.dart';
import 'package:guildwars2_companion/repositories/item.dart';
import 'package:guildwars2_companion/widgets/appbar.dart';

class LanguageConfigurationPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CompanionAppBar(
        title: 'Api and Wiki Language',
        color: Colors.blue,
      ),
      body: BlocBuilder<ConfigurationBloc, ConfigurationState>(
        builder: (context, state) {
          final Configuration configuration = (state as LoadedConfiguration).configuration;
          
          return ListView(
            children: <Widget>[
              _buildLanguageOption(context, configuration.language, 'en', 'English'),
              _buildLanguageOption(context, configuration.language, 'es', 'Spanish'),
              _buildLanguageOption(context, configuration.language, 'de', 'German'),
              _buildLanguageOption(context, configuration.language, 'fr', 'French'),
              _buildLanguageOption(context, configuration.language, 'zh', 'Chinese'),
            ],
          );
        },
      ),
    );
  }

  Widget _buildLanguageOption(BuildContext context, String currentLanguage, String language, String title) {
    return RadioListTile(
      groupValue: currentLanguage,
      value: language,
      title: Text(
        title,
        style: Theme.of(context).textTheme.bodyText1,
      ),
      onChanged: (String lang) =>  _clearCacheDialog(
        context: context,
        achievementRepository: RepositoryProvider.of<AchievementRepository>(context),
        itemRepository: RepositoryProvider.of<ItemRepository>(context),
        buildRepository: RepositoryProvider.of<BuildRepository>(context),
        lang: lang
      ),
    );
  }

  _clearCacheDialog({
    BuildContext context,
    AchievementRepository achievementRepository,
    ItemRepository itemRepository,
    BuildRepository buildRepository,
    String lang,
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
            FlatButton(
              child: Text(
                'Cancel',
                style: TextStyle(
                  fontSize: 18.0
                ),
              ),
              onPressed: () => Navigator.of(context).pop(),
            ),
            FlatButton(
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