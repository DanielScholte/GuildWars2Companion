import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:flutter/widgets.dart';
import 'package:guildwars2_companion/models/account/account.dart';
import 'package:guildwars2_companion/models/account/token_entry.dart';
import 'package:guildwars2_companion/models/account/token_info.dart';
import 'package:guildwars2_companion/repositories/account.dart';
import './bloc.dart';


class AccountBloc extends Bloc<AccountEvent, AccountState> {
  @override
  AccountState get initialState => LoadingAccountState();

  final AccountRepository accountRepository;

  AccountBloc({
    @required this.accountRepository
  }) {
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
      if (await accountRepository.tokenPresent()) {
        yield* _authenticate(await accountRepository.getCurrentToken());
        return;
      }
      yield await _getUnauthenticated(null);
    } else if (event is AddTokenEvent) {
      yield LoadingAccountState();
      yield* _addToken(event.token);
    } else if (event is RemoveTokenEvent) {
      yield LoadingAccountState();
      yield* _removeToken(event.tokenId);
    } else if (event is UnauthenticateEvent) {
      await accountRepository.removeCurrentToken();
      yield await _getUnauthenticated(null);
    }
  }

  Stream<AccountState> _authenticate(String token) async* {
    try {
      TokenInfo tokenInfo = await accountRepository.getTokenInfo(token);

      yield AuthenticatedState(
        await accountRepository.getAccount(token),
        tokenInfo
      );
    } catch (_) {
      yield await _getUnauthenticated("Invalid Api Key");
    }
  }

  Stream<AccountState> _addToken(String token) async* {
    try {
      Account account = await accountRepository.getAccount(token);

      await accountRepository.addToken(TokenEntry(
        name: account.name,
        date: DateTime.now().toIso8601String(),
        token: token,
      ));
      yield await _getUnauthenticated("Api Key added", tokenAdded: true);
    } catch (_) {
      yield await _getUnauthenticated("Invalid Api Key");
    }
  }

  Stream<AccountState> _removeToken(int tokenId) async* {
    await accountRepository.removeToken(tokenId);
    yield await _getUnauthenticated("Api Key removed");
  }  

  Future<UnauthenticatedState> _getUnauthenticated(String message, { bool tokenAdded = false }) async {
    return UnauthenticatedState(
      await accountRepository.getTokens(),
      message,
      tokenAdded
    );
  }
}
