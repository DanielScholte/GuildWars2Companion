import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:guildwars2_companion/core/utils/guild_wars.dart';
import 'package:guildwars2_companion/core/widgets/appbar.dart';
import 'package:guildwars2_companion/core/widgets/info_row.dart';
import 'package:guildwars2_companion/core/widgets/simple_button.dart';
import 'package:guildwars2_companion/features/achievement/repositories/achievement.dart';
import 'package:guildwars2_companion/features/build/repositories/build.dart';
import 'package:guildwars2_companion/features/item/repositories/item.dart';

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
  Future<int> _cachedItemsFuture;
  Future<int> _cachedSkinsFuture;
  Future<int> _cachedMinisFuture;
  Future<int> _cachedSkillsFuture;
  Future<int> _cachedTraitsFuture;

  @override
  void initState() {
    super.initState();

    _achievementRepository = RepositoryProvider.of<AchievementRepository>(context);
    _itemRepository = RepositoryProvider.of<ItemRepository>(context);
    _buildRepository = RepositoryProvider.of<BuildRepository>(context);

    _cachedAchievementsFuture = _achievementRepository.getCachedAchievementsCount();
    _cachedItemsFuture = _itemRepository.getCachedItemsCount();
    _cachedSkinsFuture = _itemRepository.getCachedSkinsCount();
    _cachedMinisFuture = _itemRepository.getCachedMinisCount();
    _cachedSkillsFuture = _buildRepository.getCachedSkillsCount();
    _cachedTraitsFuture = _buildRepository.getCachedTraitsCount();
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
          _cachedCountDisplay(
            _cachedAchievementsFuture,
            'achievements'
          ),
          _cachedCountDisplay(
            _cachedItemsFuture,
            'items'
          ),
          _cachedCountDisplay(
            _cachedSkinsFuture,
            'skins'
          ),
          _cachedCountDisplay(
            _cachedMinisFuture,
            'minis'
          ),
          _cachedCountDisplay(
            _cachedSkillsFuture,
            'skills'
          ),
          _cachedCountDisplay(
            _cachedTraitsFuture,
            'traits'
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

  Widget _cachedCountDisplay(Future<int> future, String header) {
    return FutureBuilder<int>(
      future: future,
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return CompanionInfoRow(
            header: 'Cached $header',
            text: 'Error',
          );
        }

        if (snapshot.hasData) {
          return CompanionInfoRow(
            header: 'Cached $header',
            text: GuildWarsUtil.intToString(snapshot.data),
          );
        }

        return CompanionInfoRow(
          header: 'Cached $header',
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