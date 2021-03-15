import 'package:flutter/material.dart';
import 'package:guildwars2_companion/core/widgets/info_card.dart';
import 'package:guildwars2_companion/features/item/models/item.dart';
import 'package:guildwars2_companion/features/item/widgets/item_box.dart';

class ItemListCard extends StatelessWidget {
  final String title;
  final List<Item> items;
  final bool disabled;

  ItemListCard({
    @required this.title,
    @required this.items,
    this.disabled = false
  });
  @override
  Widget build(BuildContext context) {
    return CompanionInfoCard(
      title: title,
      child: Column(
        children: Iterable
          .generate(items.length, (index) => Row(
            children: <Widget>[
              CompanionItemBox(
                item: items[index],
                hero: disabled ? null : '$title $index ${items[index].id}',
                size: 45.0,
                includeMargin: true,
                enablePopup: !disabled,
              ),
              Padding(
                padding: EdgeInsets.all(4.0),
                child: Text(
                  items[index].name,
                  style: Theme.of(context).textTheme.bodyText1,
                  textAlign: TextAlign.center,
                ),
              )
            ],
          ))
          .toList(),
      ),
    );
  }
}