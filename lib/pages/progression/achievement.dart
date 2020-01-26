import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:guildwars2_companion/blocs/achievement/bloc.dart';
import 'package:guildwars2_companion/models/achievement/achievement.dart';
import 'package:guildwars2_companion/utils/guild_wars.dart';
import 'package:guildwars2_companion/widgets/achievement_button.dart';
import 'package:guildwars2_companion/widgets/card.dart';
import 'package:guildwars2_companion/widgets/coin.dart';
import 'package:guildwars2_companion/widgets/error.dart';
import 'package:guildwars2_companion/widgets/header.dart';
import 'package:guildwars2_companion/widgets/item_box.dart';

class AchievementPage extends StatelessWidget {

  final Achievement achievement;
  final String categoryIcon;

  AchievementPage({
    this.achievement,
    this.categoryIcon,
  });

  @override
  Widget build(BuildContext context) {
    return Theme(
      data: Theme.of(context).copyWith(accentColor: Colors.blueGrey),
      child: Scaffold(
        body: Column(
          children: <Widget>[
            CompanionHeader(
              includeBack: true,
              wikiName: achievement.name,
              color: Colors.blueGrey,
              child: Column(
                children: <Widget>[
                  if (achievement.icon == null && categoryIcon != null && categoryIcon.contains('assets'))
                    Image.asset(categoryIcon, height: 42.0,)
                  else
                    CachedNetworkImage(
                      height: 42.0,
                      imageUrl: achievement.icon != null ? achievement.icon : categoryIcon,
                      placeholder: (context, url) => Center(child: CircularProgressIndicator()),
                      errorWidget: (context, url, error) => Center(child: Icon(
                        FontAwesomeIcons.dizzy,
                        size: 28,
                        color: Colors.white,
                      )),
                      fit: BoxFit.fill,
                    ),
                  if (achievement.progress != null)
                    _buildProgress(),
                  if (achievement.progress != null && achievement.progress.current != null && achievement.progress.max != null)
                    Padding(
                      padding: EdgeInsets.only(top: 4.0),
                      child: Column(
                        children: <Widget>[
                          Text(
                            '${((achievement.progress.current / achievement.progress.max) * 100).round()}%',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 16.0
                            ),
                          ),
                          Theme(
                            data: Theme.of(context).copyWith(accentColor: Colors.white),
                            child: Container(
                              margin: EdgeInsets.all(4.0),
                              width: 128.0,
                              height: 8.0,
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(4.0),
                                child: LinearProgressIndicator(
                                  value: achievement.progress.current / achievement.progress.max,
                                  backgroundColor: Colors.white24
                                ),
                              ),
                            ),
                          )
                        ],
                      ),
                    ),
                  Padding(
                    padding: EdgeInsets.only(top: 4.0),
                    child: Text(
                      achievement.name,
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 22.0,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                  if (achievement.categoryName != null)
                    Padding(
                      padding: EdgeInsets.only(top: 4.0),
                      child: Text(
                        achievement.categoryName,
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 16.0,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                ],
              ),
            ),
            Expanded(
              child: BlocBuilder<AchievementBloc, AchievementState>(
                builder: (context, state) {
                  if (state is ErrorAchievementsState) {
                    return Center(
                      child: CompanionError(
                        title: 'the achievement',
                        onTryAgain: () =>
                          BlocProvider.of<AchievementBloc>(context).add(LoadAchievementsEvent(
                            includeProgress: state.includesProgress
                          )),
                      ),
                    );
                  }

                  if (state is LoadedAchievementsState && state.hasError) {
                    return Center(
                      child: CompanionError(
                        title: 'the achievement',
                        onTryAgain: () =>
                          BlocProvider.of<AchievementBloc>(context).add(LoadAchievementDetailsEvent(
                          achievementGroups: state.achievementGroups,
                          achievements: state.achievements,
                          masteries: state.masteries,
                          dialies: state.dailies,
                          dialiesTomorrow: state.dailiesTomorrow,
                          includeProgress: state.includesProgress,
                          achievementPoints: state.achievementPoints,
                          masteryLevel: state.masteryLevel,
                          achievementId: achievement.id,
                        )),
                      ),
                    );
                  }

                  if (state is LoadedAchievementsState) {
                    Achievement _achievement = state.achievements.firstWhere((a) => a.id == achievement.id);

                    if (_achievement == null) {
                      return Center(
                        child: CompanionError(
                          title: 'the achievement',
                          onTryAgain: () =>
                            BlocProvider.of<AchievementBloc>(context).add(LoadAchievementsEvent(
                              includeProgress: state.includesProgress
                            )),
                        ),
                      );
                    }

                    if (_achievement != null && _achievement.loaded) {
                      return _buildContent(_achievement, state);
                    }
                  }

                  return Center(
                    child: CircularProgressIndicator(),
                  );
                },
              ),
            ),
          ],
        ),
      )
    );
  }

  Widget _buildContent(Achievement _achievement, LoadedAchievementsState state) {
    return ListView(
      padding: EdgeInsets.only(top: 8.0),
      children: <Widget>[
        if (_achievement.description != null && _achievement.description.isNotEmpty)
          _buildDescription('Description', removeAllHtmlTags(_achievement.description)),
        if (_achievement.lockedText != null && _achievement.lockedText.isNotEmpty)
          _buildDescription('Locked description', removeAllHtmlTags(_achievement.lockedText)),
        if (_achievement.requirement != null && _achievement.requirement.isNotEmpty)
          _buildDescription('Requirement', removeAllHtmlTags(_achievement.requirement)),
        if (_achievement.rewards != null && _achievement.rewards.isNotEmpty)
          _buildRewards(_achievement),
        if (_achievement.prerequisitesInfo != null && _achievement.prerequisitesInfo.isNotEmpty)
          _buildPrerequisites(_achievement, state),
        if (_achievement.bits != null && _achievement.bits.isNotEmpty)
          _buildBits(_achievement, state)
      ],
    );
  }

  Widget _buildProgress() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        Text(
          '${achievement.progress.points} / ${achievement.pointCap}',
          style: TextStyle(
            fontSize: 16.0,
            color: Colors.white
          ),
        ),
        Container(width: 4.0,),
        Image.asset(
          'assets/progression/ap.png',
          height: 16.0,
        )
      ],
    );
  }

  Widget _buildPrerequisites(Achievement _achievement, LoadedAchievementsState state) {
    return CompanionCard(
      child: Column(
        children: <Widget>[
          Padding(
            padding: EdgeInsets.only(bottom: 8.0),
            child: Text(
              'Prerequisites',
              style: TextStyle(
                fontSize: 18.0
              ),
            ),
          ),
          Column(
            children: _achievement.prerequisitesInfo
              .map((p) => CompanionAchievementButton(
                state: state,
                achievement: p,
              ))
              .toList(),
          )
        ],
      ),
    );
  }

  Widget _buildRewards(Achievement _achievement) {
    return CompanionCard(
      child: Column(
        children: <Widget>[
          Padding(
            padding: EdgeInsets.only(bottom: 8.0),
            child: Text(
              'Rewards',
              style: TextStyle(
                fontSize: 18.0
              ),
            ),
          ),
          Column(
            children: _achievement.rewards
              .map((r) {
                switch (r.type) {
                  case 'Coins':
                    return Row(
                      children: <Widget>[
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: CompanionCoin(r.count),
                        ),
                      ],
                    );
                    break;
                  case 'Item':
                    return Row(
                      children: <Widget>[
                        CompanionItemBox(
                          item: r.item,
                          quantity: r.count,
                          size: 40.0,
                        ),
                        Padding(
                          padding: EdgeInsets.all(4.0),
                          child: Text(
                            r.item.name,
                            style: TextStyle(
                              fontSize: 16.0
                            ),
                            textAlign: TextAlign.center,
                          ),
                        )
                      ],
                    );
                    break;
                  case 'Mastery':
                    return Row(
                      children: <Widget>[
                        Padding(
                          padding: const EdgeInsets.all(4.0),
                          child: Image.asset(
                            GuildWarsUtil.masteryIcon(r.region),
                            height: 32.0,
                            width: 32.0,
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.all(4.0),
                          child: Text(
                            _masteryToName(r.region) + ' Mastery point',
                            style: TextStyle(
                              fontSize: 16.0
                            ),
                            textAlign: TextAlign.center,
                          ),
                        )
                      ],
                    );
                  case 'Title':
                    return Row(
                      children: <Widget>[
                        Padding(
                          padding: const EdgeInsets.all(4.0),
                          child: Image.asset(
                            'assets/progression/title.png',
                            height: 32.0,
                            width: 32.0,
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.all(4.0),
                          child: Text(
                            r.title.name,
                            style: TextStyle(
                              fontSize: 16.0
                            ),
                            textAlign: TextAlign.center,
                          ),
                        )
                      ],
                    );
                }

                return Container();
              })
              .toList(),
          )
        ],
      ),
    );
  }

  String _masteryToName(String mastery) {
    switch (mastery) {
      case 'Maguuma':
        return 'Heart of Thorns';
      case 'Desert':
        return 'Path of Fire';
      case 'Unknown':
        return 'Icebrood Saga';
      default:
        return mastery;
    }
  }

  Widget _buildBits(Achievement _achievement, LoadedAchievementsState state) {
    if (_achievement.bits.any((b) => b.type == 'Text')) {
      return CompanionCard(
        child: Column(
          children: <Widget>[
            Padding(
              padding: EdgeInsets.only(bottom: 8.0),
              child: Text(
                'Objectives',
                style: TextStyle(
                  fontSize: 18.0
                ),
              ),
            ),
            Column(
              children: _achievement.bits
                .map((i) => Row(
                  children: <Widget>[
                    if (state.includesProgress &&
                      _achievement.progress != null &&
                      ((_achievement.progress.bits != null &&
                      _achievement.progress.bits.contains(_achievement.bits.indexOf(i)))
                      || _achievement.progress.done))
                      Icon(
                        FontAwesomeIcons.check,
                        size: 20.0,
                      )
                    else
                      Container(
                        width: 20.0,
                        child: Icon(
                          FontAwesomeIcons.solidCircle,
                          size: 6.0,
                        ),
                      ),
                  Expanded(
                    child: Padding(
                        padding: EdgeInsets.all(4.0),
                        child: Text(
                          i.text,
                          style: TextStyle(
                            fontSize: 16.0
                          ),
                          textAlign: TextAlign.left,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    )
                  ],
                ))
                .toList(),
              ),
          ],
        ),
      );
    }

    return CompanionCard(
      child: Column(
        children: <Widget>[
          Padding(
            padding: EdgeInsets.only(bottom: 8.0),
            child: Text(
              'Collection',
              style: TextStyle(
                fontSize: 18.0
              ),
            ),
          ),
          Column(
            children: _achievement.bits
              .map((i) {
                switch (i.type) {
                  case 'Item':
                    return _buildItemBit(_achievement, i, state.includesProgress);
                    break;
                  case 'Skin':
                    return _buildSkinMiniBit(_achievement, i, state.includesProgress);
                    break;
                  case 'Minipet':
                    return _buildSkinMiniBit(_achievement, i, state.includesProgress);
                    break;
                }

                return Container();
              })
              .toList(),
          ),
        ],
      ),
    );
  }

  Widget _buildItemBit(Achievement _achievement, AchievementBits bit, bool includeProgress) {
    if (bit.item == null) {
      return Row(
        children: <Widget>[
          Text(
            'Unknown item',
            style: TextStyle(
              fontSize: 16.0
            ),
          ),
        ],
      );
    }

    return Padding(
      padding: const EdgeInsets.all(2.0),
      child: Row(
        children: <Widget>[
          CompanionItemBox(
            item: bit.item,
            size: 40.0,
            markCompleted: includeProgress &&
              _achievement.progress != null &&
              ((_achievement.progress.bits != null &&
              _achievement.progress.bits.contains(_achievement.bits.indexOf(bit))
              || _achievement.progress.done)),
          ),
          Expanded(
            child: Padding(
              padding: EdgeInsets.all(4.0),
              child: Text(
                bit.item.name,
                style: TextStyle(
                  fontSize: 16.0
                ),
                textAlign: TextAlign.left,
                overflow: TextOverflow.ellipsis,
              ),
            ),
          )
        ],
      ),
    );
  }

  Widget _buildSkinMiniBit(Achievement _achievement, AchievementBits bit, bool includeProgress) {
    return Padding(
      padding: const EdgeInsets.all(2.0),
      child: Row(
        children: <Widget>[
          Container(
            width: 40.0,
            height: 40.0,
            child: ClipRRect(
              borderRadius: BorderRadius.circular(6.0),
              child: Stack(
                children: <Widget>[
                  CachedNetworkImage(
                    imageUrl: bit.type == 'Skin' ? bit.skin.icon : bit.mini.icon,
                    placeholder: (context, url) => Center(child: CircularProgressIndicator()),
                    errorWidget: (context, url, error) => Center(child: Icon(
                      FontAwesomeIcons.dizzy,
                      size: 20,
                      color: Colors.black,
                    )),
                    fit: BoxFit.fill,
                  ),
                  if (includeProgress &&
                    _achievement.progress != null &&
                    ((_achievement.progress.bits != null &&
                    _achievement.progress.bits.contains(_achievement.bits.indexOf(bit)))
                    || _achievement.progress.done))
                    Container(
                      width: double.infinity,
                      height: double.infinity,
                      color: Colors.white60,
                      alignment: Alignment.center,
                      child: Icon(
                        FontAwesomeIcons.check,
                        size: 20.0,
                      ),
                    )
                ],
              ),
            ),
          ),
          Expanded(
            child: Padding(
              padding: EdgeInsets.all(4.0),
              child: Text(
                bit.type == 'Skin' ? bit.skin.name : bit.mini.name,
                style: TextStyle(
                  fontSize: 16.0
                ),
                textAlign: TextAlign.left,
                overflow: TextOverflow.ellipsis,
              ),
            ),
          )
        ],
      ),
    );
  }

  Widget _buildDescription(String title, String text) {
    return CompanionCard(
      child: Column(
        children: <Widget>[
          Padding(
            padding: EdgeInsets.only(bottom: 8.0),
            child: Text(
              title,
              style: TextStyle(
                fontSize: 18.0
              ),
            ),
          ),
          Text(
            text,
            style: TextStyle(
              fontSize: 16.0
            ),
          ),
        ],
      ),
    );
  }

  String removeAllHtmlTags(String htmlText) {
    RegExp exp = RegExp(
      r"<[^>]*>",
      multiLine: true,
      caseSensitive: true
    );

    return htmlText.replaceAll(exp, '');
  }
}