import 'listing_offer.dart';

class TradingPostPrice {
  int id;
  bool whitelisted;
  ListingOffer buys;
  ListingOffer sells;

  TradingPostPrice({this.id, this.whitelisted, this.buys, this.sells});

  TradingPostPrice.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    whitelisted = json['whitelisted'];
    buys = json['buys'] != null ? new ListingOffer.fromJson(json['buys']) : null;
    sells = json['sells'] != null ? new ListingOffer.fromJson(json['sells']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['whitelisted'] = this.whitelisted;
    if (this.buys != null) {
      data['buys'] = this.buys.toJson();
    }
    if (this.sells != null) {
      data['sells'] = this.sells.toJson();
    }
    return data;
  }
}