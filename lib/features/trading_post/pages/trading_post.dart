import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:guildwars2_companion/core/widgets/accent.dart';
import 'package:guildwars2_companion/core/widgets/appbar.dart';
import 'package:guildwars2_companion/core/widgets/button.dart';
import 'package:guildwars2_companion/core/widgets/cached_image.dart';
import 'package:guildwars2_companion/core/widgets/coin.dart';
import 'package:guildwars2_companion/features/error/widgets/error.dart';
import 'package:guildwars2_companion/core/widgets/list_view.dart';
import 'package:guildwars2_companion/features/trading_post/bloc/bloc.dart';
import 'package:guildwars2_companion/features/trading_post/models/transaction.dart';
import 'package:guildwars2_companion/features/trading_post/pages/trading_post_item.dart';
import 'package:guildwars2_companion/features/trading_post/widgets/delivery.dart';

class TradingPostPage extends StatefulWidget {
  @override
  _TradingPostPageState createState() => _TradingPostPageState();
}

class _TradingPostPageState extends State<TradingPostPage> {
  bool _expanded = false;

  @override
  Widget build(BuildContext context) {
    return CompanionAccent(
      lightColor: Colors.green,
      child: DefaultTabController(
        length: 4,
        child: Scaffold(
          appBar: CompanionAppBar(
            title: 'Trading Post',
            color: Colors.green,
            elevation: 0.0,
          ),
          body: Column(
            children: <Widget>[
              Material(
                color: Theme.of(context).brightness == Brightness.light ? Colors.green : Theme.of(context).cardColor,
                elevation: Theme.of(context).brightness == Brightness.light ? 4.0 : 0.0,
                child: TabBar(
                  indicatorColor: Colors.white,
                  tabs: [
                    Tab(
                      child: Text(
                        'Buying',
                        style: TextStyle(
                          fontSize: 14.0
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    Tab(
                      child: Text(
                        'Selling',
                        style: TextStyle(
                          fontSize: 14.0
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    Tab(
                      child: Text(
                        'Bought',
                        style: TextStyle(
                          fontSize: 14.0
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    Tab(
                      child: Text(
                        'Sold',
                        style: TextStyle(
                          fontSize: 14.0
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),
              ),
              Expanded(
                child: BlocBuilder<TradingPostBloc, TradingPostState>(
                  builder: (context, state) {
                    if (state is ErrorTradingPostState) {
                      return Center(
                        child: CompanionError(
                          title: 'the trading post',
                          onTryAgain: () =>
                            BlocProvider.of<TradingPostBloc>(context).add(LoadTradingPostEvent()),
                        ),
                      );
                    }

                    if (state is LoadedTradingPostState) {
                      return Stack(
                        children: <Widget>[
                          Padding(
                            padding: EdgeInsets.only(bottom: 64.0),
                            child: TabBarView(
                              children: [
                                state.buying,
                                state.selling,
                                state.bought,
                                state.sold
                              ]
                              .map((t) => _TransactionTab(transactions: t))
                              .toList(),
                            ),
                          ),
                          _DeliveryBackground(
                            display: _expanded,
                            onTap: () => _toggleExpanded(),
                          ),
                          Align(
                            alignment: Alignment.bottomCenter,
                            child: TradingPostExpandableDelivery(
                              tradingPostDelivery: state.tradingPostDelivery,
                              expanded: _expanded,
                              onExpand: () => _toggleExpanded(),
                            ),
                          )
                        ],
                      );
                    }

                    return Center(
                      child: CircularProgressIndicator(),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _toggleExpanded() {
    setState(() {
      _expanded = !_expanded;
    });
  }
}

class _TransactionTab extends StatelessWidget {
  final List<TradingPostTransaction> transactions;

  _TransactionTab({@required this.transactions});

  @override
  Widget build(BuildContext context) {
    if (transactions.where((t) => t.itemInfo != null).isEmpty) {
      return RefreshIndicator(
        backgroundColor: Theme.of(context).brightness == Brightness.light ? Colors.green : Colors.white,
        color: Theme.of(context).cardColor,
        onRefresh: () async {
          BlocProvider.of<TradingPostBloc>(context).add(LoadTradingPostEvent());
          await Future.delayed(Duration(milliseconds: 200), () {});
        },
        child: ListView(
          children: <Widget>[
            Center(
              child: Padding(
                padding: EdgeInsets.all(16.0),
                child: Text(
                  'No items found',
                  style: Theme.of(context).textTheme.headline2,
                ),
              ),
            ),
          ],
        ),
      );
    }

    return RefreshIndicator(
      backgroundColor: Theme.of(context).brightness == Brightness.light ? Colors.green : Colors.white,
      color: Theme.of(context).cardColor,
      onRefresh: () async {
        BlocProvider.of<TradingPostBloc>(context).add(LoadTradingPostEvent());
        await Future.delayed(Duration(milliseconds: 200), () {});
      },
      child: CompanionListView(
        children: transactions
          .where((t) => t.itemInfo != null)
          .map((t) => CompanionButton(
            leading: Stack(
              alignment: Alignment.topRight,
              children: <Widget>[
                CompanionCachedImage(
                  height: 64.0,
                  imageUrl: t.itemInfo.icon,
                  color: Colors.black,
                  iconSize: 28,
                  fit: BoxFit.fill,
                ),
                if (t.quantity > 1)
                  Padding(
                    padding: EdgeInsets.only(right: 2.0),
                    child: Text(
                      t.quantity.toString(),
                      style: TextStyle(
                        color: Color(0xFFe3e0b5),
                        fontSize: 18.0,
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
              ],
            ),
            subtitleWidgets: <Widget>[
              CompanionCoin(t.price)
            ],
            height: 64.0,
            title: t.itemInfo.name,
            color: Colors.white,
            foregroundColor: Colors.black,
            onTap: () {
              if (!t.loading && t.listing == null) {
                BlocProvider.of<TradingPostBloc>(context).add(LoadTradingPostListingsEvent(
                  itemId: t.itemId
                ));
              }

              Navigator.of(context).push(MaterialPageRoute(
                builder: (context) => TradingPostItemPage(
                  item: t.itemInfo,
                  orderValue: t.purchased == null ? t.price : null,
                ),
              ));
            },
          ))
          .toList(),
      ),
    );
  }
}

class _DeliveryBackground extends StatelessWidget {
  final bool display;
  final Function onTap;

  _DeliveryBackground({
    @required this.display,
    @required this.onTap
  });

  @override
  Widget build(BuildContext context) {
    return IgnorePointer(
      ignoring: !display,
      child: GestureDetector(
        onTap: onTap,
        child: AnimatedContainer(
          duration: Duration(milliseconds: 350),
          height: double.infinity,
          width: double.infinity,
          color: display ? Colors.black38 : Colors.transparent,
        ),
      ),
    );
  }
}