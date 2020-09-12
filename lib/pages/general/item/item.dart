import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:guildwars2_companion/models/items/item.dart';
import 'package:guildwars2_companion/models/items/skin.dart';
import 'package:guildwars2_companion/models/trading_post/price.dart';
import 'package:guildwars2_companion/repositories/trading_post.dart';
import 'package:guildwars2_companion/utils/guild_wars.dart';
import 'package:guildwars2_companion/widgets/card.dart';
import 'package:guildwars2_companion/widgets/coin.dart';
import 'package:guildwars2_companion/widgets/header.dart';
import 'package:guildwars2_companion/widgets/info_row.dart';
import 'package:guildwars2_companion/widgets/item_box.dart';
import 'package:guildwars2_companion/widgets/list_view.dart';

class ItemPage extends StatelessWidget {

  final Item item;
  final Skin skin;
  final String hero;
  final List<Item> upgradesInfo;
  final List<Item> infusionsInfo;

  ItemPage({
    @required this.item,
    this.skin,
    this.upgradesInfo,
    this.infusionsInfo,
    this.hero,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: <Widget>[
          _buildHeader(context),
          Expanded(
            child: CompanionListView(
              children: <Widget>[
                if (skin != null)
                  _buildTransmutedItemInfo(context),
                if (item.description != null && item.description.isNotEmpty)
                  _buildItemDescription(context),
                if (item.details != null)
                  _buildItemDetails(context)
                else
                  _buildRarityOnlyDetails(context),
                if (item.type == 'Consumable' && item.details != null && item.details.description != null && item.details.description.isNotEmpty)
                  _buildConsumableDescription(context),
                if (upgradesInfo != null && upgradesInfo.where((up) => up != null).toList().isNotEmpty)
                  _buildItemList(context, 'Upgrades', upgradesInfo),
                if (infusionsInfo != null && infusionsInfo.where((inf) => inf != null).toList().isNotEmpty)
                  _buildItemList(context, 'Infusions', infusionsInfo),
                _buildValue(context)
              ],
            ),
          )
        ],
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    return CompanionHeader(
      includeBack: true,
      wikiName: item.name,
      child: Column(
        children: <Widget>[
          Padding(
            padding: EdgeInsets.only(top: 4.0),
            child: CompanionItemBox(
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
            item.type != null ? typeToName(item.type) : '',
            style: Theme.of(context).textTheme.bodyText1.copyWith(
              color: Colors.white
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildTransmutedItemInfo(BuildContext context) {
    return CompanionCard(
      child: Column(
        children: <Widget>[
          Padding(
            padding: EdgeInsets.only(bottom: 8.0),
            child: Text(
              'Transmuted',
              style: Theme.of(context).textTheme.headline2,
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: <Widget>[
              CompanionItemBox(
                item: item,
                size: 45.0,
                enablePopup: false,
                includeMargin: true,
              ),
              Padding(
                padding: EdgeInsets.all(8.0),
                child: Text(
                  item.name,
                  style: Theme.of(context).textTheme.bodyText1,
                  textAlign: TextAlign.center,
                ),
              )
            ],
          )
        ],
      ),
    );
  }

  Widget _buildItemList(BuildContext context, String header, List<Item> items) {
    List<Widget> itemWidgets = [];

    for (var i = 0; i < items.length; i++) {
      itemWidgets.add(Row(
        children: <Widget>[
          CompanionItemBox(
            item: items[i],
            hero: '$header $i ${items[i].id}',
            size: 45.0,
            includeMargin: true,
          ),
          Padding(
            padding: EdgeInsets.all(4.0),
            child: Text(
              items[i].name,
              style: Theme.of(context).textTheme.bodyText1,
              textAlign: TextAlign.center,
            ),
          )
        ],
      ));
    }

    return CompanionCard(
      child: Column(
        children: <Widget>[
          Padding(
            padding: EdgeInsets.only(bottom: 8.0),
            child: Text(
              header,
              style: Theme.of(context).textTheme.headline2,
            ),
          ),
          Column(
            children: itemWidgets,
          )
        ],
      ),
    );
  }

  Widget _buildItemDescription(BuildContext context) {
    return CompanionCard(
      child: Column(
        children: <Widget>[
          Padding(
            padding: EdgeInsets.only(bottom: 8.0),
            child: Text(
              'Description',
              style: Theme.of(context).textTheme.headline2,
            ),
          ),
          Text(
            GuildWarsUtil.removeOnlyHtml(item.description),
            style: Theme.of(context).textTheme.bodyText1,
          ),
        ],
      ),
    );
  }

  Widget _buildConsumableDescription(BuildContext context) {
    return CompanionCard(
      child: Column(
        children: <Widget>[
          Padding(
            padding: EdgeInsets.only(bottom: 8.0),
            child: Text(
              'Effect description',
              style: Theme.of(context).textTheme.headline2,
            ),
          ),
          Text(
            GuildWarsUtil.removeFullHtml(item.details.description),
            style: Theme.of(context).textTheme.bodyText1,
          ),
        ],
      ),
    );
  }

  Widget _buildItemDetails(BuildContext context) {
    if ([
      'Armor',
      'Bag',
      'Consumable',
      'Gathering',
      'Tool',
      'Trinket',
      'UpgradeComponent',
      'Weapon'
    ].contains(item.type))  {
      return CompanionCard(
        child: Column(
          children: <Widget>[
            Padding(
              padding: EdgeInsets.only(bottom: 8.0),
              child: Text(
                'Stats',
                style: Theme.of(context).textTheme.headline2,
              ),
            ),
            CompanionInfoRow(
              header: 'Rarity',
              text: item.rarity
            ),
            if (item.type == 'Armor')
              _buildArmorDetails(),
            if (item.type == 'Bag')
              _buildBagDetails(),
            if (item.type == 'Consumable')
              _buildConsumableDetails(),
            if (item.type == 'Gathering' || item.type == 'Trinket' || item.type == 'UpgradeComponent')
              _buildTypeOnlyDetails(),
            if (item.type == 'Tool')
              _buildToolDetails(),
            if (item.type == 'Weapon')
              _buildWeaponDetails()
          ],
        ),
      );
    }

    return _buildRarityOnlyDetails(context);
  }

  Widget _buildArmorDetails() {
    return Column(
      children: <Widget>[
        CompanionInfoRow(
          header: 'Type',
          text: typeToName(item.details.type)
        ),
        CompanionInfoRow(
          header: 'Weight Class',
          text: item.details.weightClass
        ),
        CompanionInfoRow(
          header: 'Defense',
          text: GuildWarsUtil.intToString(item.details.defense)
        ),
      ],
    );
  }

  Widget _buildBagDetails() {
    return Column(
      children: <Widget>[
        CompanionInfoRow(
          header: 'Size',
          text: GuildWarsUtil.intToString(item.details.size)
        ),
      ],
    );
  }

  Widget _buildConsumableDetails() {
    return Column(
      children: <Widget>[
        CompanionInfoRow(
          header: 'Type',
          text: typeToName(item.details.type)
        ),
        if (item.details.durationMs != null)
          CompanionInfoRow(
            header: 'Duration',
            text: GuildWarsUtil.durationToTextString(Duration(milliseconds: item.details.durationMs)),
          ),
        if (item.details.name != null)
          CompanionInfoRow(
            header: 'Effect Type',
            text: item.details.name
          ),
      ],
    );
  }

  Widget _buildTypeOnlyDetails() {
    return Column(
      children: <Widget>[
        CompanionInfoRow(
          header: 'Type',
          text: item.details.type
        ),
      ],
    );
  }

  Widget _buildToolDetails() {
    return Column(
      children: <Widget>[
        CompanionInfoRow(
          header: 'Charges',
          text: GuildWarsUtil.intToString(item.details.charges)
        ),
      ],
    );
  }

  Widget _buildRarityOnlyDetails(BuildContext context) {
    return CompanionCard(
      child: Column(
        children: <Widget>[
          Padding(
            padding: EdgeInsets.only(bottom: 8.0),
            child: Text(
              'Stats',
              style: Theme.of(context).textTheme.headline2,
            ),
          ),
          CompanionInfoRow(
            header: 'Rarity',
            text: item.rarity
          ),
        ],
      ),
    );
  }

  Widget _buildWeaponDetails() {
    return Column(
      children: <Widget>[
        CompanionInfoRow(
          header: 'Type',
          text: item.details.type
        ),
        CompanionInfoRow(
          header: 'Weapon Strength',
          text: '${GuildWarsUtil.intToString(item.details.minPower)} - ${GuildWarsUtil.intToString(item.details.maxPower)}'
        ),
        if (item.details.defense != null && item.details.defense > 0)
          CompanionInfoRow(
            header: 'Defense',
            text: GuildWarsUtil.intToString(item.details.defense)
          ),
      ],
    );
  }

  Widget _buildValue(BuildContext context) {
    return FutureBuilder<TradingPostPrice>(
      future: RepositoryProvider.of<TradingPostRepository>(context).getItemPrice(item.id),
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return CompanionCard(
            child: Column(
              children: <Widget>[
                Padding(
                  padding: EdgeInsets.only(bottom: 8.0),
                  child: Text(
                    'Value',
                    style: Theme.of(context).textTheme.headline2,
                  ),
                ),
                CompanionInfoRow(
                  header: 'Vendor',
                  widget: CompanionCoin(item.vendorValue)
                ),
                CompanionInfoRow(
                  header: 'Trading Post Buy',
                  text: '-'
                ),
                CompanionInfoRow(
                  header: 'Trading Post Sell',
                  text: '-'
                ),
              ],
            ),
          );
        }

        if (!snapshot.hasData) {
          return CompanionCard(
            child: Column(
              children: <Widget>[
                Padding(
                  padding: EdgeInsets.only(bottom: 8.0),
                  child: Text(
                    'Value',
                    style: Theme.of(context).textTheme.headline2,
                  ),
                ),
                CompanionInfoRow(
                  header: 'Vendor',
                  widget: CompanionCoin(item.vendorValue)
                ),
                CompanionInfoRow(
                  header: 'Trading Post Buy',
                  widget: Container(
                    width: 16.0,
                    height: 16.0,
                    child: CircularProgressIndicator(
                      strokeWidth: 2.0,
                    ),
                  ),
                ),
                CompanionInfoRow(
                  header: 'Trading Post Sell',
                  widget: Container(
                    width: 16.0,
                    height: 16.0,
                    child: CircularProgressIndicator(
                      strokeWidth: 2.0,
                    ),
                  ),
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
                  'Value',
                  style: Theme.of(context).textTheme.headline2,
                ),
              ),
              CompanionInfoRow(
                header: 'Vendor',
                widget: CompanionCoin(item.vendorValue)
              ),
              CompanionInfoRow(
                header: 'Trading Post Buy',
                widget: CompanionCoin(snapshot.data.buys.unitPrice)
              ),
              CompanionInfoRow(
                header: 'Trading Post Sell',
                widget: CompanionCoin(snapshot.data.sells.unitPrice)
              ),
            ],
          ),
        );
      },
    );
  }

  String typeToName(String type) {
    switch (type) {
      case 'HelmAquatic':
        return 'Helm Aquatic';
      case 'AppearanceChange':
        return 'Appearance Change';
      case 'ContractNpc':
        return 'Npc Contract';
      case 'MountRandomUnlock':
        return 'Random Mount Unlock';
      case 'RandomUnlock':
        return 'Random Unlock';
      case 'UpgradeRemoval':
        return 'Upgrade Removal';
      case 'TeleportToFriend':
        return 'Teleport To Friend';
      case 'CraftingMaterial':
        return 'Crafting Material';
      case 'UpgradeComponent':
        return 'Upgrade Component';
      default:
        return type;
    }
  }
}
