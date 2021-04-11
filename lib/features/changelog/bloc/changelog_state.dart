part of 'changelog_bloc.dart';

class ChangelogState {
  final List<Changelog> changelogs;
  final List<String> allChanges;

  ChangelogState({
    @required this.changelogs,
    @required this.allChanges
  });
}
