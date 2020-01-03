import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:guildwars2_companion/models/items/item.dart';
import 'package:guildwars2_companion/models/items/skin.dart';
import 'package:guildwars2_companion/pages/general/item.dart';
import 'package:guildwars2_companion/utils/guild_wars.dart';

class CompanionItemBox extends StatelessWidget {

  final Item item;
  final Skin skin;
  final int quantity;
  final bool displayEmpty;
  final bool includeMargin;
  final double size;
  final bool enablePopup;
  final List<Item> upgradesInfo;
  final List<Item> infusionsInfo;

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
  });

  @override
  Widget build(BuildContext context) {
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
            if (enablePopup && !displayEmpty)
              _buildInkwell(context)
          ],
        ),
      ),
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
      child: Text(
        quantity.toString(),
        style: TextStyle(
          color: Color(0xFFe3e0b5),
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
    );
  }

  Widget _buildImage() {
    if (displayEmpty) {
      return Container();
    }

    if (skin != null) {
      return CachedNetworkImage(
        imageUrl: skin.icon,
        placeholder: (context, url) => Theme(
          data: Theme.of(context).copyWith(accentColor: Colors.white),
          child: Center(child: CircularProgressIndicator()),
        ),
        errorWidget: (context, url, error) => Icon(Icons.error),
        fit: BoxFit.cover,
      );
    }

    return CachedNetworkImage(
      imageUrl: item.icon,
      placeholder: (context, url) => Theme(
        data: Theme.of(context).copyWith(accentColor: Colors.white),
        child: Center(child: CircularProgressIndicator()),
      ),
      errorWidget: (context, url, error) => Icon(Icons.error),
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
              upgradesInfo: upgradesInfo,
              infusionsInfo: infusionsInfo,
            )
          ))
        ),
      ),
    );
  }
}