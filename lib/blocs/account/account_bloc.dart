import 'dart:async';
import 'dart:convert';
import 'package:bloc/bloc.dart';
import 'package:guildwars2_companion/models/account/account.dart';
import 'package:guildwars2_companion/models/account/token_info.dart';
import 'package:guildwars2_companion/utils/token.dart';
import 'package:guildwars2_companion/utils/urls.dart';
import './bloc.dart';
import 'package:http/http.dart' as http;

class AccountBloc extends Bloc<AccountEvent, AccountState> {
  @override
  AccountState get initialState => LoadingAccountState();

  AccountBloc() {
    add(SetupAccountEvent());
  }

  @override
  Stream<AccountState> mapEventToState(
    AccountEvent event,
  ) async* {
    if (event is AuthenticateEvent) {
      yield LoadingAccountState();
      yield* _authenticate(event.token);
    } else if (event is SetupAccountEvent) {
      yield LoadingAccountState();
      if (await TokenUtil.tokenPresent()) {
        yield* _authenticate(await TokenUtil.getToken());
        return;
      }
      yield await _getUnauthenticated(null);
    } else if (event is AddTokenEvent) {
      yield LoadingAccountState();
      yield* _addToken(event.token);
    } else if (event is RemoveTokenEvent) {
      yield LoadingAccountState();
      yield* _removeToken(event.token);
    }
  }

  Stream<AccountState> _authenticate(String token) async* {
    final response = await http.get(
      Urls.tokenInfoUrl,
      headers: {
        'Authorization': 'Bearer $token',
      }
    );

    if (response.statusCode == 200) {
      await TokenUtil.setToken(token);
      yield AuthenticatedState(
        await _getAccount(token),
        TokenInfo.fromJson(json.decode(response.body))
      );
    } else {
      yield await _getUnauthenticated("Invalid token");
    }
  }

  Stream<AccountState> _addToken(String token) async* {
    Account account = await _getAccount(token);
    if (account == null) {
      yield await _getUnauthenticated("Invalid token");
      return;
    }

    await TokenUtil.addToTokenList('$token;${account.name};${DateTime.now()}');
    yield await _getUnauthenticated("Token added");
  }

  Stream<AccountState> _removeToken(String token) async* {
    await TokenUtil.removeFromTokenList(token);
    yield await _getUnauthenticated("Token removed");
  }

  Future<Account> _getAccount(String token) async {
    final response = await http.get(
      Urls.accountUrl,
      headers: {
        'Authorization': 'Bearer $token',
      }
    );

    if (response.statusCode == 200) {
      return Account.fromJson(json.decode(response.body));
    }

    return null;
  }

  Future<UnauthenticatedState> _getUnauthenticated(String message) async {
    return UnauthenticatedState(
      await TokenUtil.getTokenList(),
      message
    );
  }
}
