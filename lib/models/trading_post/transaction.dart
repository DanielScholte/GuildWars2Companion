import 'package:guildwars2_companion/models/items/item.dart';

import 'listing.dart';

class TradingPostTransaction {
  int id;
  int itemId;
  int price;
  int quantity;
  String created;
  String purchased;
  Item itemInfo;
  TradingPostListing listing;

  TradingPostTransaction(
      {this.id,
      this.itemId,
      this.price,
      this.quantity,
      this.created,
      this.purchased});

  TradingPostTransaction.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    itemId = json['item_id'];
    price = json['price'];
    quantity = json['quantity'];
    created = json['created'];
    purchased = json['purchased'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['item_id'] = this.itemId;
    data['price'] = this.price;
    data['quantity'] = this.quantity;
    data['created'] = this.created;
    data['purchased'] = this.purchased;
    return data;
  }
}