import 'package:guildwars2_companion/features/bank/models/material_category.dart';
import 'package:guildwars2_companion/features/item/models/inventory.dart';

class BankData {
  final List<InventoryItem> bank;
  final List<InventoryItem> inventory;
  final List<MaterialCategory> materialCategories;

  BankData({this.bank, this.inventory, this.materialCategories});
}