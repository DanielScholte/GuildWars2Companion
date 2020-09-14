import 'package:flutter/material.dart';
import 'package:guildwars2_companion/models/build/skill_trait.dart';
import 'package:guildwars2_companion/pages/general/build/skill_trait.dart';

import 'cached_image.dart';

class CompanionSkillTraitBox extends StatelessWidget {
  final SkillTrait skillTrait;
  final String hero;
  final String skillTraitType;
  final double size;
  final double horizontalMargin;
  final bool greyedOut;
  final bool enablePopup;

  CompanionSkillTraitBox({
    @required this.skillTrait,
    @required this.hero,
    this.skillTraitType,
    this.size = 45.0,
    this.greyedOut = false,
    this.horizontalMargin = 6.0,
    this.enablePopup = true,
  });

  @override
  Widget build(BuildContext context) {
    return Hero(
      tag: hero,
      child: Container(
        height: size,
        width: size,
        margin: EdgeInsets.symmetric(vertical: 4.0, horizontal: horizontalMargin),
        decoration: BoxDecoration(
          color: skillTrait != null ? Colors.black : Colors.grey,
          borderRadius: BorderRadius.circular(4.0),
          boxShadow: [
            if (Theme.of(context).brightness == Brightness.light)
              BoxShadow(
                color: Colors.black26,
                blurRadius: 4.0,
              ),
          ],
        ),
        child: skillTrait != null ? ClipRRect(
          borderRadius: BorderRadius.circular(4.0),
          child: Stack(
            alignment: Alignment.center,
            children: <Widget>[
              _buildImage(),
              if (greyedOut)
                _buildGreyOverlay(),
              if (enablePopup)
                _buildInkwell(context),
            ],
          ),
        ) : null,
      ),
    );
  }

  Widget _buildImage() {
    return CompanionCachedImage(
      height: size,
      width: size,
      imageUrl: skillTrait.icon,
      iconSize: size / 1.5,
      color: Colors.white,
      fit: BoxFit.cover,
    );
  }

  Widget _buildGreyOverlay() { 
    return Container(
      width: this.size,
      height: this.size,
      color: Colors.black54,
    );
  }

  Widget _buildInkwell(BuildContext context) {
    return Positioned.fill(
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: () => Navigator.of(context).push(MaterialPageRoute(
            builder: (context) => SkillTraitPage(
              skillTrait: skillTrait,
              hero: hero,
              slotType: skillTraitType,
            )
          ))
        ),
      ),
    );
  }
}