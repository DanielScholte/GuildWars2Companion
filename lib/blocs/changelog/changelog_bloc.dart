import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:guildwars2_companion/models/other/changelog.dart';
import 'package:guildwars2_companion/repositories/changelog.dart';
import 'package:meta/meta.dart';

part 'changelog_event.dart';
part 'changelog_state.dart';

class ChangelogBloc extends Bloc<ChangelogEvent, ChangelogState> {
  final ChangelogRepository changelogRepository;

  ChangelogBloc({
    this.changelogRepository
  }): super(LoadedChangelog(
    changelogs: changelogRepository.getChangelogData().changelog,
    allChanges: changelogRepository.getChangelogData().allChanges,
  ));

  @override
  Stream<ChangelogState> mapEventToState(
    ChangelogEvent event,
  ) async* {
    if (event is SetNewFeaturesSeenEvent) {
      await changelogRepository.saveNewFeaturesSeen();
      yield getChangelog();
    }
  }

  LoadedChangelog getChangelog() {
    ChangelogData changelogData = changelogRepository.getChangelogData();

    return LoadedChangelog(
      changelogs: changelogData.changelog,
      allChanges: changelogData.allChanges,
    );
  }
}
