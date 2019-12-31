import 'dart:convert';

import 'package:guildwars2_companion/models/items/item.dart';
import 'package:guildwars2_companion/models/items/skin.dart';
import 'package:guildwars2_companion/utils/token.dart';
import 'package:guildwars2_companion/utils/urls.dart';

import 'package:http/http.dart' as http;

class ItemRepository {
  Future<List<Item>> getItems(List<String> itemIdsList) async {
    List<Item> items = [];
    for (var itemIds in itemIdsList) {
      final response = await http.get(
        Urls.itemsUrl + itemIds,
        headers: {
          'Authorization': 'Bearer ${await TokenUtil.getToken()}',
        }
      );

      if (response.statusCode == 200 || response.statusCode == 206) {
        List reponseItems = json.decode(response.body);
        items.addAll(reponseItems.map((a) => Item.fromJson(a)).toList());
      }
    }
    return items;
  }

  Future<List<Skin>> getSkins(List<String> skinIdsList) async {
    List<Skin> skins = [];
    for (var skinIds in skinIdsList) {
      final response = await http.get(
        Urls.skinsUrl + skinIds,
        headers: {
          'Authorization': 'Bearer ${await TokenUtil.getToken()}',
        }
      );

      if (response.statusCode == 200 || response.statusCode == 206) {
        List reponseSkins = json.decode(response.body);
        skins.addAll(reponseSkins.map((a) => Skin.fromJson(a)).toList());
      }
    }
    return skins;
  }
}