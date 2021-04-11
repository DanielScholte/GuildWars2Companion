import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:guildwars2_companion/core/utils/assets.dart';
import 'package:guildwars2_companion/core/utils/guild_wars.dart';
import 'package:guildwars2_companion/core/widgets/accent.dart';
import 'package:guildwars2_companion/core/widgets/cached_image.dart';
import 'package:guildwars2_companion/features/error/widgets/error.dart';
import 'package:guildwars2_companion/core/widgets/header.dart';
import 'package:guildwars2_companion/core/widgets/info_card.dart';
import 'package:guildwars2_companion/core/widgets/list_view.dart';
import 'package:guildwars2_companion/features/achievement/bloc/achievement_bloc.dart';
import 'package:guildwars2_companion/features/achievement/models/achievement.dart';
import 'package:guildwars2_companion/features/achievement/widgets/bits_card.dart';
import 'package:guildwars2_companion/features/achievement/widgets/prerequisites_card.dart';
import 'package:guildwars2_companion/features/achievement/widgets/rewards_card.dart';

class AchievementPage extends StatelessWidget {
  final Achievement achievement;
  final String categoryIcon;
  final String hero;

  AchievementPage({
    this.achievement,
    this.categoryIcon,
    this.hero,
  });

  @override
  Widget build(BuildContext context) {
    return CompanionAccent(
      lightColor: Colors.blueGrey,
      child: Scaffold(
        body: BlocBuilder<AchievementBloc, AchievementState>(
          builder: (context, state) {
            if (state is ErrorAchievementsState) {
              return _AchievementPageLayout(
                achievement: achievement,
                categoryIcon: categoryIcon,
                hero: hero,
                child: Center(
                  child: CompanionError(
                    title: 'the achievement',
                    onTryAgain: () =>
                      BlocProvider.of<AchievementBloc>(context).add(LoadAchievementsEvent(
                        includeProgress: state.includesProgress
                      )),
                  ),
                )
              );
            }

            if (state is LoadedAchievementsState && state.hasError) {
              return _AchievementPageLayout(
                achievement: achievement,
                categoryIcon: categoryIcon,
                hero: hero,
                child: Center(
                  child: CompanionError(
                    title: 'the achievement',
                    onTryAgain: () =>
                      BlocProvider.of<AchievementBloc>(context).add(LoadAchievementDetailsEvent(
                      achievementId: achievement.id,
                    )),
                  ),
                ),
              );
            }

            if (state is LoadedAchievementsState) {
              Achievement _achievement = state.achievements.firstWhere((a) => a.id == achievement.id);

              if (_achievement == null) {
                return _AchievementPageLayout(
                  achievement: achievement,
                  categoryIcon: categoryIcon,
                  hero: hero,
                  child: Center(
                    child: CompanionError(
                      title: 'the achievement',
                      onTryAgain: () =>
                        BlocProvider.of<AchievementBloc>(context).add(LoadAchievementsEvent(
                          includeProgress: state.includesProgress
                        )),
                    ),
                  ),
                );
              }

              if (_achievement != null && _achievement.loaded) {
                if (state.includesProgress) {
                  return _AchievementPageLayout(
                    achievement: _achievement,
                    categoryIcon: categoryIcon,
                    hero: hero,
                    displayFavorite: true,
                    child: RefreshIndicator(
                      backgroundColor: Theme.of(context).accentColor,
                      color: Theme.of(context).cardColor,
                      onRefresh: () async {
                        BlocProvider.of<AchievementBloc>(context).add(RefreshAchievementProgressEvent(
                          achievementId: achievement.id,
                        ));
                        await Future.delayed(Duration(milliseconds: 200), () {});
                      },
                      child: _AchievementPageContent(
                        achievement: _achievement,
                        includeProgression: state.includesProgress,
                      ),
                    ),
                  );
                }

                return _AchievementPageLayout(
                  achievement: _achievement,
                  categoryIcon: categoryIcon,
                  hero: hero,
                  displayFavorite: true,
                  child: _AchievementPageContent(
                    achievement: _achievement,
                    includeProgression: state.includesProgress,
                  ),
                );
              }
            }

            return _AchievementPageLayout(
              achievement: achievement,
              categoryIcon: categoryIcon,
              hero: hero,
              child: Center(
                child: CircularProgressIndicator(),
              ),
            );
          },
        ),
      ),
    );
  }
}

