import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:guildwars2_companion/core/themes/dark.dart';
import 'package:guildwars2_companion/core/themes/light.dart';
import 'package:guildwars2_companion/factory.dart';
import 'package:guildwars2_companion/features/configuration/bloc/configuration_bloc.dart';
import 'package:guildwars2_companion/features/error/pages/error.dart';
import 'package:guildwars2_companion/features/home/pages/tab.dart';
import 'package:guildwars2_companion/features/account/pages/token.dart';

Future main() async {
  WidgetsFlutterBinding.ensureInitialized();

  CompanionFactory companionFactory = CompanionFactory();

  try {
    await companionFactory.initializeServices();

    runApp(GuildWars2Companion(
      companionFactory: companionFactory,
      page: await companionFactory
        .tokenService
        .tokenPresent()
        ? TabPage() : TokenPage(),
    ));
  } catch (exception) {
    runApp(GuildWars2Companion(
      companionFactory: companionFactory,
      page: ErrorPage(
        exception: exception.toString(),
      ),
    ));
  }
  
}

class GuildWars2Companion extends StatelessWidget {
  final CompanionFactory companionFactory;
  final Widget page;

  const GuildWars2Companion({
    @required this.companionFactory,
    @required this.page
  });

  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);

    return companionFactory.initializeRepositories(
      child: companionFactory.initializeBlocs(
        child: BlocBuilder<ConfigurationBloc, ConfigurationState>(
          builder: (context, state) {
            return MaterialApp(
              title: 'Guild Wars 2 Companion',
              theme: lightTheme,
              darkTheme: darkTheme,
              themeMode: state.configuration.themeMode,
              home: page,
            );
          }
        ),
      ),
    );
  }
}
