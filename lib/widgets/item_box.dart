import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:guildwars2_companion/models/items/item.dart';
import 'package:guildwars2_companion/models/items/skin.dart';
import 'package:guildwars2_companion/utils/gw.dart';

class CompanionItemBox extends StatelessWidget {

  final Item item;
  final Skin skin;
  final int quantity;
  final bool displayEmpty;
  final bool includeMargin;
  final double size;

  CompanionItemBox({
    @required this.item,
    this.skin,
    this.quantity = 1,
    this.size = 55.0,
    this.displayEmpty = false,
    this.includeMargin = false
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: this.size,
      height: this.size,
      margin: includeMargin ? EdgeInsets.all(4.0) : null,
      decoration: BoxDecoration(
        color: Theme.of(context).scaffoldBackgroundColor,
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
          ],
        ),
      ),
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
      return Container(
        color: Colors.grey,
      );
    }

    if (skin != null) {
      return CachedNetworkImage(
        imageUrl: skin.icon,
        placeholder: (context, url) => Theme(
          data: Theme.of(context).copyWith(accentColor: Colors.white),
          child: CircularProgressIndicator(),
        ),
        errorWidget: (context, url, error) => Icon(Icons.error),
        fit: BoxFit.cover,
      );
    }

    return CachedNetworkImage(
      imageUrl: item.icon,
      placeholder: (context, url) => Theme(
        data: Theme.of(context).copyWith(accentColor: Colors.white),
        child: CircularProgressIndicator(),
      ),
      errorWidget: (context, url, error) => Icon(Icons.error),
      fit: BoxFit.cover,
    );
  }
}