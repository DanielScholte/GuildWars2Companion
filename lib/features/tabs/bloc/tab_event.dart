part of 'tab_bloc.dart';

@immutable
abstract class TabEvent {}

class ResetTabsEvent extends TabEvent {}

class SelectTabEvent extends TabEvent {
  final int index;

  SelectTabEvent(this.index);
}

class SetAvailableTabsEvent extends TabEvent {
  final List<String> permissions;

  SetAvailableTabsEvent({@required this.permissions});
}