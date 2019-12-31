import 'dart:convert';

import 'package:guildwars2_companion/models/bank/material.dart';
import 'package:guildwars2_companion/models/bank/material_category.dart';
import 'package:guildwars2_companion/models/items/inventory.dart';
import 'package:guildwars2_companion/utils/token.dart';
import 'package:guildwars2_companion/utils/urls.dart';
import 'package:http/http.dart' as http;

class BankRepository {
  Future<List<InventoryItem>> getInventory() async {
    final response = await http.get(
      Urls.inventoryUrl,
      headers: {
        'Authorization': 'Bearer ${await TokenUtil.getToken()}',
      }
    );

    if (response.statusCode == 200) {
      List items = json.decode(response.body);
      return items.where((a) => a != null).map((a) => InventoryItem.fromJson(a)).toList();
    } else {
      return [];
    }
  }

  Future<List<InventoryItem>> getBank() async {
    final response = await http.get(
      Urls.bankUrl,
      headers: {
        'Authorization': 'Bearer ${await TokenUtil.getToken()}',
      }
    );

    if (response.statusCode == 200) {
      List items = json.decode(response.body);
      return items.where((a) => a != null).map((a) => InventoryItem.fromJson(a)).toList();
    } else {
      return [];
    }
  }

  Future<List<Material>> getMaterials() async {
    final response = await http.get(
      Urls.materialUrl,
      headers: {
        'Authorization': 'Bearer ${await TokenUtil.getToken()}',
      }
    );

    if (response.statusCode == 200) {
      List items = json.decode(response.body);
      return items.where((a) => a != null).map((a) => Material.fromJson(a)).toList();
    } else {
      return [];
    }
  }

  Future<List<MaterialCategory>> getMaterialCategories() async {
    final response = await http.get(
      Urls.materialCategoryUrl,
      headers: {
        'Authorization': 'Bearer ${await TokenUtil.getToken()}',
      }
    );

    if (response.statusCode == 200) {
      List items = json.decode(response.body);
      return items.where((a) => a != null).map((a) => MaterialCategory.fromJson(a)).toList();
    } else {
      return [];
    }
  }
}