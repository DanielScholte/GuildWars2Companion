import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:guildwars2_companion/providers/configuration.dart';
import 'package:guildwars2_companion/repositories/achievement.dart';
import 'package:guildwars2_companion/repositories/item.dart';
import 'package:guildwars2_companion/widgets/appbar.dart';
import 'package:provider/provider.dart';

class LanguageConfigurationPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CompanionAppBar(
        title: 'Api and Wiki Language',
        color: Colors.blue,
        elevation: 4.0,
        foregroundColor: Colors.white,
      ),
      body: Consumer<ConfigurationProvider>(
        builder: (context, state, child) {
          return ListView(
            children: [
              _buildThemeOption(context, state.language, 'en', 'English'),
              _buildThemeOption(context, state.language, 'es', 'Spanish'),
              _buildThemeOption(context, state.language, 'de', 'German'),
              _buildThemeOption(context, state.language, 'fr', 'French'),
              _buildThemeOption(context, state.language, 'zh', 'Chinese'),
            ]
          );
        }
      ),
    );
  }

  Widget _buildThemeOption(BuildContext context, String currentLanguage, String language, String title) {
    return RadioListTile(
      groupValue: currentLanguage,
      value: language,
      title: Text(
        title,
        style: Theme.of(context).textTheme.display3,
      ),
      onChanged: (String lang) =>  _clearCacheDialog(
        context: context,
        achievementRepository: RepositoryProvider.of<AchievementRepository>(context),
        itemRepository: RepositoryProvider.of<ItemRepository>(context),
        configurationProvider: Provider.of<ConfigurationProvider>(context, listen: false),
        lang: lang
      ),
    );
  }

  _clearCacheDialog({
    BuildContext context,
    AchievementRepository achievementRepository,
    ItemRepository itemRepository,
    ConfigurationProvider configurationProvider,
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
              child: const Text('Cancel'),
              onPressed: () => Navigator.of(context).pop(),
            ),
            FlatButton(
              child: const Text('Change language'),
              onPressed: () async {
                await configurationProvider.changeLanguage(lang);

                Navigator.of(context).pop();

                await achievementRepository.clearCache();
                await itemRepository.clearCache();
              },
            )
          ],
        );
      },
    );
  }
}