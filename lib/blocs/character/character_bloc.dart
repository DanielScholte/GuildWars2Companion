import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:flutter/widgets.dart';
import 'package:guildwars2_companion/models/character/character.dart';
import 'package:guildwars2_companion/models/character/equipment.dart';
import 'package:guildwars2_companion/models/character/profession.dart';
import 'package:guildwars2_companion/models/character/title.dart';
import 'package:guildwars2_companion/models/items/inventory.dart';
import 'package:guildwars2_companion/models/items/item.dart';
import 'package:guildwars2_companion/models/items/skin.dart';
import 'package:guildwars2_companion/services/character.dart';
import 'package:guildwars2_companion/services/item.dart';
import 'package:guildwars2_companion/utils/guild_wars.dart';
import './bloc.dart';

class CharacterBloc extends Bloc<CharacterEvent, CharacterState> {
  @override
  CharacterState get initialState => LoadingCharactersState();

  final CharacterService characterRepository;
  final ItemService itemRepository;

  CharacterBloc({
    @required this.characterRepository,
    @required this.itemRepository
  });

  @override
  Stream<CharacterState> mapEventToState(
    CharacterEvent event,
  ) async* {
    if (event is LoadCharactersEvent) {
      yield* _loadCharacters();
    } else if (event is LoadCharacterItemsEvent) {
      yield* _loadCharacterItems(event.characters);
    } else if (event is RefreshCharacterItemsEvent) {
      yield* _refreshCharacterItems();
    }
  }
  
  Stream<CharacterState> _loadCharacters() async* {
    try {
      yield LoadingCharactersState();

      List<Character> characters = await characterRepository.getCharacters();
      List<AccountTitle> titles = await characterRepository.getTitles();
      List<Profession> professions = await characterRepository.getProfessions();

      characters.forEach((c) {
        c.titleName = titles.firstWhere((t) => t.id == c.title, orElse: () => AccountTitle(name: '')).name;
        c.professionInfo = professions.firstWhere((p) => p.id == c.profession, orElse: () => null);
        c.professionColor = GuildWarsUtil.getProfessionColor(c.profession);
      });

      yield LoadedCharactersState(characters);
    } catch (_) {
      yield ErrorCharactersState();
    }
  }

  Stream<CharacterState> _loadCharacterItems(List<Character> characters) async* {
    try {
      yield LoadedCharactersState(characters, itemsLoading: true);

      yield LoadedCharactersState(await _fillCharacterItems(characters), itemsLoaded: true);
    } catch(_) {
      yield LoadedCharactersState(characters, hasError: true);
    }
  }

  Future<List<Character>> _fillCharacterItems(List<Character> characterList) async {
    List<Character> characters = characterList;
    
    List<int> itemIds = _getItemIds(characters);
    List<int> skinIds = _getSkinIds(characters);

    List<Item> items = await itemRepository.getItems(itemIds);
    List<Skin> skins = await itemRepository.getSkins(skinIds);
    
    characters.forEach((c) {
      if (c.bags != null) {
        c.bags.forEach((b) {
          b.itemInfo = items.firstWhere((i) => i.id == b.id, orElse: () => null);
          b.inventory.where((i) => i.id != -1).forEach((inventory) {
            _fillInventoryItemInfo(inventory, items, skins);
          });
        });
      }
      if (c.equipment != null) {
        c.equipment.forEach((e) {
          _fillEquipmentInfo(e, items, skins);
        });
      }
    });

    return characters;
  }

  Stream<CharacterState> _refreshCharacterItems() async* {
    try {
      yield LoadingCharactersState();

      List<Character> characters = await characterRepository.getCharacters();
      List<AccountTitle> titles = await characterRepository.getTitles();
      List<Profession> professions = await characterRepository.getProfessions();

      characters.forEach((c) {
        c.titleName = titles.firstWhere((t) => t.id == c.title, orElse: () => AccountTitle(name: '')).name;
        c.professionInfo = professions.firstWhere((p) => p.id == c.profession, orElse: () => null);
        c.professionColor = GuildWarsUtil.getProfessionColor(c.profession);
      });

      yield LoadedCharactersState(await _fillCharacterItems(characters), itemsLoaded: true);
    } catch (_) {
      yield ErrorCharactersState();
    }
  }

  List<int> _getItemIds(List<Character> characters) {
    List<int> itemIds = [];
    characters.forEach((c) {
      if (c.bags != null) {
        c.bags.forEach((b) {
          itemIds.add(b.id);
          b.inventory.where((i) => i.id != -1).forEach((item) {
            itemIds.add(item.id);

            if (item.infusions != null && item.infusions.isNotEmpty) {
              itemIds.addAll(item.infusions.where((inf) => inf != null).toList());
            }

            if (item.upgrades != null && item.upgrades.isNotEmpty) {
              itemIds.addAll(item.upgrades.where((up) => up != null).toList());
            }
          });
        });
      }
      if (c.equipment != null) {
        itemIds.addAll(c.equipment.map((e) => e.id).toList());
        c.equipment.where((e) => e.infusions != null && e.infusions.isNotEmpty)
          .forEach((e) => itemIds.addAll(e.infusions.where((inf) => inf != null).toList()));
        c.equipment.where((e) => e.upgrades != null && e.upgrades.isNotEmpty)
          .forEach((e) => itemIds.addAll(e.upgrades.where((up) => up != null).toList()));
      }
    });
    return itemIds.toSet().toList();
  }

  List<int> _getSkinIds(List<Character> characters) {
    List<int> skinIds = [];
    characters.forEach((c) {
      if (c.bags != null) {
        c.bags.forEach((b) {
          skinIds.addAll(b.inventory.where((i) => i.id != -1 && i.skin != null).map((i) => i.skin).toList());
        });
      }
      if (c.equipment != null) {
        skinIds.addAll(c.equipment.where((e) => e.skin != null).map((e) => e.skin).toList());
      }
    });
    return skinIds.toSet().toList();
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

  void _fillEquipmentInfo(Equipment equipment, List<Item> items, List<Skin> skins) {
    equipment.itemInfo = items.firstWhere((i) => i.id == equipment.id, orElse: () => null);

    if (equipment.skin != null) {
      equipment.skinInfo = skins.firstWhere((i) => i.id == equipment.skin, orElse: () => null);
    }

    if (equipment.infusions != null && equipment.infusions.isNotEmpty) {
      equipment.infusionsInfo = [];
      equipment.infusions.where((inf) => inf != null).forEach((inf) {
        Item infusion = items.firstWhere((i) => i.id == inf, orElse: () => null);

        if (infusion != null) {
          equipment.infusionsInfo.add(infusion);
        }
      });
    }
    
    if (equipment.upgrades != null && equipment.upgrades.isNotEmpty) {
      equipment.upgradesInfo = [];
      equipment.upgrades.where((up) => up != null).forEach((up) {
        Item upgrade = items.firstWhere((i) => i.id == up, orElse: () => null);

        if (upgrade != null) {
          equipment.upgradesInfo.add(upgrade);
        }
      });
    }
  }
}
