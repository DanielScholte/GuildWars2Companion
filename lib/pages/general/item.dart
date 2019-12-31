import 'package:flutter/material.dart';
import 'package:guildwars2_companion/models/items/item.dart';
import 'package:guildwars2_companion/models/items/skin.dart';
import 'package:guildwars2_companion/widgets/appbar.dart';
import 'package:guildwars2_companion/widgets/item_box.dart';

class ItemPage extends StatelessWidget {

  final Item item;
  final Skin skin;

  ItemPage({
    @required this.item,
    this.skin
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
              children: <Widget>[
                if (skin != null)
                  _buildOriginalItemInfo(),
                _buildItemInfo(),
              ],
            ),
          )
        ],
      ),
    );
  }

  Widget _buildHeader() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.red,
        boxShadow: [
          BoxShadow(
            color: Colors.black38,
            blurRadius: 8.0,
          ),
        ],
        borderRadius: BorderRadius.only(bottomLeft: Radius.circular(12.0), bottomRight: Radius.circular(12.0))
      ),
      margin: EdgeInsets.only(bottom: 16.0),
      width: double.infinity,
      child: SafeArea(
        minimum: EdgeInsets.only(left: 16.0, right: 16.0, bottom: 16.0),
        child: Column(
          children: <Widget>[
            CompanionItemBox(
              item: item,
              skin: skin,
              size: 60.0,
              enablePopup: false,
            ),
            Padding(
              padding: EdgeInsets.all(4.0),
              child: Text(
                skin != null ? skin.name : item.name,
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 22.0
                ),
                textAlign: TextAlign.center,
              ),
            )
          ],
        ),
      ),
    );
  }

  Widget _buildOriginalItemInfo() {
    return Column(
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
              size: 60.0,
              enablePopup: false,
            ),
            Padding(
              padding: EdgeInsets.all(8.0),
              child: Text(
                item.name,
                style: TextStyle(
                  fontSize: 22.0
                ),
                textAlign: TextAlign.center,
              ),
            )
          ],
        )
      ],
    );
  }

  Widget _buildItemInfo() {
    return Column(
      children: <Widget>[

      ],
    );
  }
}