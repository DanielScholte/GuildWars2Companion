import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:guildwars2_companion/models/items/item.dart';
import 'package:guildwars2_companion/models/items/skin.dart';
import 'package:guildwars2_companion/pages/general/item/item.dart';
import 'package:guildwars2_companion/utils/guild_wars.dart';

import 'cached_image.dart';

class CompanionItemBox extends StatelessWidget {

  final Item item;
  final Skin skin;
  final int quantity;
  final bool displayEmpty;
  final bool markCompleted;
  final bool includeMargin;
  final double size;
  final bool enablePopup;
  final List<Item> upgradesInfo;
  final List<Item> infusionsInfo;
  final String hero;

  CompanionItemBox({
    @required this.item,
    this.skin,
    this.quantity = 1,
    this.upgradesInfo,
    this.infusionsInfo, 
    this.size = 55.0,
    this.displayEmpty = false,
    this.includeMargin = false,
    this.enablePopup = true,
    this.markCompleted = false,
    this.hero,
  });

  Widget build(BuildContext context) {
    if (item == null && !displayEmpty) {
      return _buildError();
    }

    if (hero != null) {
      return Hero(
        tag: hero,
        child: _buildItemBox(context),
      );
    }

    return _buildItemBox(context);
  }

  Widget _buildItemBox(BuildContext context) {
    return Container(
      width: this.size,
      height: this.size,
      margin: includeMargin ? EdgeInsets.all(4.0) : null,
      decoration: BoxDecoration(
        color: Colors.grey,
        borderRadius: BorderRadius.circular(6.0),
        boxShadow: [
          if (Theme.of(context).brightness == Brightness.light)
            BoxShadow(
              color: Colors.black26,
              blurRadius: 4.0,
            ),
        ],
        border: Border.all(
          color: GuildWarsUtil.getRarityColor(displayEmpty ? 'Basic' : item.rarity),
          width: 2.0
        ),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(4.0),
        child: Stack(
          alignment: Alignment.topRight,
          children: <Widget>[
            _buildImage(),
            if (quantity > 1)
              _buildQuantity(),
            if (quantity == 0)
              _buildGreyOverlay(),
            if (markCompleted)
              _buildCompleted(),
            if (enablePopup && !displayEmpty)
              _buildInkwell(context),
          ],
        ),
      )
    );
  }

  Widget _buildCompleted() {
    return Container(
      width: double.infinity,
      height: double.infinity,
      color: Colors.white60,
      alignment: Alignment.center,
      child: Icon(
        FontAwesomeIcons.check,
        size: 20.0,
        color: Colors.black,
      ),
    );
  }

  Widget _buildError() {
    return Container(
      width: this.size,
      height: this.size,
      margin: includeMargin ? EdgeInsets.all(4.0) : null,
      decoration: BoxDecoration(
        color: Colors.grey,
        borderRadius: BorderRadius.circular(6.0),
        boxShadow: [
          BoxShadow(
            color: Colors.black26,
            blurRadius: 4.0,
          ),
        ],
        border: Border.all(
          color: GuildWarsUtil.getRarityColor('Basic'),
          width: 2.0
        ),
      ),
      child: Icon(
        FontAwesomeIcons.dizzy,
        size: this.size / 1.5,
        color: Colors.white,
      )
    );
  }

  Widget _buildGreyOverlay() { 
    return Container(
      width: this.size,
      height: this.size,
      color: Colors.white54,
    );
  }

  Widget _buildQuantity() {
    return Padding(
      padding: EdgeInsets.only(right: 2.0),
      child: Material(
        color: Colors.transparent,
        child: Text(
          quantity.toString(),
          style: TextStyle(
            color: Color(0xFFe3e0b5),
            fontSize: 16.0,
            shadows: [
              BoxShadow(
                color: Colors.black,
                blurRadius: 6.0,
              ),
              BoxShadow(
                color: Colors.black,
                blurRadius: 2.0,
              ),
              BoxShadow(
                color: Colors.black,
                blurRadius: 4.0,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildImage() {
    if (displayEmpty) {
      return Container();
    }

    return CompanionCachedImage(
      height: size,
      width: size,
      imageUrl: skin != null ? skin.icon : item.icon,
      iconSize: size / 1.5,
      color: Colors.white,
      fit: BoxFit.cover,
    );
  }

  Widget _buildInkwell(BuildContext context) {
    return Positioned.fill(
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: () => Navigator.of(context).push(MaterialPageRoute(
            builder: (context) => ItemPage(
              item: item,
              skin: skin,
              hero: hero,
              upgradesInfo: upgradesInfo,
              infusionsInfo: infusionsInfo,
            )
          ))
        ),
      ),
    );
  }
}
