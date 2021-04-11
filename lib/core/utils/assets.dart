import 'dart:convert' show json;

import 'package:flutter/services.dart' show rootBundle;

class Assets {
  static final String base = 'assets';
  static final String images = '$base/images';
  static final String data = '$base/data';

  static final String changelog = '$data/changelog.json';
  static final String dungeons = '$data/dungeons.json';
  static final String raids = '$data/raids.json';
  static final String worldBosses = '$data/world_bosses.json';

  static final String eventTimersMetaEvents = '$data/event_timers/meta_events.json';
  static final String eventTimersWorldBosses = '$data/event_timers/world_bosses.json';

  static final String appLogo = '$images/app/logo.png';

  static final String buttonHeaderDungeons = '$images/button_headers/dungeons.jpg';
  static final String buttonHeaderEventIcon = '$images/button_headers/event_icon.png';
  static final String buttonHeaderEvents = '$images/button_headers/events.jpg';
  static final String buttonHeaderFractalAchievements = '$images/button_headers/fractal_achievement.png';
  static final String buttonHeaderPveAchievements = '$images/button_headers/pve_achievement.png';
  static final String buttonHeaderPvpAchievements = '$images/button_headers/pvp_achievement.png';
  static final String buttonHeaderPvp = '$images/button_headers/pvp.jpg';
  static final String buttonHeaderRaids = '$images/button_headers/raids.jpg';
  static final String buttonHeaderWorldBosses = '$images/button_headers/world_bosses.jpg';
  static final String buttonHeaderWvwAchievements = '$images/button_headers/wvw_achievement.png';

  static final String coinCopper = '$images/coin/copper_coin.png';
  static final String coinGold = '$images/coin/gold_coin.png';
  static final String coinSilver = '$images/coin/silver_coin.png';

  static final String craftingArmorsmith = '$images/crafting/armorsmith.png';
  static final String craftingArtificer = '$images/crafting/artificer.png';
  static final String craftingChef = '$images/crafting/chef.png';
  static final String craftingHuntsman = '$images/crafting/huntsman.png';
  static final String craftingJeweler = '$images/crafting/jeweler.png';
  static final String craftingLeatherworker = '$images/crafting/leatherworker.png';
  static final String craftingScribe = '$images/crafting/scribe.png';
  static final String craftingTailor = '$images/crafting/tailor.png';
  static final String craftingWeaponsmith = '$images/crafting/weaponsmith.png';

  static final String dungeonsAscalonianCatacombs = '$images/dungeons/ascalonian_catacombs.jpg';
  static final String dungeonsCaudecusManor = '$images/dungeons/caudecus_manor.jpg';
  static final String dungeonsCitadelOfFlame = '$images/dungeons/citadel_of_flame.jpg';
  static final String dungeonsCrucibleOfEternity = '$images/dungeons/crucible_of_eternity.jpg';
  static final String dungeonsHonorOfTheWaves = '$images/dungeons/honor_of_the_waves.jpg';
  static final String dungeonsRuinedCityOfArah = '$images/dungeons/ruined_city_of_arah.jpg';
  static final String dungeonsSorrowsEmbrace = '$images/dungeons/sorrows_embrace.jpg';
  static final String dungeonsTwilightArbor = '$images/dungeons/twilight_arbor.jpg';

  static final String dungeonsSquareAscalonianCatacombs = '$images/dungeons_square/ascalonian_catacombs.jpg';
  static final String dungeonsSquareCaudecusManor = '$images/dungeons_square/caudecus_manor.jpg';
  static final String dungeonsSquareCitadelOfFlame = '$images/dungeons_square/citadel_of_flame.jpg';
  static final String dungeonsSquareCrucibleOfEternity = '$images/dungeons_square/crucible_of_eternity.jpg';
  static final String dungeonsSquareHonorOfTheWaves = '$images/dungeons_square/honor_of_the_waves.jpg';
  static final String dungeonsSquareRuinedCityOfArah = '$images/dungeons_square/ruined_city_of_arah.jpg';
  static final String dungeonsSquareSorrowsEmbrace = '$images/dungeons_square/sorrows_embrace.jpg';
  static final String dungeonsSquareTwilightArbor = '$images/dungeons_square/twilight_arbor.jpg';

