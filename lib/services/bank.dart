import 'package:dio/dio.dart';
import '../models/bank/material.dart';
import '../models/bank/material_category.dart';
import '../models/items/inventory.dart';
import '../utils/dio.dart';
import '../utils/urls.dart';

class BankService {
  Dio _dio;

  BankService() {
    _dio = DioUtil.getDioInstance();
  }

  Future<List<InventoryItem>> getInventory() async {
    final response = await _dio.get(Urls.inventoryUrl);

    if (response.statusCode == 200) {
      List items = response.data;
      return items.where((a) => a != null).map((a) => InventoryItem.fromJson(a)).toList();
    }

    throw Exception();
  }

  Future<List<InventoryItem>> getBank() async {
    final response = await _dio.get(Urls.bankUrl);

    if (response.statusCode == 200) {
      List items = response.data;
      return items.where((a) => a != null).map((a) => InventoryItem.fromJson(a)).toList();
    }

    throw Exception();
  }

  Future<List<Material>> getMaterials() async {
    final response = await _dio.get(Urls.materialUrl);

    if (response.statusCode == 200) {
      List items = response.data;
      return items.where((a) => a != null).map((a) => Material.fromJson(a)).toList();
    }

    throw Exception();
  }

  Future<List<MaterialCategory>> getMaterialCategories() async {
    final response = await _dio.get(Urls.materialCategoryUrl);

    if (response.statusCode == 200) {
      List items = response.data;
      return items.where((a) => a != null).map((a) => MaterialCategory.fromJson(a)).toList();
    }

    throw Exception();
  }
}
