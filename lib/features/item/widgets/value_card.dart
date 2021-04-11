import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:guildwars2_companion/core/widgets/coin.dart';
import 'package:guildwars2_companion/core/widgets/info_card.dart';
import 'package:guildwars2_companion/core/widgets/info_row.dart';
import 'package:guildwars2_companion/features/item/models/item.dart';
import 'package:guildwars2_companion/features/trading_post/models/price.dart';
import 'package:guildwars2_companion/features/trading_post/repositories/trading_post.dart';

class ItemValueCard extends StatelessWidget {
  final Item item;

  ItemValueCard({@required this.item});

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<TradingPostPrice>(
      future: RepositoryProvider.of<TradingPostRepository>(context).getItemPrice(item.id),
      builder: (context, snapshot) {
        return CompanionInfoCard(
          title: 'Value',
          child: Column(
            children: [
              CompanionInfoRow(
                header: 'Vendor',
                widget: CompanionCoin(item.vendorValue)
              ),
              CompanionInfoRow(
                header: 'Trading Post Buy',
                text: snapshot.hasError ? '-' : null,
                widget: snapshot.hasError ? null : snapshot.hasData ? CompanionCoin(snapshot.data.buys.unitPrice) : _LoadingValue()
              ),
              CompanionInfoRow(
                header: 'Trading Post Sell',
                text: snapshot.hasError ? '-' : null,
                widget: snapshot.hasError ? null : snapshot.hasData ? CompanionCoin(snapshot.data.sells.unitPrice) : _LoadingValue()
              ),
            ],
          ),
        );
      }
    );
  }
}

class _LoadingValue extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: 16.0,
      height: 16.0,
      child: CircularProgressIndicator(
        strokeWidth: 2.0,
      ),
    );
  }
}