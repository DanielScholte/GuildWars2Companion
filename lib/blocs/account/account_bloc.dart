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
    TokenUtil.tokenPresent().then((present) {
      if (present) {
        add(AuthenticateEvent(null));
      } else {
        add(SetAccountState(UnauthenticatedState()));
      }
    }).catchError((_) => add(SetAccountState(UnauthenticatedState())));
  }

  @override
  Stream<AccountState> mapEventToState(
    AccountEvent event,
  ) async* {
    if (event is AuthenticateEvent) {
      yield LoadingAccountState();
      yield* _authenticate(event.token == null ? await TokenUtil.getToken() : event.token);
    } else if (event is SetAccountState) {
      yield event.state;
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
      yield UnauthenticatedState();
    }
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


}
