part of 'changelog_bloc.dart';

@immutable
abstract class ChangelogEvent {}

class SetNewFeaturesSeenEvent extends ChangelogEvent {}