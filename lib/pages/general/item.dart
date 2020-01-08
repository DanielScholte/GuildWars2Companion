import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:guildwars2_companion/models/items/item.dart';
import 'package:guildwars2_companion/models/items/skin.dart';
import 'package:guildwars2_companion/models/trading_post/price.dart';
import 'package:guildwars2_companion/repositories/trading_post.dart';
import 'package:guildwars2_companion/utils/guild_wars.dart';
import 'package:guildwars2_companion/widgets/appbar.dart';
import 'package:guildwars2_companion/widgets/card.dart';
import 'package:guildwars2_companion/widgets/coin.dart';
import 'package:guildwars2_companion/widgets/header.dart';
import 'package:guildwars2_companion/widgets/info_row.dart';
import 'package:guildwars2_companion/widgets/item_box.dart';

class ItemPage extends StatelessWidget {

  final Item item;
  final Skin skin;
  final List<Item> upgradesInfo;
  final List<Item> infusionsInfo;

  ItemPage({
    @required this.item,
    this.skin,
    this.upgradesInfo,
    this.infusionsInfo,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CompanionAppBar(
        title: '',
        color: Colors.red,
        foregroundColor: Colors.white,
      ),
      body: Column(
        children: <Widget>[
          _buildHeader(),
          Expanded(
            child: ListView(
              padding: EdgeInsets.only(top: 8.0),
              children: <Widget>[
                if (skin != null)
                  _buildTransmutedItemInfo(),
                if (item.description != null && item.description.isNotEmpty)
                  _buildItemDescription(),
                if (item.details != null)
                  _buildItemDetails()
                else
                  _buildRarityOnlyDetails(),
                if (upgradesInfo != null && upgradesInfo.where((up) => up != null).toList().isNotEmpty)
                  _buildItemList('Upgrades', upgradesInfo),
                if (infusionsInfo != null && infusionsInfo.where((inf) => inf != null).toList().isNotEmpty)
                  _buildItemList('Infusions', infusionsInfo),
                _buildValue(context)
              ],
            ),
          )
        ],
      ),
    );
  }

