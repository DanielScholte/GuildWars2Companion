import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:guildwars2_companion/repositories/achievement.dart';
import 'package:guildwars2_companion/repositories/build.dart';
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

  AchievementRepository _achievementRepository;
  ItemRepository _itemRepository;
  BuildRepository _buildRepository;

  Future<int> _cachedAchievementsFuture;

  @override
  void initState() {
    super.initState();

    _achievementRepository = RepositoryProvider.of<AchievementRepository>(context);
    _itemRepository = RepositoryProvider.of<ItemRepository>(context);
    _buildRepository = RepositoryProvider.of<BuildRepository>(context);

    _cachedAchievementsFuture = _achievementRepository.getCachedAchievementsCount();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CompanionAppBar(
        title: 'Caching',
        color: Colors.blue,
      ),
      body: ListView(
        padding: EdgeInsets.all(8.0),
        children: <Widget>[
          _cachedAchievements(context, _achievementRepository),
          CompanionInfoRow(
            header: 'Cached items',
            text: GuildWarsUtil.intToString(_itemRepository.getCachedItemsCount()),
          ),
          CompanionInfoRow(
            header: 'Cached skins',
            text: GuildWarsUtil.intToString(_itemRepository.getCachedSkinsCount()),
          ),
          CompanionInfoRow(
            header: 'Cached minis',
            text: GuildWarsUtil.intToString(_itemRepository.getCachedMinisCount()),
          ),
          CompanionInfoRow(
            header: 'Cached skills',
            text: GuildWarsUtil.intToString(_buildRepository.getCachedSkillsCount()),
          ),
          CompanionInfoRow(
            header: 'Cached traits',
            text: GuildWarsUtil.intToString(_buildRepository.getCachedTraitsCount()),
          ),
          CompanionSimpleButton(
            text: allowClearCache ? 'Clear cache' : 'Clearing cache...',
            onPressed: allowClearCache ? () => _clearCacheDialog(
              context: context,
              achievementRepository: _achievementRepository,
              itemRepository: _itemRepository,
              buildRepository: _buildRepository
            ) : null,
          ),
          Text(
            '''
Caching allows GW2 Companion to load quicker while saving bandwidth and reducing the possibility for connection failures.
Only mostly static data such as Achievements and Items are cached. Progression isn't cached.
Experiencing issues with cached data, such as outdated information? Try clearing the cache.
            ''',
            style: Theme.of(context).textTheme.bodyText1,
            textAlign: TextAlign.left,
          )
        ],
      )
    );
  }

  Widget _cachedAchievements(BuildContext context, AchievementRepository achievementRepository) {
    return FutureBuilder<int>(
      future: _cachedAchievementsFuture,
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return CompanionInfoRow(
            header: 'Cached achievements',
            text: 'Error',
          );
        }

        if (snapshot.hasData) {
          return CompanionInfoRow(
            header: 'Cached achievements',
            text: GuildWarsUtil.intToString(snapshot.data),
          );
        }

        return CompanionInfoRow(
          header: 'Cached achievements',
          text: 'Loading...',
        );
      },
    );
  }

  _clearCacheDialog({
    BuildContext context,
    AchievementRepository achievementRepository,
    ItemRepository itemRepository,
    BuildRepository buildRepository
  }) async {
    return showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Clear cache'),
          content: Text(
            'Are you sure that you want to clear the cache?'
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
                'Clear cache',
                style: TextStyle(
                  fontSize: 18.0
                ),
              ),
              onPressed: () async {
                Navigator.of(context).pop();

                setState(() {
                  allowClearCache = false;
                });

                await achievementRepository.clearCache();
                await itemRepository.clearCache();
                await buildRepository.clearCache();

                setState(() {
                  allowClearCache = true;
                  _cachedAchievementsFuture = _achievementRepository.getCachedAchievementsCount();
                });
              },
            )
          ],
        );
      },
    );
  }
}