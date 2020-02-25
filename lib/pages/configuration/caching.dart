import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:guildwars2_companion/repositories/achievement.dart';
import 'package:guildwars2_companion/repositories/item.dart';
import 'package:guildwars2_companion/utils/guild_wars.dart';
import 'package:guildwars2_companion/widgets/appbar.dart';
import 'package:guildwars2_companion/widgets/info_row.dart';
import 'package:guildwars2_companion/widgets/simple_button.dart';

class CachingConfigurationPage extends StatefulWidget {
  @override
  _CachingConfigurationPageState createState() => _CachingConfigurationPageState();
}

class _CachingConfigurationPageState extends State<CachingConfigurationPage> {
  bool allowClearCache = true;

  @override
  Widget build(BuildContext context) {
    AchievementRepository achievementRepository = RepositoryProvider.of<AchievementRepository>(context);
    ItemRepository itemRepository = RepositoryProvider.of<ItemRepository>(context);

    return Scaffold(
      appBar: CompanionAppBar(
        title: 'Caching',
        color: Colors.blue,
        elevation: 4.0,
        foregroundColor: Colors.white,
      ),
      body: ListView(
        padding: EdgeInsets.all(8.0),
        children: <Widget>[
          CompanionInfoRow(
            header: 'Cached achievements',
            text: GuildWarsUtil.intToString(achievementRepository.getCachedAchievementsCount()),
          ),
          CompanionInfoRow(
            header: 'Cached items',
            text: GuildWarsUtil.intToString(itemRepository.getCachedItemsCount()),
          ),
          CompanionInfoRow(
            header: 'Cached skins',
            text: GuildWarsUtil.intToString(itemRepository.getCachedSkinsCount()),
          ),
          CompanionInfoRow(
            header: 'Cached minis',
            text: GuildWarsUtil.intToString(itemRepository.getCachedMinisCount()),
          ),
          CompanionSimpleButton(
            text: allowClearCache ? 'Clear cache' : 'Clearing cache...',
            onPressed: allowClearCache ? () => _clearCacheDialog(
              context: context,
              achievementRepository: achievementRepository,
              itemRepository: itemRepository
            ) : null,
          ),
          Text(
            '''
            Caching allows GW2 Companion to load quicker while saving bandwidth and reducing the possibility for connection failures.
            Only mostly static data such as Achievements and Items are cached. Progression isn't cached.
            Experiencing issues with cached data, such as outdated information? Try clearing the cache.
            ''',
            style: Theme.of(context).textTheme.display3,
          )
        ],
      )
    );
  }

  _clearCacheDialog({
    BuildContext context,
    AchievementRepository achievementRepository,
    ItemRepository itemRepository
  }) async {
    return showDialog(
      context: context,
      barrierDismissible: false, // user must tap button for close dialog!
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Clear cache'),
          content: Text(
            'Are you sure that you want to clear the cache?'
          ),
          actions: <Widget>[
            FlatButton(
              child: const Text('Cancel'),
              onPressed: () => Navigator.of(context).pop(),
            ),
            FlatButton(
              child: const Text('Clear cache'),
              onPressed: () async {
                Navigator.of(context).pop();

                setState(() {
                  allowClearCache = false;
                });

                await achievementRepository.clearCache();
                await itemRepository.clearCache();

                setState(() {
                  allowClearCache = true;
                });
              },
            )
          ],
        );
      },
    );
  }
}