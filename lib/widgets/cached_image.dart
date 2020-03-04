import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:guildwars2_companion/widgets/accent.dart';

class CompanionCachedImage extends StatelessWidget {

  final String imageUrl;
  final Color color;
  final double iconSize;
  final BoxFit fit;
  final double height;
  final double width;

  const CompanionCachedImage({
    this.imageUrl,
    @required this.color,
    @required this.iconSize,
    @required this.fit,
    this.height,
    this.width
  });

  @override
  Widget build(BuildContext context) {
    if (imageUrl == null) {
      return Container();
    }

    return CachedNetworkImage(
      height: height,
      width: width,
      imageUrl: imageUrl,
      placeholder: (context, url) => CompanionAccent(
        lightColor: color,
        child: Center(child: CircularProgressIndicator()),
      ),
      errorWidget: (context, url, error) => Center(child: Icon(
        FontAwesomeIcons.dizzy,
        size: iconSize,
        color: color,
      )),
      fit: fit,
    );
  }
}