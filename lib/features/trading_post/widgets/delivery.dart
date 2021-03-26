import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:guildwars2_companion/core/utils/guild_wars.dart';
import 'package:guildwars2_companion/core/widgets/coin.dart';
import 'package:guildwars2_companion/features/item/enums/item_section.dart';
import 'package:guildwars2_companion/features/item/widgets/item_box.dart';
import 'package:guildwars2_companion/features/trading_post/models/delivery.dart';

class TradingPostExpandaleDelivery extends StatefulWidget {
  final TradingPostDelivery tradingPostDelivery;
  final bool expanded;
  final Function onExpand;

  TradingPostExpandaleDelivery({
    @required this.tradingPostDelivery,
    @required this.expanded,
    @required this.onExpand
  });

  @override
  _TradingPostExpandaleDeliveryState createState() => _TradingPostExpandaleDeliveryState();
}

class _TradingPostExpandaleDeliveryState extends State<TradingPostExpandaleDelivery> with TickerProviderStateMixin {
  AnimationController _rotationController;

  @override
  void initState() {
    _rotationController = AnimationController(
      duration: const Duration(milliseconds: 350),
      vsync: this,
    );
    super.initState();
  }

  @override
  void dispose() {
    _rotationController.dispose();
    super.dispose();
  }

  @override
  void didUpdateWidget(TradingPostExpandaleDelivery oldWidget) {
    super.didUpdateWidget(oldWidget);

    if (widget.expanded != oldWidget.expanded) {
      setState(() {
        _rotationController.animateTo(widget.expanded ? 1.0 : 0.0);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      curve: Curves.ease,
      duration: Duration(milliseconds: 350),
      width: double.infinity,
      height: widget.expanded ? 400.0 : 64.0,
      decoration: BoxDecoration(
        color: Theme.of(context).scaffoldBackgroundColor,
        boxShadow: [
          if (Theme.of(context).brightness == Brightness.light)
            BoxShadow(
              color: Colors.grey,
              blurRadius: 5.0,
            ),
        ],
        border: Theme.of(context).brightness == Brightness.dark ? Border(
          top: BorderSide(
            color: Colors.white,
            width: 1.0
          )
        ) : null,
      ),
      child: Column(
        children: <Widget>[
          Material(
            color: Colors.transparent,
            child: InkWell(
              onTap: widget.onExpand,
              child: Padding(
                padding: EdgeInsets.symmetric(
                  horizontal: 16.0,
                  vertical: 8.0
                ),
                child: Row(
                  children: <Widget>[
                    Icon(
                      FontAwesomeIcons.inbox
                    ),
                    Expanded(
                      child: Padding(
                        padding: EdgeInsets.symmetric(horizontal: 16.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: <Widget>[
                            RichText(
                              text: TextSpan(
                                text: 'Items: ',
                                style: Theme.of(context).textTheme.bodyText1.copyWith(
                                  fontWeight: FontWeight.w500
                                ),
                                children: [
                                  TextSpan(
                                    text: GuildWarsUtil.intToString(widget.tradingPostDelivery.items.length),
                                    style: TextStyle(
                                      fontWeight: FontWeight.w400
                                    )
                                  ),
                                ],
                              ),
                            ),
                            Row(
                              children: <Widget>[
                                Text(
                                  'Funds: ',
                                  style: Theme.of(context).textTheme.bodyText1.copyWith(
                                    fontWeight: FontWeight.w500
                                  ),
                                ),
                                CompanionCoin(widget.tradingPostDelivery.coins)
                              ],
                            )
                          ],
                        ),
                      ),
                    ),
                    RotationTransition(
                      turns: Tween(begin: 0.0, end: -0.5).animate(_rotationController),
                      child: Icon(
                        FontAwesomeIcons.chevronUp,
                        size: 18.0,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          if (widget.expanded)
            Builder(
              builder: (context) {
                if (widget.tradingPostDelivery.items.isEmpty) {
                  return Expanded(
                    child: Center(
                      child: Text(
                        'No items found',
                        style: Theme.of(context).textTheme.headline2,
                      ),
                    ),
                  );
                }

                return Expanded(
                  child: ListView(
                    children: <Widget>[
                      Padding(
                        padding: EdgeInsets.all(8.0),
                        child: Wrap(
                          alignment: WrapAlignment.center,
                          spacing: 4.0,
                          runSpacing: 4.0,
                          children: widget.tradingPostDelivery.items
                            .where((i) => i.id != -1)
                            .map((i) => CompanionItemBox(
                              item: i.itemInfo,
                              hero: '${i.id} ${widget.tradingPostDelivery.items.indexOf(i)}',
                              quantity: i.count,
                              includeMargin: false,
                              section: ItemSection.TRADING_POST,
                            ))
                            .toList(),
                        ),
                      ),
                    ],
                  ),
                );
              },
            )
        ],
      ),
    );
  }
}