import 'package:flutter/widgets.dart';
import 'package:guildwars2_companion/models/bank/bank_data.dart';
import 'package:guildwars2_companion/models/bank/material.dart';
import 'package:guildwars2_companion/models/bank/material_category.dart';
import 'package:guildwars2_companion/models/items/inventory.dart';
import 'package:guildwars2_companion/models/items/item.dart';
import 'package:guildwars2_companion/models/items/skin.dart';
import 'package:guildwars2_companion/services/bank.dart';
import 'package:guildwars2_companion/services/item.dart';

class BankRepository {

  final BankService bankService;
  final ItemService itemService;

  BankRepository({
    @required this.bankService,
    @required this.itemService
  });

  Future<BankData> getBankData() async {
    List<InventoryItem> inventory = await bankService.getInventory();
    List<InventoryItem> bank = await bankService.getBank();
    List<Material> materials = await bankService.getMaterials();
    List<MaterialCategory> materialCategories = await bankService.getMaterialCategories();

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