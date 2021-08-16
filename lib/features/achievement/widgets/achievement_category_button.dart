import 'package:flutter/material.dart';
import 'package:guildwars2_companion/core/utils/assets.dart';
import 'package:guildwars2_companion/core/widgets/button.dart';
import 'package:guildwars2_companion/core/widgets/cached_image.dart';
import 'package:guildwars2_companion/features/achievement/models/achievement_category.dart';
import 'package:guildwars2_companion/features/achievement/pages/achievements.dart';

class AchievementCategoryButton extends StatelessWidget {
  final AchievementCategory category;

  AchievementCategoryButton({@required this.category});

  @override
  Widget build(BuildContext context) {
    return CompanionButton(
      title: category.name,
      height: 64.0,
      color: Colors.white,
      foregroundColor: Colors.black,
      onTap: () => Navigator.of(context).push(MaterialPageRoute(
        builder: (context) => AchievementsPage(category)
      )),
      leading: _AchievementCategoryLeading(category: category),
      trailing: Row(
        children: category.regions
          .map((r) => Image.asset(
            Assets.getMasteryAsset(r),
            height: 28.0,
            width: 28.0,
          ))
          .toList(),
      ),
    );
  }
}

class _AchievementCategoryLeading extends StatelessWidget {
  final AchievementCategory category;

  _AchievementCategoryLeading({@required this.category});

  @override
  Widget build(BuildContext context) {
    if (category.completedAchievements != null) {
      double ratio = category.completedAchievements / category.achievementsInfo.length;

      return Stack(
        alignment: Alignment.center,
        children: <Widget>[
          Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              CompanionCachedImage(
                height: 40.0,
                imageUrl: category.icon,
                color: Colors.black,
                iconSize: 28,
                fit: BoxFit.fill,
              ),
              Column(
                children: <Widget>[
                  Text(
                    '${(ratio * 100).round()}%',
                    style: TextStyle(
                      color: Theme.of(context).brightness == Brightness.light ? Colors.black : Colors.white,
                    ),
                  ),
                  LinearProgressIndicator(
                    value: ratio,
                    color: Theme.of(context).brightness == Brightness.light ? Colors.black : Colors.white,
                    backgroundColor: Colors.transparent,
                  )
                ],
              )
            ],
          )
        ],
      );
    }

    return CompanionCachedImage(
      height: 48.0,
      imageUrl: category.icon,
      color: Colors.black,
      iconSize: 28,
      fit: BoxFit.fill,
    );
  }
}