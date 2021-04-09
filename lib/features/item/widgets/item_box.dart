import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:guildwars2_companion/core/utils/guild_wars.dart';
import 'package:guildwars2_companion/core/utils/shadow.dart';
import 'package:guildwars2_companion/core/widgets/cached_image.dart';
import 'package:guildwars2_companion/features/item/enums/item_section.dart';
import 'package:guildwars2_companion/features/item/models/item.dart';
import 'package:guildwars2_companion/features/item/models/skin.dart';
import 'package:guildwars2_companion/features/item/pages/item.dart';

class ItemBox extends StatelessWidget {
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
  final ItemSection section;

  ItemBox({
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
    this.section = ItemSection.ALL,
  });

  Widget build(BuildContext context) {
    if (item == null && !displayEmpty) {
      return _Empty(
        size: size,
        includeMargin: includeMargin
      );
    }

    return _Hero(
      hero: hero,
      child: Container(
        width: this.size,
        height: this.size,
        margin: includeMargin ? EdgeInsets.all(4.0) : EdgeInsets.zero,
        decoration: BoxDecoration(
          color: Colors.grey,
          borderRadius: BorderRadius.circular(6.0),
          boxShadow: [
            if (Theme.of(context).brightness == Brightness.light)
              ShadowUtil.getMaterialShadow()
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
              _Image(
                size: size,
                skin: skin,
                item: item,
                displayEmpty: displayEmpty
              ),
              if (quantity > 1)
                _Quantity(quantity: quantity),
              if (quantity == 0)
                _GreyOverlay(),
              if (markCompleted)
                _Completed(),
              if (enablePopup && !displayEmpty)
                _Inkwell(
                  item: item,
                  skin: skin,
                  hero: hero,
                  upgradesInfo: upgradesInfo,
                  infusionsInfo: infusionsInfo,
                  section: section
                ),
            ],
          ),
        )
      ),
    );
  }
}

class _Inkwell extends StatelessWidget {
  final Item item;
  final Skin skin;
  final String hero;
  final List<Item> upgradesInfo;
  final List<Item> infusionsInfo;
  final ItemSection section;

  _Inkwell({
    @required this.item,
    @required this.skin,
    @required this.hero,
    @required this.upgradesInfo,
    @required this.infusionsInfo,
    @required this.section,
  });

  @override
  Widget build(BuildContext context) {
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
              section: section,
            )
          ))
        ),
      ),
    );
  }
}

class _Image extends StatelessWidget {
  final double size;
  final Skin skin;
  final Item item;
  final bool displayEmpty;

  _Image({
    @required this.size,
    @required this.skin,
    @required this.item,
    @required this.displayEmpty
  });

  @override
  Widget build(BuildContext context) {
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
}

class _Quantity extends StatelessWidget {
  final int quantity;

  _Quantity({
    @required this.quantity,
  });

  @override
  Widget build(BuildContext context) {
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
}

class _GreyOverlay extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: double.infinity,
      color: Colors.white54,
    );
  }
}

class _Completed extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
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
}

class _Empty extends StatelessWidget {
  final double size;
  final bool includeMargin;

  _Empty({
    @required this.size,
    @required this.includeMargin,
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
          if (Theme.of(context).brightness == Brightness.light)
            ShadowUtil.getMaterialShadow()
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
}

class _Hero extends StatelessWidget {
  final String hero;
  final Widget child;

  _Hero({
    @required this.child,
    this.hero
  });

  @override
  Widget build(BuildContext context) {
    if (hero == null) {
      return child;
    }

    return Hero(
      tag: hero,
      child: child,
    );
  }
}