  static final String professionsElementalist = '$images/professions/elementalist.png';
  static final String professionsEngineer = '$images/professions/engineer.png';
  static final String professionsGuardian = '$images/professions/guardian.png';
  static final String professionsMesmer = '$images/professions/mesmer.png';
  static final String professionsNecromancer = '$images/professions/necromancer.png';
  static final String professionsRanger = '$images/professions/ranger.png';
  static final String professionsRevenant = '$images/professions/revenant.png';
  static final String professionsThief = '$images/professions/thief.png';
  static final String professionsWarrior = '$images/professions/warrior.png';

  static final String progressionAp = '$images/progression/ap.png';
  static final String progressionChest = '$images/progression/chest.png';
  static final String progressionTitle = '$images/progression/title.png';
  static final String progressionMasteryDesert = '$images/progression/mastery_desert.png';
  static final String progressionMasteryMaguuma = '$images/progression/mastery_maguuma.png';
  static final String progressionMasteryTyria = '$images/progression/mastery_tyria.png';
  static final String progressionMasteryUnknown = '$images/progression/mastery_unknown.png';

  static final String raidsBastionOfThePenitent = '$images/raids/bastion_of_the_penitent.jpg';
  static final String raidsHallOfChains = '$images/raids/hall_of_chains.jpg';
  static final String raidsMythwrightGambit = '$images/raids/mythwright_gambit.jpg';
  static final String raidsSalvationPass = '$images/raids/salvation_pass.jpg';
  static final String raidsSpiritVale = '$images/raids/spirit_vale.jpg';
  static final String raidsStrongholdOfTheFaithful = '$images/raids/stronghold_of_the_faithful.jpg';
  static final String raidsTheKeyOfAhdashim = '$images/raids/the_key_of_ahdashim.jpg';

  static final String raidsSquareBastionOfThePenitent = '$images/raids_square/bastion_of_the_penitent.jpg';
  static final String raidsSquareHallOfChains = '$images/raids_square/hall_of_chains.jpg';
  static final String raidsSquareMythwrightGambit = '$images/raids_square/mythwright_gambit.jpg';
  static final String raidsSquareSalvationPass = '$images/raids_square/salvation_pass.jpg';
  static final String raidsSquareSpiritVale = '$images/raids_square/spirit_vale.jpg';
  static final String raidsSquareStrongholdOfTheFaithful = '$images/raids_square/stronghold_of_the_faithful.jpg';
  static final String raidsSquareTheKeyOfAhdashim = '$images/raids_square/the_key_of_ahdashim.jpg';

  static final String specializationPlaceholder = '$images/specialization/specialization_placeholder.png';

  static final String tokenFooter = '$images/token/token_footer.png';
  static final String tokenHeader = '$images/token/token_header.png';
  static final String tokenHeaderLogo = '$images/token/token_header_logo.png';

  static final String worldBossesAdmiralTaidhaCovington = '$images/world_bosses/admiral_taidha_covington.jpg';
  static final String worldBossesClawOfJormag = '$images/world_bosses/claw_of_jormag.jpg';
  static final String worldBossesFireElemental = '$images/world_bosses/fire_elemental.jpg';
  static final String worldBossesGreatJungleWurm = '$images/world_bosses/great_jungle_wurm.jpg';
  static final String worldBossesInquestGolemMarkII = '$images/world_bosses/inquest_golem_mark_ii.jpg';
  static final String worldBossesKarkaQueen = '$images/world_bosses/karka_queen.jpg';
  static final String worldBossesMegadestroyer = '$images/world_bosses/megadestroyer.jpg';
  static final String worldBossesModniirUlgoth = '$images/world_bosses/modniir_ulgoth.jpg';
  static final String worldBossesShadowBehemoth = '$images/world_bosses/shadow_behemoth.jpg';
  static final String worldBossesSvanirShamanChief = '$images/world_bosses/svanir_shaman_chief.jpg';
  static final String worldBossesTequatlTheSunless = '$images/world_bosses/tequatl_the_sunless.jpg';
  static final String worldBossesTheShatterer = '$images/world_bosses/the_shatterer.jpg';
  static final String worldBossesTripleTroubleWurm = '$images/world_bosses/triple_trouble_wurm.jpg';

  static Future<dynamic> loadDataAsset(String asset) async {
    return json.decode(await rootBundle.loadString(asset));
  }

  static String getCraftingDisciplineAsset(String disciplineId) {
    switch (disciplineId.toLowerCase()) {
      case 'armorsmith': return craftingArmorsmith;
      case 'artificer': return craftingArtificer;
      case 'chef': return craftingChef;
      case 'huntsman': return craftingHuntsman;
      case 'jeweler': return craftingJeweler;
      case 'leatherworker': return craftingLeatherworker;
      case 'scribe': return craftingScribe;
      case 'tailor': return craftingTailor;
      case 'weaponsmith': return craftingWeaponsmith;
      default: return craftingWeaponsmith;
    }
  }

