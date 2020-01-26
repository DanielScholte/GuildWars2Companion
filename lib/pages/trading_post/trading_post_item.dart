import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:guildwars2_companion/blocs/trading_post/bloc.dart';
import 'package:guildwars2_companion/models/items/item.dart';
import 'package:guildwars2_companion/models/trading_post/listing_offer.dart';
import 'package:guildwars2_companion/models/trading_post/transaction.dart';
import 'package:guildwars2_companion/pages/general/item.dart';
import 'package:guildwars2_companion/utils/guild_wars.dart';
import 'package:guildwars2_companion/widgets/coin.dart';
import 'package:guildwars2_companion/widgets/error.dart';
import 'package:guildwars2_companion/widgets/info_row.dart';

class TradingPostItemPage extends StatelessWidget {

  final Item item;
  final int orderValue;

  TradingPostItemPage({
    @required this.item,
    this.orderValue,
  });

  @override
  Widget build(BuildContext context) {
    return Theme(
      data: Theme.of(context).copyWith(accentColor: Colors.red),
      child: DefaultTabController(
        length: 2,
        child: Scaffold(
          appBar: AppBar(
            backgroundColor: Colors.red,
            elevation: 0.0,
            title: Row(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                Padding(
                  padding: EdgeInsets.only(right: 4.0),
                  child: Container(
                    width: 28,
                    height: 28,
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(4.0),
                      child: CachedNetworkImage(
                        imageUrl: item.icon,
                        placeholder: (context, url) => Theme(
                          data: Theme.of(context).copyWith(accentColor: Colors.white),
                          child: CircularProgressIndicator(),
                        ),
                        errorWidget: (context, url, error) => Center(child: Icon(
                          FontAwesomeIcons.dizzy,
                          size: 20,
                          color: Colors.white,
                        )),
                        fit: BoxFit.contain,
                      ),
                    ),
                  ),
                ),
                Expanded(
                  child: Text(
                    item.name,
                    style: TextStyle(
                      color: Colors.white
                    ),
                  ),
                )
              ],
            ),
            actions: <Widget>[
              IconButton(
                icon: Icon(
                  FontAwesomeIcons.infoCircle,
                  size: 20.0,
                ),
                onPressed: () => Navigator.of(context).push(MaterialPageRoute(
                  builder: (context) => ItemPage(
                    item: item,
                  ),
                )),
              )
            ],
          ),
          body: Column(
            children: <Widget>[
              Material(
                color: Colors.red,
                elevation: 4.0,
                child: TabBar(
                  indicatorColor: Colors.white,
                  tabs: [
                    Tab(
                      child: Text(
                        'Buyers',
                        style: TextStyle(
                          fontSize: 16.0
                        ),
                      ),
                    ),
                    Tab(
                      child: Text(
                        'Sellers',
                        style: TextStyle(
                          fontSize: 16.0
                        ),
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
                          title: 'the listings',
                          onTryAgain: () =>
                            BlocProvider.of<TradingPostBloc>(context).add(LoadTradingPostEvent()),
                        ),
                      );
                    }

                    if (state is LoadedTradingPostState && state.hasError) {
                      return Center(
                        child: CompanionError(
                          title: 'the listings',
                          onTryAgain: () =>
                            BlocProvider.of<TradingPostBloc>(context).add(LoadTradingPostListingsEvent(
                              buying: state.buying,
                              selling: state.selling,
                              bought: state.bought,
                              sold: state.sold,
                              tradingPostDelivery: state.tradingPostDelivery,
                              itemId: item.id,
                            )),
                        ),
                      );
                    }

                    if (state is LoadedTradingPostState) {
                      TradingPostTransaction tradingPostTransaction = _getTradingPostTransaction(state);

                      if (tradingPostTransaction != null && !tradingPostTransaction.loading && tradingPostTransaction.listing != null) {
                        return TabBarView(
                          children: <Widget>[
                            _buildListingTab(context, state, tradingPostTransaction.listing.buys, 'Ordered', 'No orders found'),
                            _buildListingTab(context, state, tradingPostTransaction.listing.sells, 'Available', 'No items found'),
                          ],
                        );
                      }
                      
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

  Widget _buildListingTab(BuildContext context, LoadedTradingPostState state, List<ListingOffer> offers, String type, String error) {
    if (offers.isEmpty) {
      return RefreshIndicator(
        backgroundColor: Theme.of(context).accentColor,
        color: Colors.white,
        onRefresh: () async {
          BlocProvider.of<TradingPostBloc>(context).add(LoadTradingPostListingsEvent(
            buying: state.buying,
            selling: state.selling,
            bought: state.bought,
            sold: state.sold,
            tradingPostDelivery: state.tradingPostDelivery,
            itemId: item.id,
          ));
          await Future.delayed(Duration(milliseconds: 200), () {});
        },
        child: ListView(
          children: <Widget>[
            Center(
              child: Padding(
                padding: EdgeInsets.all(16.0),
                child: Text(
                  error,
                  style: TextStyle(
                    fontWeight: FontWeight.w500,
                    fontSize: 18.0
                  ),
                ),
              ),
            ),
          ],
        ),
      );
    }

    return RefreshIndicator(
      backgroundColor: Theme.of(context).accentColor,
      color: Colors.white,
      onRefresh: () async {
        BlocProvider.of<TradingPostBloc>(context).add(LoadTradingPostListingsEvent(
          buying: state.buying,
          selling: state.selling,
          bought: state.bought,
          sold: state.sold,
          tradingPostDelivery: state.tradingPostDelivery,
          itemId: item.id,
        ));
        await Future.delayed(Duration(milliseconds: 200), () {});
      },
      child: ListView(
        children: offers.map((o) => Container(
          color: o.unitPrice == orderValue ? Colors.red[100] : Colors.transparent,
          padding: EdgeInsets.symmetric(horizontal: 8.0),
          child: CompanionInfoRow(
            header: '${GuildWarsUtil.intToString(o.quantity)} $type',
            widget: CompanionCoin(o.unitPrice),
          ),
        ))
        .toList(),
      ),
    );
  }

  TradingPostTransaction _getTradingPostTransaction(LoadedTradingPostState state) {
    TradingPostTransaction transaction;

    [
      state.buying,
      state.selling,
      state.bought,
      state.sold
    ].forEach((transactionList) {
      if (transaction == null) {
        transaction = transactionList.firstWhere((t) => t.itemId == item.id, orElse: () => null);
      }
    });

    return transaction;
  }
}
