import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:flutter/widgets.dart';
import 'package:guildwars2_companion/models/bank/material.dart';
import 'package:guildwars2_companion/models/bank/material_category.dart';
import 'package:guildwars2_companion/models/items/inventory.dart';
import 'package:guildwars2_companion/models/items/item.dart';
import 'package:guildwars2_companion/repositories/bank.dart';
import 'package:guildwars2_companion/repositories/item.dart';
import 'package:guildwars2_companion/utils/urls.dart';
import './bloc.dart';

class BankBloc extends Bloc<BankEvent, BankState> {
  @override
  BankState get initialState => LoadingBankState();

  final BankRepository bankRepository;
  final ItemRepository itemRepository;

  BankBloc({
    @required this.bankRepository,
    @required this.itemRepository
  });

  @override
  Stream<BankState> mapEventToState(
    BankEvent event,
  ) async* {
    if (event is LoadBankEvent) {
      yield LoadingBankState();

      List<InventoryItem> inventory = await bankRepository.getInventory();
      List<InventoryItem> bank = await bankRepository.getBank();
      List<Material> materials = await bankRepository.getMaterials();
      List<MaterialCategory> materialCategories = await bankRepository.getMaterialCategories();

      List<int> itemIds = inventory.map((i) => i.id).toList();
      itemIds.addAll(bank.map((i) => i.id).toList());
      itemIds.addAll(materials.map((i) => i.id).toList());
      itemIds = itemIds.toSet().toList();

      List<Item> items = await itemRepository.getItems(Urls.divideIdLists(itemIds));

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
}
