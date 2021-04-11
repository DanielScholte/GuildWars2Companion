import 'package:flutter/material.dart';
import 'package:guildwars2_companion/core/utils/guild_wars.dart';
import 'package:guildwars2_companion/core/widgets/info_card.dart';
import 'package:guildwars2_companion/features/item/enums/item_section.dart';
import 'package:guildwars2_companion/features/item/models/item.dart';
import 'package:guildwars2_companion/features/item/models/skin.dart';
import 'package:guildwars2_companion/features/item/widgets/details_card.dart';
import 'package:guildwars2_companion/features/item/widgets/item_box.dart';
import 'package:guildwars2_companion/features/item/widgets/list_card.dart';
import 'package:guildwars2_companion/core/widgets/header.dart';
import 'package:guildwars2_companion/core/widgets/list_view.dart';
import 'package:guildwars2_companion/features/item/widgets/value_card.dart';

class ItemPage extends StatelessWidget {
  final Item item;
  final Skin skin;
  final String hero;
  final List<Item> upgradesInfo;
  final List<Item> infusionsInfo;
  final ItemSection section;

  ItemPage({
    @required this.item,
    this.skin,
    this.upgradesInfo,
    this.infusionsInfo,
    this.hero,
    this.section,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: <Widget>[
          _Header(
            item: item, 
            skin: skin,
            hero: hero
          ),
          Expanded(
            child: CompanionListView(
              children: <Widget>[
                if (skin != null)
                  ItemListCard(title: 'Transmuted', items: [item], disabled: true),
                if (item.description != null && item.description.isNotEmpty)
                  CompanionInfoCard(title: 'Description', text: GuildWarsUtil.removeOnlyHtml(item.description)),
                ItemDetailsCard(item: item, section: section),
                if (item.type == 'Consumable' && item.details != null && item.details.description != null && item.details.description.isNotEmpty)
                  CompanionInfoCard(title: 'Effect description', text: GuildWarsUtil.removeFullHtml(item.details.description)),
                if (upgradesInfo != null && upgradesInfo.where((up) => up != null).toList().isNotEmpty)
                  ItemListCard(title: 'Upgrades', items: upgradesInfo),
                if (infusionsInfo != null && infusionsInfo.where((inf) => inf != null).toList().isNotEmpty)
                  ItemListCard(title: 'Infusions', items: infusionsInfo),
                ItemValueCard(item: item)
              ],
            ),
          )
        ],
      ),
    );
  }
}

class _Header extends StatelessWidget {
  final Item item;
  final Skin skin;
  final String hero;

  _Header({
    @required this.item,
    @required this.skin,
    @required this.hero,
  });

  @override
  Widget build(BuildContext context) {
    return CompanionHeader(
      includeBack: true,
      wikiName: item.name,
      child: Column(
        children: <Widget>[
          Padding(
            padding: EdgeInsets.only(top: 4.0),
            child: ItemBox(
              item: item,
              skin: skin,
              hero: hero,
              enablePopup: false,
            ),
          ),
          Padding(
            padding: EdgeInsets.all(4.0),
            child: Text(
              skin != null ? skin.name : item.name,
              style: Theme.of(context).textTheme.headline1,
              textAlign: TextAlign.center,
            ),
          ),
          Text(
            item.type != null ? GuildWarsUtil.itemTypeToName(item.type) : '',
            style: Theme.of(context).textTheme.bodyText1.copyWith(
              color: Colors.white
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}
