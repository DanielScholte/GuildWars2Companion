import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:flutter/widgets.dart';
import 'package:guildwars2_companion/models/character/character.dart';
import 'package:guildwars2_companion/models/character/profession.dart';
import 'package:guildwars2_companion/models/character/title.dart';
import 'package:guildwars2_companion/models/items/item.dart';
import 'package:guildwars2_companion/models/items/skin.dart';
import 'package:guildwars2_companion/repositories/character.dart';
import 'package:guildwars2_companion/repositories/item.dart';
import 'package:guildwars2_companion/utils/gw.dart';
import 'package:guildwars2_companion/utils/urls.dart';
import './bloc.dart';

class CharacterBloc extends Bloc<CharacterEvent, CharacterState> {
  @override
  CharacterState get initialState => LoadingCharactersState();

  final CharacterRepository characterRepository;
  final ItemRepository itemRepository;

  CharacterBloc({
    @required this.characterRepository,
    @required this.itemRepository
  });

  @override
  Stream<CharacterState> mapEventToState(
    CharacterEvent event,
  ) async* {
    if (event is LoadCharactersEvent) {
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
    } else if (event is LoadCharacterItemsEvent) {
      List<Character> characters = event.characters;

      yield LoadedCharactersState(characters, itemsLoading: true);

      List<String> itemIds = Urls.divideIdLists(_getItemIds(characters));
      List<String> skinIds = Urls.divideIdLists(_getSkinIds(characters));

      List<Item> items = await itemRepository.getItems(itemIds);
      List<Skin> skins = await itemRepository.getSkins(skinIds);
      
      characters.forEach((c) {
        if (c.bags != null) {
          c.bags.forEach((b) {
            b.itemInfo = items.firstWhere((i) => i.id == b.id, orElse: () => null);
            b.inventory.where((i) => i.id != -1).forEach((inventory) {
              inventory.itemInfo = items.firstWhere((i) => i.id == inventory.id, orElse: () => null);
              if (inventory.skin != null) {
                inventory.skinInfo = skins.firstWhere((i) => i.id == inventory.skin, orElse: () => null);
              }
            });
          });
        }
        if (c.equipment != null) {
          c.equipment.forEach((e) {
            e.itemInfo = items.firstWhere((i) => i.id == e.id, orElse: () => null);
            if (e.skin != null) {
              e.skinInfo = skins.firstWhere((i) => i.id == e.skin, orElse: () => null);
            }
          });
        }
      });

      yield LoadedCharactersState(characters, itemsLoaded: true);
    }
  }

  List<int> _getItemIds(List<Character> characters) {
    List<int> itemIds = [];
    characters.forEach((c) {
      if (c.bags != null) {
        c.bags.forEach((b) {
          itemIds.add(b.id);
          itemIds.addAll(b.inventory.where((i) => i.id != -1).map((i) => i.id).toList());
        });
      }
      if (c.equipment != null) {
        itemIds.addAll(c.equipment.map((e) => e.id).toList());
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
}
