import 'dart:math';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:guildwars2_companion/models/items/item.dart';
import 'package:guildwars2_companion/models/items/skin.dart';
import 'package:guildwars2_companion/pages/general/item.dart';
import 'package:guildwars2_companion/utils/guild_wars.dart';

class CompanionItemBox extends StatefulWidget {

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

  @override
  _CompanionItemBoxState createState() => _CompanionItemBoxState();
}

class _CompanionItemBoxState extends State<CompanionItemBox> {

  String _hero;

  @override
  void initState() {
    super.initState();

    if (widget.hero != null) {
      _hero = widget.hero;
    } else if (widget.item != null) {
      _hero = widget.item.id.toString() + _randomString(8);
    }
  }

  String _randomString(int length) {
    var rand = new Random();
    var codeUnits = new List.generate(
        length, 
        (index){
          return rand.nextInt(33)+89;
        }
    );
    
    return new String.fromCharCodes(codeUnits);
  }

  @override
  Widget build(BuildContext context) {
    if (widget.item == null && !widget.displayEmpty) {
      return _buildError();
    }

    if (_hero != null) {
      return Hero(
        tag: _hero,
        child: _buildItemBox(context),
      );
    }

    return _buildItemBox(context);
  }

  Widget _buildItemBox(BuildContext context) {
    return Container(
      width: this.widget.size,
      height: this.widget.size,
      margin: widget.includeMargin ? EdgeInsets.all(4.0) : null,
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
          color: GuildWarsUtil.getRarityColor(widget.displayEmpty ? 'Basic' : widget.item.rarity),
          width: 2.0
        ),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(4.0),
        child: Stack(
          alignment: Alignment.topRight,
          children: <Widget>[
            _buildImage(),
            if (widget.quantity > 1)
              _buildQuantity(),
            if (widget.quantity == 0)
              _buildGreyOverlay(),
            if (widget.markCompleted)
              _buildCompleted(),
            if (widget.enablePopup && !widget.displayEmpty)
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
      ),
    );
  }

  Widget _buildError() {
    return Container(
      width: this.widget.size,
      height: this.widget.size,
      margin: widget.includeMargin ? EdgeInsets.all(4.0) : null,
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
        size: this.widget.size / 1.5,
        color: Colors.white,
      )
    );
  }

  Widget _buildGreyOverlay() { 
    return Container(
      width: this.widget.size,
      height: this.widget.size,
      color: Colors.white54,
    );
  }

  Widget _buildQuantity() {
    return Padding(
      padding: EdgeInsets.only(right: 2.0),
      child: Material(
        color: Colors.transparent,
        child: Text(
          widget.quantity.toString(),
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
    if (widget.displayEmpty) {
      return Container();
    }

    return CachedNetworkImage(
      height: widget.size,
      width: widget.size,
      imageUrl: widget.skin != null ? widget.skin.icon : widget.item.icon,
      placeholder: (context, url) => Theme(
        data: Theme.of(context).copyWith(accentColor: Colors.white),
        child: Center(
          child: Container(
            height: this.widget.size / 1.5,
            width: this.widget.size / 1.5,
            child: CircularProgressIndicator()
          )
        ),
      ),
      errorWidget: (context, url, error) => Center(child: Icon(
        FontAwesomeIcons.dizzy,
        size: this.widget.size / 1.5,
        color: Colors.white,
      )),
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
              item: widget.item,
              skin: widget.skin,
              hero: _hero,
              upgradesInfo: widget.upgradesInfo,
              infusionsInfo: widget.infusionsInfo,
            )
          ))
        ),
      ),
    );
  }
}
