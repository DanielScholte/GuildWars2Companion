import 'package:flutter/widgets.dart';
import 'package:guildwars2_companion/features/bank/models/bank_data.dart';
import 'package:guildwars2_companion/features/bank/models/material.dart';
import 'package:guildwars2_companion/features/bank/models/material_category.dart';
import 'package:guildwars2_companion/features/bank/services/bank.dart';
import 'package:guildwars2_companion/features/item/models/inventory.dart';
import 'package:guildwars2_companion/features/item/models/item.dart';
import 'package:guildwars2_companion/features/item/models/skin.dart';
import 'package:guildwars2_companion/features/item/services/item.dart';

class BankRepository {

  final BankService bankService;
  final ItemService itemService;

  BankRepository({
    @required this.bankService,
    @required this.itemService
  });

  Future<BankData> getBankData() async {
    List networkResults = await Future.wait([
      bankService.getInventory(),
      bankService.getBank(),
      bankService.getMaterials(),
      bankService.getMaterialCategories()
    ]);

    List<InventoryItem> inventory = networkResults[0];
    List<InventoryItem> bank = networkResults[1];
    List<Material> materials = networkResults[2];
    List<MaterialCategory> materialCategories = networkResults[3];

    List<int> itemIds = [];
    List<int> skinIds = [];

    itemIds.addAll(materials.map((i) => i.id).toList());

    inventory.forEach((item) {
      itemIds.add(item.id);

      if (item.skin != null) {
        skinIds.add(item.skin);
      }

      if (item.infusions != null && item.infusions.isNotEmpty) {
        itemIds.addAll(item.infusions.where((inf) => inf != null).toList());
      }

      if (item.upgrades != null && item.upgrades.isNotEmpty) {
        itemIds.addAll(item.upgrades.where((up) => up != null).toList());
      }
    });

    bank.forEach((item) {
      itemIds.add(item.id);

      if (item.skin != null) {
        skinIds.add(item.skin);
      }

      if (item.infusions != null && item.infusions.isNotEmpty) {
        itemIds.addAll(item.infusions.where((inf) => inf != null).toList());
      }

      if (item.upgrades != null && item.upgrades.isNotEmpty) {
        itemIds.addAll(item.upgrades.where((up) => up != null).toList());
      }
    });

    itemIds = itemIds.toSet().toList();
    skinIds = skinIds.toSet().toList();      

    List<Item> items = await itemService.getItems(itemIds);
    List<Skin> skins = await itemService.getSkins(skinIds);

    inventory.forEach((item) {
      _fillInventoryItemInfo(item, items, skins);
    });

    bank.forEach((item) {
      _fillInventoryItemInfo(item, items, skins);
    });

    materials.forEach((item) {
      item.itemInfo = items.firstWhere((i) => i.id == item.id, orElse: () => null);
      MaterialCategory category = materialCategories.firstWhere((c) => c.id == item.category, orElse: () => null);
      if (category != null) {
        category.materials.add(item);
      }
    });
    materialCategories.sort((a, b) => a.order.compareTo(b.order));

    return BankData(
      bank: bank,
      inventory: inventory,
      materialCategories: materialCategories
    );
  }

  void _fillInventoryItemInfo(InventoryItem inventory, List<Item> items, List<Skin> skins) {
    inventory.itemInfo = items.firstWhere((i) => i.id == inventory.id, orElse: () => null);

    if (inventory.skin != null) {
      inventory.skinInfo = skins.firstWhere((i) => i.id == inventory.skin, orElse: () => null);
    }

    if (inventory.infusions != null && inventory.infusions.isNotEmpty) {
      inventory.infusionsInfo = [];
      inventory.infusions.where((inf) => inf != null).forEach((inf) {
        Item infusion = items.firstWhere((i) => i.id == inf, orElse: () => null);

        if (infusion != null) {
          inventory.infusionsInfo.add(infusion);
        }
      });
    }
    
    if (inventory.upgrades != null && inventory.upgrades.isNotEmpty) {
      inventory.upgradesInfo = [];
      inventory.upgrades.where((up) => up != null).forEach((up) {
        Item upgrade = items.firstWhere((i) => i.id == up, orElse: () => null);

        if (upgrade != null) {
          inventory.upgradesInfo.add(upgrade);
        }
      });
    }
  }
}