  Widget _buildHeader() {
    return CompanionHeader(
      child: Column(
        children: <Widget>[
          Padding(
            padding: EdgeInsets.only(top: 4.0),
            child: CompanionItemBox(
              item: item,
              skin: skin,
              size: 60.0,
              enablePopup: false,
            ),
          ),
          Padding(
            padding: EdgeInsets.all(4.0),
            child: Text(
              skin != null ? skin.name : item.name,
              style: TextStyle(
                color: Colors.white,
                fontSize: 22.0,
              ),
              textAlign: TextAlign.center,
            ),
          ),
          Text(
            item.type != null ? typeToName(item.type) : '',
            style: TextStyle(
              color: Colors.white,
              fontSize: 16.0
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildTransmutedItemInfo() {
    return CompanionCard(
      child: Column(
        children: <Widget>[
          Padding(
            padding: EdgeInsets.only(bottom: 8.0),
            child: Text(
              'Transmuted',
              style: TextStyle(
                fontSize: 18.0
              ),
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              CompanionItemBox(
                item: item,
                size: 45.0,
                enablePopup: false,
              ),
              Padding(
                padding: EdgeInsets.all(8.0),
                child: Text(
                  item.name,
                  style: TextStyle(
                    fontSize: 16.0
                  ),
                  textAlign: TextAlign.center,
                ),
              )
            ],
          )
        ],
      ),
    );
  }

  Widget _buildItemList(String header, List<Item> items) {
    return CompanionCard(
      child: Column(
        children: <Widget>[
          Padding(
            padding: EdgeInsets.only(bottom: 8.0),
            child: Text(
              header,
              style: TextStyle(
                fontSize: 18.0
              ),
            ),
          ),
          Column(
            children: items
            .where((i) => i != null)
            .map((i) => Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                CompanionItemBox(
                  item: i,
                  size: 45.0,
                  includeMargin: true,
                ),
                Padding(
                  padding: EdgeInsets.all(4.0),
                  child: Text(
                    i.name,
                    style: TextStyle(
                      fontSize: 16.0
                    ),
                    textAlign: TextAlign.center,
                  ),
                )
              ],
            ))
            .toList(),
          )
        ],
      ),
    );
  }

  Widget _buildItemDescription() {
    return CompanionCard(
      child: Column(
        children: <Widget>[
          Padding(
            padding: EdgeInsets.only(bottom: 8.0),
            child: Text(
              'Description',
              style: TextStyle(
                fontSize: 18.0
              ),
            ),
          ),
          Text(
            removeAllHtmlTags(item.description),
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

  Widget _buildItemDetails() {
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
                style: TextStyle(
                  fontSize: 18.0
                ),
              ),
            ),
            InfoRow(
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

    return _buildRarityOnlyDetails();
  }

  Widget _buildArmorDetails() {
    return Column(
      children: <Widget>[
        InfoRow(
          header: 'Type',
          text: typeToName(item.details.type)
        ),
        InfoRow(
          header: 'Weight Class',
          text: item.details.weightClass
        ),
        InfoRow(
          header: 'Defense',
          text: GuildWarsUtil.intToString(item.details.defense)
        ),
      ],
    );
  }

  Widget _buildBagDetails() {
    return Column(
      children: <Widget>[
        InfoRow(
          header: 'Size',
          text: GuildWarsUtil.intToString(item.details.size)
        ),
      ],
    );
  }

  Widget _buildConsumableDetails() {
    return Column(
      children: <Widget>[
        InfoRow(
          header: 'Type',
          text: typeToName(item.details.type)
        ),
        if (item.details.durationMs != null)
          InfoRow(
            header: 'Duration',
            text: GuildWarsUtil.durationToTextString(Duration(milliseconds: item.details.durationMs)),
          ),
        if (item.details.name != null)
          InfoRow(
            header: 'Effect Type',
            text: item.details.name
          ),
      ],
    );
  }

  Widget _buildTypeOnlyDetails() {
    return Column(
      children: <Widget>[
        InfoRow(
          header: 'Type',
          text: item.details.type
        ),
      ],
    );
  }

  Widget _buildToolDetails() {
    return Column(
      children: <Widget>[
        InfoRow(
          header: 'Charges',
          text: GuildWarsUtil.intToString(item.details.charges)
        ),
      ],
    );
  }

  Widget _buildRarityOnlyDetails() {
    return CompanionCard(
      child: Column(
        children: <Widget>[
          Padding(
            padding: EdgeInsets.only(bottom: 8.0),
            child: Text(
              'Stats',
              style: TextStyle(
                fontSize: 18.0
              ),
            ),
          ),
          InfoRow(
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
        InfoRow(
          header: 'Type',
          text: item.details.type
        ),
        InfoRow(
          header: 'Weapon Strength',
          text: '${GuildWarsUtil.intToString(item.details.minPower)} - ${GuildWarsUtil.intToString(item.details.maxPower)}'
        ),
        if (item.details.defense != null && item.details.defense > 0)
          InfoRow(
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
                    style: TextStyle(
                      fontSize: 18.0
                    ),
                  ),
                ),
                InfoRow(
                  header: 'Vendor',
                  widget: CompanionCoin(item.vendorValue)
                ),
                InfoRow(
                  header: 'Trading Post Buy',
                  text: '-'
                ),
                InfoRow(
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
                    style: TextStyle(
                      fontSize: 18.0
                    ),
                  ),
                ),
                InfoRow(
                  header: 'Vendor',
                  widget: CompanionCoin(item.vendorValue)
                ),
                InfoRow(
                  header: 'Trading Post Buy',
                  widget: Container(
                    width: 16.0,
                    height: 16.0,
                    child: CircularProgressIndicator(
                      strokeWidth: 2.0,
                    ),
                  ),
                ),
                InfoRow(
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
                  style: TextStyle(
                    fontSize: 18.0
                  ),
                ),
              ),
              InfoRow(
                header: 'Vendor',
                widget: CompanionCoin(item.vendorValue)
              ),
              InfoRow(
                header: 'Trading Post Buy',
                widget: CompanionCoin(snapshot.data.buys.unitPrice)
              ),
              InfoRow(
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