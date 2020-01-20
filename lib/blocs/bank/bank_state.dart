import 'package:guildwars2_companion/models/bank/material_category.dart';
import 'package:guildwars2_companion/models/items/inventory.dart';
import 'package:meta/meta.dart';

@immutable
abstract class BankState {}
  
class LoadingBankState extends BankState {}

class LoadedBankState extends BankState {
  final List<InventoryItem> bank;
  final List<InventoryItem> inventory;
  final List<MaterialCategory> materialCategories;

  LoadedBankState(this.bank, this.inventory, this.materialCategories);
}

class ErrorBankState extends BankState {}