import 'package:guildwars2_companion/features/item/models/item.dart';

class TradingPostDelivery {
  int coins;
  List<DeliveryItem> items;

  TradingPostDelivery({this.coins, this.items});

  TradingPostDelivery.fromJson(Map<String, dynamic> json) {
    coins = json['coins'];
    if (json['items'] != null) {
      items = new List<DeliveryItem>();
      json['items'].forEach((v) {
        items.add(new DeliveryItem.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['coins'] = this.coins;
    if (this.items != null) {
      data['items'] = this.items.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class DeliveryItem {
  int id;
  Item itemInfo;
  int count;

  DeliveryItem({this.id, this.count});

  DeliveryItem.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    count = json['count'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['count'] = this.count;
    return data;
  }
}