import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class GuildWarsUtil {

  static int calculatePlayTime(int playTime) {
    return (playTime / 60 / 60).round();
  }

  static String masteryIcon(String region) {
    switch (region) {
      case 'Desert':
        return 'assets/progression/mastery_desert.png';
      case 'Maguuma':
        return 'assets/progression/mastery_maguuma.png';
      case 'Tyria':
        return 'assets/progression/mastery_tyria.png';
      default:
        return 'assets/progression/mastery_unknown.png';
    }
  }

  static String regionIcon(String region) {
    switch (region) {
      case 'Desert':
        return 'assets/expansions/desert.png';
      case 'Maguuma':
        return 'assets/expansions/maguuma.png';
      case 'Tyria':
        return 'assets/expansions/tyria.png';
      default:
        return 'assets/expansions/unknown.png';
    }
  }

  static Color regionColor(String region) {
    switch (region) {
      case 'Desert':
        return Color(0xFF80066E);
      case 'Maguuma':
        return Colors.green[600];
      case 'Tyria':
        return Colors.red[600];
      default:
        return Colors.blueAccent;
    }
  }

  static Color getProfessionColor(String professionId) {
    switch (professionId) {
      case 'Guardian':
        return Color(0xFF1d95b3);
      case 'Revenant':
        return Color(0xFFb64444);
      case 'Warrior':
        return Color(0xFFcea64b);
      case 'Engineer':
        return Color(0xFFc87137);
      case 'Ranger':
        return Color(0xFF6b932e);
      case 'Thief':
        return Color(0xFF7b5559);
      case 'Elementalist':
        return Color(0xFFb33d3d);
      case 'Mesmer':
        return Color(0xFF86308e);
      case 'Necromancer':
        return Color(0xFF1f6557);
      default:
        return Colors.red;
    }
  }

  static Color getRarityColor(String rarity) {
    switch (rarity) {
      case 'Junk':
        return Color(0xFFAAAAAA);
      case 'Basic':
        return Colors.grey;
      case 'Fine':
        return Color(0xFF62A4DA);
      case 'Masterwork':
        return Color(0xFF1a9306);
      case 'Rare':
        return Color(0xFFfcd00b);
      case 'Exotic':
        return Color(0xFFffa405);
      case 'Ascended':
        return Color(0xFFfb3e8d);
      case 'Legendary':
        return Color(0xFF4C139D);
      default:
        return Colors.grey;
    }
  }

  static List<String> validDisciplines() {
    return [
      'Armorsmith',
      'Artificer',
      'Chef',
      'Huntsman',
      'Jeweler',
      'Leatherworker',
      'Scribe',
      'Tailor',
      'Weaponsmith'
    ];
  }

  static String durationToString(Duration duration) {
    String twoDigits(int n) {
      if (n >= 10) return "$n";
      return "0$n";
    }

    String twoDigitMinutes = twoDigits(duration.inMinutes.remainder(60));
    String twoDigitSeconds = twoDigits(duration.inSeconds.remainder(60));

    if (duration.inHours == 0) {
      return "$twoDigitMinutes:$twoDigitSeconds";
    }

    return "${twoDigits(duration.inHours)}:$twoDigitMinutes:$twoDigitSeconds";
  }

  static String durationToTextString(Duration duration) {
    String output = '';

    if (duration.inHours > 0) {
      output += "${duration.inHours} hour${duration.inHours > 1 ? 's' : ''}";
    }

    if (duration.inMinutes.remainder(60) > 0) {
      if (output.isNotEmpty) {
        output += ' ';
      }

      output += "${duration.inMinutes.remainder(60)} minute${duration.inMinutes > 1 ? 's' : ''}";
    }

    if (duration.inSeconds.remainder(60) > 0) {
      if (output.isNotEmpty) {
        output += ' ';
      }

      output += "${duration.inSeconds.remainder(60)} second${duration.inSeconds > 1 ? 's' : ''}";
    }

    return output;
  }

  static String intToString(int value) {
    return NumberFormat('###,###', 'en').format(value);
  }
}