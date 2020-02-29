part of 'changelog_bloc.dart';

@immutable
abstract class ChangelogState {}

class LoadedChangelog extends ChangelogState {
  final List<Changelog> changelogs;
  final List<String> allChanges;

  LoadedChangelog({
    @required this.changelogs,
    @required this.allChanges
  });
}
