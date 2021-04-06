import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:guildwars2_companion/features/tabs/models/tab.dart';
import 'package:guildwars2_companion/features/tabs/repositories/tab.dart';
import 'package:meta/meta.dart';

part 'tab_event.dart';
part 'tab_state.dart';

class TabBloc extends Bloc<TabEvent, TabState> {
  final TabRepository tabRepository;

  TabBloc({
    @required this.tabRepository
  }) : super(TabInitialing());

  int index = 0;
  List<TabEntry> _tabs = [];

  @override
  Stream<TabState> mapEventToState(
    TabEvent event,
  ) async* {
    switch (event.runtimeType) {
      case ResetTabsEvent:
        yield TabInitialing();
        break;
      case SetAvailableTabsEvent:
        _tabs = tabRepository.getTabs((event as SetAvailableTabsEvent).permissions);
        yield getTabState();
        break;
      case SelectTabEvent:
        index = (event as SelectTabEvent).index;

        if (_tabs.isNotEmpty) {
          yield getTabState();
        }
        
        break;
    }
  }

  TabInitializedState getTabState() => TabInitializedState(
    index: index,
    tabs: _tabs
  );
}
