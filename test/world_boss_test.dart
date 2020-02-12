
import 'package:flutter_test/flutter_test.dart';
import 'package:guildwars2_companion/models/other/world_boss.dart';
import 'package:guildwars2_companion/repositories/world_boss.dart';
import 'package:mockito/mockito.dart';

import 'mocks/services.dart';

main() {
  group('World boss Timers', () {
    test('Times', () async {
      final worldBossService = MockWorldBossService();

      when(worldBossService.getWorldBosses())
        .thenReturn([
          WorldBoss(
            name: 'Test',
            location: 'Test',
            times: [
              '09:00',
              '15:00',
              '23:59',
            ]
          ),
        ]);

      final worldBossRepository = WorldBossRepository(
        worldBossService: worldBossService,
      );

      final worldBosses = await worldBossRepository.getWorldBosses(false);

      expect(worldBosses, hasLength(1));
      expect(worldBosses.first.dateTime, isNotNull);
      expect(worldBosses.first.refreshTime, isNotNull);
    });

    test('Progress', () async {
      final worldBossService = MockWorldBossService();

      when(worldBossService.getWorldBosses())
        .thenReturn([
          WorldBoss(
            name: 'Test',
            location: 'Test',
            times: [
              '09:00',
              '15:00',
              '23:59',
            ]
          ),
          WorldBoss(
            name: 'Test2',
            location: 'Test2',
            times: [
              '09:00',
              '15:00',
              '23:59',
            ]
          ),
        ]);
      
      when(worldBossService.getCompletedWorldBosses())
        .thenAnswer((_) async => [
          'Test'
        ]);

      final worldBossRepository = WorldBossRepository(
        worldBossService: worldBossService,
      );

      final worldBosses = await worldBossRepository.getWorldBosses(false);

      expect(worldBosses, hasLength(2));

      for(WorldBoss worldBoss in worldBosses) {
        expect(worldBoss.completed, worldBoss.id == 'Test');
      }
    });
  });
}