import 'package:dio/dio.dart';
import 'package:guildwars2_companion/models/bank/material.dart';
import 'package:guildwars2_companion/models/bank/material_category.dart';
import 'package:guildwars2_companion/models/items/inventory.dart';
import 'package:guildwars2_companion/utils/dio.dart';
import 'package:guildwars2_companion/utils/urls.dart';

class BankRepository {
  Dio _dio;

  BankRepository() {
    _dio = DioUtil.getDioInstance();
  }

  Future<List<InventoryItem>> getInventory() async {
    final response = await _dio.get(Urls.inventoryUrl);

    if (response.statusCode == 200) {
      List items = response.data;
      return items.where((a) => a != null).map((a) => InventoryItem.fromJson(a)).toList();
    } else {
      return [];
    }
  }

  Future<List<InventoryItem>> getBank() async {
    final response = await _dio.get(Urls.bankUrl);

    if (response.statusCode == 200) {
      List items = response.data;
      return items.where((a) => a != null).map((a) => InventoryItem.fromJson(a)).toList();
    } else {
      return [];
    }
  }

  Future<List<Material>> getMaterials() async {
    final response = await _dio.get(Urls.materialUrl);

    if (response.statusCode == 200) {
      List items = response.data;
      return items.where((a) => a != null).map((a) => Material.fromJson(a)).toList();
    } else {
      return [];
    }
  }

  Future<List<MaterialCategory>> getMaterialCategories() async {
    final response = await _dio.get(Urls.materialCategoryUrl);

    if (response.statusCode == 200) {
      List items = response.data;
      return items.where((a) => a != null).map((a) => MaterialCategory.fromJson(a)).toList();
    } else {
      return [];
    }
  }
}