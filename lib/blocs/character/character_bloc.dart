import 'dart:async';
import 'dart:convert';
import 'package:bloc/bloc.dart';
import 'package:guildwars2_companion/models/character/character.dart';
import 'package:guildwars2_companion/models/character/profession.dart';
import 'package:guildwars2_companion/models/character/title.dart';
import 'package:guildwars2_companion/models/items/item.dart';
import 'package:guildwars2_companion/models/items/skin.dart';
import 'package:guildwars2_companion/utils/gw.dart';
import 'package:guildwars2_companion/utils/token.dart';
import 'package:guildwars2_companion/utils/urls.dart';
import './bloc.dart';
import 'package:http/http.dart' as http;

class CharacterBloc extends Bloc<CharacterEvent, CharacterState> {
  @override
  CharacterState get initialState => LoadingCharactersState();

  @override
  Stream<CharacterState> mapEventToState(
    CharacterEvent event,
  ) async* {
    if (event is LoadCharactersEvent) {
      yield LoadingCharactersState();

      List<Character> characters = await _getCharacters();
      List<Title> titles = await _getTitles();
      List<Profession> professions = await _getProfessions();

      characters.forEach((c) {
        c.titleName = titles.firstWhere((t) => t.id == c.title, orElse: () => Title(name: '')).name;
        c.professionInfo = professions.firstWhere((p) => p.id == c.profession, orElse: () => null);
        c.professionColor = GuildWarsUtil.getProfessionColor(c.profession);
      });

      yield LoadedCharactersState(characters);
    } else if (event is LoadCharacterItemsEvent) {
      List<Character> characters = event.characters;

      yield LoadedCharactersState(characters, itemsLoading: true);

      List<String> itemIds = Urls.divideIdLists(_getItemIds(characters));
      List<String> skinIds = Urls.divideIdLists(_getSkinIds(characters));

      List<Item> items = await _getItems(itemIds);
      List<Skin> skins = await _getSkins(skinIds);
      
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

  Future<List<Character>> _getCharacters() async {
    final response = await http.get(
      Urls.charactersUrl,
      headers: {
        'Authorization': 'Bearer ${await TokenUtil.getToken()}',
      }
    );

    if (response.statusCode == 200) {
      List characters = json.decode(response.body);
      return characters.map((a) => Character.fromJson(a)).toList();
    } else {
      return [];
    }
  }

  Future<List<Title>> _getTitles() async {
    final response = await http.get(
      Urls.titlesUrl,
      headers: {
        'Authorization': 'Bearer ${await TokenUtil.getToken()}',
      }
    );

    if (response.statusCode == 200) {
      List titles = json.decode(response.body);
      return titles.map((a) => Title.fromJson(a)).toList();
    } else {
      return [];
    }
  }

  Future<List<Profession>> _getProfessions() async {
    final response = await http.get(
      Urls.professionsUrl,
      headers: {
        'Authorization': 'Bearer ${await TokenUtil.getToken()}',
      }
    );

    if (response.statusCode == 200) {
      List professions = json.decode(response.body);
      return professions.map((a) => Profession.fromJson(a)).toList();
    } else {
      return [];
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

  Future<List<Item>> _getItems(List<String> itemIdsList) async {
    List<Item> items = [];
    for (var itemIds in itemIdsList) {
      final response = await http.get(
        Urls.itemsUrl + itemIds,
        headers: {
          'Authorization': 'Bearer ${await TokenUtil.getToken()}',
        }
      );

      if (response.statusCode == 200 || response.statusCode == 206) {
        List reponseItems = json.decode(response.body);
        items.addAll(reponseItems.map((a) => Item.fromJson(a)).toList());
      }
    }
    return items;
  }

  Future<List<Skin>> _getSkins(List<String> skinIdsList) async {
    List<Skin> skins = [];
    for (var skinIds in skinIdsList) {
      final response = await http.get(
        Urls.skinsUrl + skinIds,
        headers: {
          'Authorization': 'Bearer ${await TokenUtil.getToken()}',
        }
      );

      if (response.statusCode == 200 || response.statusCode == 206) {
        List reponseSkins = json.decode(response.body);
        skins.addAll(reponseSkins.map((a) => Skin.fromJson(a)).toList());
      }
    }
    return skins;
  }
}
