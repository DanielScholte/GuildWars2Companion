import 'package:guildwars2_companion/models/trading_post/listing_offer.dart';

class TradingPostListing {
  int id;
  List<ListingOffer> buys;
  List<ListingOffer> sells;

  TradingPostListing({this.id, this.buys, this.sells});

  TradingPostListing.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    if (json['buys'] != null) {
      buys = new List<ListingOffer>();
      json['buys'].forEach((v) {
        buys.add(new ListingOffer.fromJson(v));
      });
    }
    if (json['sells'] != null) {
      sells = new List<ListingOffer>();
      json['sells'].forEach((v) {
        sells.add(new ListingOffer.fromJson(v));
      });
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