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
import 'package:guildwars2_companion/widgets/info_row.dart';

class TradingPostItemPage extends StatelessWidget {

  final Item item;

  TradingPostItemPage({
    this.item
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
                        errorWidget: (context, url, error) => Icon(Icons.error),
                        fit: BoxFit.contain,
                      ),
                    ),
                  ),
                ),
                Text(
                  item.name,
                  style: TextStyle(
                    color: Colors.white
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
                    if (state is LoadedTradingPostState && state.listingsLoaded) {
                      TradingPostTransaction tradingPostTransaction = _getTradingPostTransaction(state);

                      if (tradingPostTransaction == null) {
                        return Container();
                      }

                      return TabBarView(
                        children: <Widget>[
                          _buildListingTab(tradingPostTransaction.listing.buys, 'Ordered', 'No orders found'),
                          _buildListingTab(tradingPostTransaction.listing.sells, 'Available', 'No items found'),
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

  Widget _buildListingTab(List<ListingOffer> offers, String type, String error) {
    if (offers.isEmpty) {
      return Center(
        child: Text(
          error,
          style: TextStyle(
            fontWeight: FontWeight.w500,
            fontSize: 18.0
          ),
        ),
      );
    }

    return ListView(
      children: offers.map((o) => Padding(
        padding: EdgeInsets.symmetric(horizontal: 8.0),
        child: InfoRow(
          header: '${GuildWarsUtil.intToString(o.quantity)} $type',
          widget: CompanionCoin(o.unitPrice),
        ),
      ))
      .toList(),
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