import 'package:flutter/material.dart';
import 'package:guildwars2_companion/core/utils/guild_wars.dart';

class ItemFlags extends StatelessWidget {
  final List<String> flags;

  ItemFlags({@required this.flags});

  @override
  Widget build(BuildContext context) {
    if (flags.isEmpty) {
      return Container();
    }

    return Padding(
      padding: EdgeInsets.all(4.0),
      child: Wrap(
        alignment: WrapAlignment.spaceEvenly,
        spacing: 8.0,
        runSpacing: 8.0,
        children: flags
          .map((flag) => Chip(
            materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
            backgroundColor: Theme.of(context).brightness == Brightness.light ? Theme.of(context).accentColor : Colors.white12,
            label: Text(
              GuildWarsUtil.itemFlagToName(flag),
              style: Theme.of(context).textTheme.bodyText1.copyWith(
                color: Colors.white,
              ),
            ),
          ))
          .toList()
      ),
    );
  }
}