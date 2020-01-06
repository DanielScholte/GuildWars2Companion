class Urls {
  static final String baseUrl = 'https://api.guildwars2.com/v2';

  static final String tokenInfoUrl = '$baseUrl/tokeninfo';
  static final String accountUrl = '$baseUrl/account';

  static final String currencyUrl = '$baseUrl/currencies?ids=all';
  static final String walletUrl = '$baseUrl/account/wallet';

  static final String completedWorldBossesUrl = '$baseUrl/account/worldbosses';

  static final String charactersUrl = '$baseUrl/characters?ids=all';
  static final String titlesUrl = '$baseUrl/titles?ids=all';
  static final String professionsUrl = '$baseUrl/professions?ids=all';

  static final String itemsUrl = '$baseUrl/items?ids=';
  static final String skinsUrl = '$baseUrl/skins?ids=';

  static final String inventoryUrl = '$baseUrl/account/inventory';
  static final String bankUrl = '$baseUrl/account/bank';
  static final String materialUrl = '$baseUrl/account/materials';
  static final String materialCategoryUrl = '$baseUrl/materials?ids=all';

  static final String tradingPostPriceUrl = '$baseUrl/commerce/prices/';
  static final String tradingPostDeliveryUrl = '$baseUrl/commerce/delivery';
  static final String tradingPostTransactionsUrl = '$baseUrl/commerce/transactions/';
  static final String tradingPostListingsUrl = '$baseUrl/commerce/listings/';

  static List<String> divideIdLists(List<int> ids) {
    List<List<int>> output = [[]];
    ids.forEach((id) {
      output.firstWhere((l) => l.length < 150, orElse: () {
        List<int> newList = [];
        output.add(newList);
        return newList;
      }).add(id);
    });
    return output.map((l) => l.join(',')).toList();
  }
}