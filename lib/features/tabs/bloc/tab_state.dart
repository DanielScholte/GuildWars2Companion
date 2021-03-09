part of 'tab_bloc.dart';

@immutable
abstract class TabState {}

class TabInitialing extends TabState {}

class TabInitializedState extends TabState {
  final int index;
  final List<TabEntry> tabs;

  TabInitializedState({
    @required this.index,
    @required this.tabs
  });
}