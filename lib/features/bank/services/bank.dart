import 'package:dio/dio.dart';
import 'package:guildwars2_companion/core/utils/urls.dart';
import 'package:guildwars2_companion/features/bank/models/material.dart';
import 'package:guildwars2_companion/features/bank/models/material_category.dart';
import 'package:guildwars2_companion/features/item/models/inventory.dart';
import 'package:meta/meta.dart';

class BankService {
  Dio dio;

  BankService({
    @required this.dio,
  });

  Future<List<InventoryItem>> getInventory() async {
    final response = await dio.get(Urls.inventoryUrl);

    if (response.statusCode == 200) {
      List items = response.data;
      return items.where((a) => a != null).map((a) => InventoryItem.fromJson(a)).toList();
    }

    throw Exception();
  }

  Future<List<InventoryItem>> getBank() async {
    final response = await dio.get(Urls.bankUrl);

    if (response.statusCode == 200) {
      List items = response.data;
      return items.map((a) => InventoryItem.fromJson(a)).toList();
    }

    throw Exception();
  }

  Future<List<Material>> getMaterials() async {
    final response = await dio.get(Urls.materialUrl);

    if (response.statusCode == 200) {
      List items = response.data;
      return items.where((a) => a != null).map((a) => Material.fromJson(a)).toList();
    }

    throw Exception();
  }

  Future<List<MaterialCategory>> getMaterialCategories() async {
    final response = await dio.get(Urls.materialCategoryUrl);

    if (response.statusCode == 200) {
      List items = response.data;
      return items.where((a) => a != null).map((a) => MaterialCategory.fromJson(a)).toList();
    }

    throw Exception();
  }
}
