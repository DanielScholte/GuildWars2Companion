import 'package:guildwars2_companion/models/bank/material_category.dart';
import 'package:guildwars2_companion/models/items/inventory.dart';

class BankData {
  final List<InventoryItem> bank;
  final List<InventoryItem> inventory;
  final List<MaterialCategory> materialCategories;

  BankData({this.bank, this.inventory, this.materialCategories});
}