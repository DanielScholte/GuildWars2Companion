class Urls {
  static final String baseUrl = 'https://api.guildwars2.com/v2';

  static final String tokenInfoUrl = '$baseUrl/tokeninfo';
  static final String accountUrl = '$baseUrl/account';

  static final String currencyUrl = '$baseUrl/currencies?ids=all';
  static final String walletUrl = '$baseUrl/account/wallet';

  static final String charactersUrl = '$baseUrl/characters?ids=all';
  static final String titlesUrl = '$baseUrl/titles?ids=all';
}