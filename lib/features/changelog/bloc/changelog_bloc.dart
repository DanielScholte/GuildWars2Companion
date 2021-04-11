import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:guildwars2_companion/features/changelog/models/changelog.dart';
import 'package:guildwars2_companion/features/changelog/repositories/changelog.dart';
import 'package:meta/meta.dart';

part 'changelog_event.dart';
part 'changelog_state.dart';

class ChangelogBloc extends Bloc<ChangelogEvent, ChangelogState> {
  final ChangelogRepository changelogRepository;

  ChangelogBloc({
    this.changelogRepository
  }): super(ChangelogState(
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

  ChangelogState getChangelog() {
    ChangelogData changelogData = changelogRepository.getChangelogData();

    return ChangelogState(
      changelogs: changelogData.changelog,
      allChanges: changelogData.allChanges,
    );
  }
}
