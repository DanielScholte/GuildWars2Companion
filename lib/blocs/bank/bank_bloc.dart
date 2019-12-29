import 'dart:async';
import 'dart:convert';
import 'package:bloc/bloc.dart';
import 'package:guildwars2_companion/models/bank/material.dart';
import 'package:guildwars2_companion/models/bank/material_category.dart';
import 'package:guildwars2_companion/models/items/inventory.dart';
import 'package:guildwars2_companion/models/items/item.dart';
import 'package:guildwars2_companion/utils/token.dart';
import 'package:guildwars2_companion/utils/urls.dart';
import './bloc.dart';
import 'package:http/http.dart' as http;

class BankBloc extends Bloc<BankEvent, BankState> {
  @override
  BankState get initialState => LoadingBankState();

  @override
  Stream<BankState> mapEventToState(
    BankEvent event,
  ) async* {
    if (event is LoadBankEvent) {
      yield LoadingBankState();

      List<InventoryItem> inventory = await _getInventory();
      List<InventoryItem> bank = await _getBank();
      List<Material> materials = await _getMaterials();
      List<MaterialCategory> materialCategories = await _getMaterialCategories();

      List<int> itemIds = inventory.map((i) => i.id).toList();
      itemIds.addAll(bank.map((i) => i.id).toList());
      itemIds.addAll(materials.map((i) => i.id).toList());
      itemIds = itemIds.toSet().toList();

      List<Item> items = await _getItems(Urls.divideIdLists(itemIds));

      inventory.forEach((item) => item.itemInfo = items.firstWhere((i) => i.id == item.id, orElse: () => null));
      bank.forEach((item) => item.itemInfo = items.firstWhere((i) => i.id == item.id, orElse: () => null));
      materials.forEach((item) {
        item.itemInfo = items.firstWhere((i) => i.id == item.id, orElse: () => null);
        MaterialCategory category = materialCategories.firstWhere((c) => c.id == item.category, orElse: () => null);
        if (category != null) {
          category.materials.add(item);
        }
      });
      materialCategories.sort((a, b) => a.order.compareTo(b.order));

      yield LoadedBankState(bank, inventory, materialCategories);
    }
  }

  Future<List<InventoryItem>> _getInventory() async {
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

  Future<List<InventoryItem>> _getBank() async {
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

  Future<List<Material>> _getMaterials() async {
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

  Future<List<MaterialCategory>> _getMaterialCategories() async {
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

  Future<List<Item>> _getItems(List<String> itemIdsList) async {
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
}
