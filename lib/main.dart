import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:guildwars2_companion/blocs/configuration/configuration_bloc.dart';
import 'package:guildwars2_companion/factory.dart';
import 'package:guildwars2_companion/pages/tab.dart';
import 'package:guildwars2_companion/pages/token/token.dart';
import 'package:guildwars2_companion/utils/theme.dart';
import 'models/other/configuration.dart';

Future main() async {
  WidgetsFlutterBinding.ensureInitialized();

  CompanionFactory companionFactory = CompanionFactory();
  await companionFactory.initializeServices();

  runApp(GuildWars2Companion(
    companionFactory: companionFactory,
    isAuthenticated: await companionFactory
      .tokenService
      .tokenPresent(),
  ));
}

class GuildWars2Companion extends StatelessWidget {
  final CompanionFactory companionFactory;
  final bool isAuthenticated;

  const GuildWars2Companion({
    @required this.companionFactory,
    @required this.isAuthenticated
  });

  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);

    return companionFactory.initializeRepositories(
      child: companionFactory.initializeBlocs(
        child: BlocBuilder<ConfigurationBloc, ConfigurationState>(
          builder: (context, state) {
            final Configuration configuration = (state as LoadedConfiguration).configuration;

            return MaterialApp(
              title: 'Guild Wars 2 Companion',
              theme: ThemeUtil.getLightTheme(),
              darkTheme: ThemeUtil.getDarkTheme(),
              themeMode: configuration.themeMode,
              home: isAuthenticated ? TabPage() : TokenPage(),
            );
          }
        ),
      ),
    );
  }
}