  static String getDungeonAsset(String dungeonId, { bool square = true}) {
    switch (dungeonId.toLowerCase()) {
      case 'ascalonian_catacombs': return square ? dungeonsSquareAscalonianCatacombs : dungeonsAscalonianCatacombs;
      case 'caudecus_manor': return square ? dungeonsSquareCaudecusManor : dungeonsCaudecusManor;
      case 'citadel_of_flame': return square ? dungeonsSquareCitadelOfFlame : dungeonsCitadelOfFlame;
      case 'crucible_of_eternity': return square ? dungeonsSquareCrucibleOfEternity : dungeonsCrucibleOfEternity;
      case 'honor_of_the_waves': return square ? dungeonsSquareHonorOfTheWaves : dungeonsHonorOfTheWaves;
      case 'ruined_city_of_arah': return square ? dungeonsSquareRuinedCityOfArah : dungeonsRuinedCityOfArah;
      case 'sorrows_embrace': return square ? dungeonsSquareSorrowsEmbrace : dungeonsSorrowsEmbrace;
      case 'twilight_arbor': return square ? dungeonsSquareTwilightArbor : dungeonsTwilightArbor;
      default: return square ? dungeonsSquareAscalonianCatacombs : dungeonsAscalonianCatacombs;
    }
  }

  static String getProfessionAsset(String professionId) {
    switch (professionId.toLowerCase()) {
      case 'elementalist': return professionsElementalist;
      case 'engineer': return professionsEngineer;
      case 'guardian': return professionsGuardian;
      case 'mesmer': return professionsMesmer;
      case 'necromancer': return professionsNecromancer;
      case 'ranger': return professionsRanger;
      case 'revenant': return professionsRevenant;
      case 'thief': return professionsThief;
      case 'warrior': return professionsWarrior;
      default: return professionsWarrior;
    }
  }

  static String getMasteryAsset(String region) {
    switch (region.toLowerCase()) {
      case 'desert': return progressionMasteryDesert;
      case 'maguuma': return progressionMasteryMaguuma;
      case 'tyria': return progressionMasteryTyria;
      default: return progressionMasteryUnknown;
    }
  }

  static String getRaidAsset(String raidId, { bool square = true}) {
    switch (raidId.toLowerCase()) {
      case 'bastion_of_the_penitent': return square ? raidsSquareBastionOfThePenitent : raidsBastionOfThePenitent;
      case 'hall_of_chains': return square ? raidsSquareHallOfChains : raidsHallOfChains;
      case 'mythwright_gambit': return square ? raidsSquareMythwrightGambit : raidsMythwrightGambit;
      case 'salvation_pass': return square ? raidsSquareSalvationPass : raidsSalvationPass;
      case 'spirit_vale': return square ? raidsSquareSpiritVale : raidsSpiritVale;
      case 'stronghold_of_the_faithful': return square ? raidsSquareStrongholdOfTheFaithful : raidsStrongholdOfTheFaithful;
      case 'the_key_of_ahdashim': return square ? raidsSquareTheKeyOfAhdashim : raidsTheKeyOfAhdashim;
      default: return square ? raidsSquareBastionOfThePenitent : raidsBastionOfThePenitent;
    }
  }

  static String getWorldBossAsset(String worldBossId) {
    switch (worldBossId.toLowerCase()) {
      case 'admiral_taidha_covington': return worldBossesAdmiralTaidhaCovington;
      case 'claw_of_jormag': return worldBossesClawOfJormag;
      case 'fire_elemental': return worldBossesFireElemental;
      case 'great_jungle_wurm': return worldBossesGreatJungleWurm;
      case 'inquest_golem_mark_ii': return worldBossesInquestGolemMarkII;
      case 'karka_queen': return worldBossesKarkaQueen;
      case 'megadestroyer': return worldBossesMegadestroyer;
      case 'modniir_ulgoth': return worldBossesModniirUlgoth;
      case 'shadow_behemoth': return worldBossesShadowBehemoth;
      case 'svanir_shaman_chief': return worldBossesSvanirShamanChief;
      case 'tequatl_the_sunless': return worldBossesTequatlTheSunless;
      case 'the_shatterer': return worldBossesTheShatterer;
      case 'triple_trouble_wurm': return worldBossesTripleTroubleWurm;
      default: return worldBossesShadowBehemoth;
    }
  }
}