class _AchievementPageLayout extends StatelessWidget {
  final Achievement achievement;
  final String categoryIcon;
  final String hero;
  final Widget child;
  final bool displayFavorite;

  _AchievementPageLayout({
    @required this.achievement,
    @required this.categoryIcon,
    @required this.hero,
    @required this.child,
    this.displayFavorite = false
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        CompanionHeader(
          isFavorite: displayFavorite ? achievement.favorite : null,
          onFavoriteToggle: () {
            BlocProvider.of<AchievementBloc>(context).add(ChangeFavoriteAchievementEvent(
              addAchievementId: !achievement.favorite ? achievement.id : null,
              removeAchievementId: achievement.favorite ? achievement.id : null,
            ));
          },
          includeBack: true,
          wikiName: achievement.name,
          color: Colors.blueGrey,
          child: Column(
            children: <Widget>[
              if (achievement.icon == null && categoryIcon != null && categoryIcon.contains('assets'))
                Hero(
                  tag: hero,
                  child: Image.asset(categoryIcon, height: 42.0,)
                )
              else
                Hero(
                  tag: hero,
                  child: CompanionCachedImage(
                    height: 42.0,
                    imageUrl: achievement.icon != null ? achievement.icon : categoryIcon,
                    color: Colors.white,
                    iconSize: 28,
                    fit: BoxFit.fill,
                  ),
                ),
              if (achievement.progress != null)
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Text(
                      '${achievement.progress.points} / ${achievement.maxPoints}',
                      style: Theme.of(context).textTheme.bodyText1.copyWith(
                        color: Colors.white
                      ),
                    ),
                    Container(width: 4.0,),
                    Image.asset(
                      Assets.progressionAp,
                      height: 16.0,
                    )
                  ],
                ),
              if (achievement.progress != null && achievement.progress.current != null && achievement.progress.max != null)
                Builder(
                  builder: (context) {
                    double progress = achievement.progress.repeated != null
                      ? achievement.progress.points / achievement.maxPoints
                      : achievement.progress.current / achievement.progress.max;

                    return Padding(
                      padding: EdgeInsets.only(top: 4.0),
                      child: Column(
                        children: <Widget>[
                          Text(
                            '${(progress * 100).round()}%',
                            style: Theme.of(context).textTheme.bodyText1.copyWith(
                              color: Colors.white
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
                                  value: progress,
                                  backgroundColor: Colors.white24
                                ),
                              ),
                            ),
                          )
                        ],
                      ),
                    );
                  }
                ),
              Padding(
                padding: EdgeInsets.only(top: 4.0),
                child: Text(
                  achievement.name,
                  style: Theme.of(context).textTheme.headline1,
                  textAlign: TextAlign.center,
                ),
              ),
              if (achievement.categoryName != null)
                Padding(
                  padding: EdgeInsets.only(top: 4.0),
                  child: Text(
                    achievement.categoryName,
                    style: Theme.of(context).textTheme.bodyText1.copyWith(
                      color: Colors.white
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
            ],
          ),
        ),
        Expanded(
          child: child,
        )
      ],
    );
  }
}

class _AchievementPageContent extends StatelessWidget {
  final Achievement achievement;
  final bool includeProgression;

  _AchievementPageContent({
    @required this.achievement,
    @required this.includeProgression
  });

  @override
  Widget build(BuildContext context) {
    return CompanionListView(
      children: <Widget>[
        if (achievement.description != null && achievement.description.isNotEmpty)
          CompanionInfoCard(title: 'Description', text: GuildWarsUtil.removeOnlyHtml(achievement.description)),
        if (achievement.lockedText != null && achievement.lockedText.isNotEmpty)
          CompanionInfoCard(title: 'Locked description', text: GuildWarsUtil.removeOnlyHtml(achievement.lockedText)),
        if (achievement.requirement != null && achievement.requirement.isNotEmpty)
          CompanionInfoCard(title: 'Requirement', text: GuildWarsUtil.removeOnlyHtml(achievement.requirement)),
        if (achievement.rewards != null && achievement.rewards.isNotEmpty)
          AchievementRewardsCard(achievement: achievement),
        if (achievement.prerequisitesInfo != null && achievement.prerequisitesInfo.isNotEmpty)
          AchievementPrerequisitesCard(achievement: achievement, includeProgression: includeProgression),
        if (achievement.bits != null && achievement.bits.isNotEmpty)
          AchievementBitsCard(achievement: achievement, includeProgression: includeProgression)
      ],
    );
  }
}