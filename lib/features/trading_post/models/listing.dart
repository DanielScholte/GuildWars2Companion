import 'package:guildwars2_companion/features/trading_post/models/listing_offer.dart';

class TradingPostListing {
  int id;
  List<ListingOffer> buys;
  List<ListingOffer> sells;

  TradingPostListing({this.id, this.buys, this.sells});

  TradingPostListing.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    if (json['buys'] != null) {
      buys = (json['buys'] as List)
        .map((j) => ListingOffer.fromJson(j))
        .toList();
    }
    if (json['sells'] != null) {
      sells = (json['sells'] as List)
        .map((j) => ListingOffer.fromJson(j))
        .toList();
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    if (this.buys != null) {
      data['buys'] = this.buys.map((v) => v.toJson()).toList();
    }
    if (this.sells != null) {
      data['sells'] = this.sells.map((v) => v.toJson()).toList();
    }
    return data;
  }
}