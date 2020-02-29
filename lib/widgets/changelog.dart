import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:guildwars2_companion/providers/changelog.dart';
import 'package:guildwars2_companion/widgets/simple_button.dart';
import 'package:provider/provider.dart';

class CompanionChangelog extends StatefulWidget {
  @override
  _CompanionChangelogState createState() => _CompanionChangelogState();
}

class _CompanionChangelogState extends State<CompanionChangelog> {

  int _opacity = 0;
  bool _displayChangelog = false;

  @override
  void initState() {
    super.initState();

    _displayChangelog = Provider.of<ChangelogProvider>(context, listen: false).anyNewChangelog();

    if (_displayChangelog) {
      setState(() {});

      Future.delayed(Duration(milliseconds: 100))
        .then((_) => setState(() => _opacity = 1));
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_displayChangelog) {
      return Consumer<ChangelogProvider>(
        builder: (context, state, child) {
          return AnimatedOpacity(
            opacity: _opacity.toDouble(),
            duration: Duration(milliseconds: 250),
            child: Container(
              color: Colors.black87,
              child: SafeArea(
                child: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: <Widget>[
                      Column(
                        children: <Widget>[
                          Icon(
                            FontAwesomeIcons.smile,
                            size: 48,
                            color: Colors.white,
                          ),
                          Text(
                            'Welcome back!',
                            style: Theme.of(context).textTheme.display1.copyWith(
                              fontSize: 28,
                              fontWeight: FontWeight.w500
                            ),
                          ),
                        ],
                      ),
                      Column(
                        children: <Widget>[
                          Text(
                            'Since your last visit, the following new features have been added to the app:',
                            style: Theme.of(context).textTheme.display2.copyWith(
                              color: Colors.white
                            ),
                            textAlign: TextAlign.center,
                          ),
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Column(
                              children: state.getNewFeatures()
                                .map((c) => Row(
                                  children: <Widget>[
                                    Container(
                                      width: 20.0,
                                      child: Icon(
                                        FontAwesomeIcons.solidCircle,
                                        color: Colors.white,
                                        size: 6.0,
                                      ),
                                    ),
                                    Text(
                                      c,
                                      style: Theme.of(context).textTheme.display3.copyWith(
                                        color: Colors.white
                                      ),
                                    )
                                  ],
                                ))
                                .toList()
                            ),
                          ),
                        ],
                      ),
                      CompanionSimpleButton(
                        text: 'Continue',
                        onPressed: () async {
                          await state.saveNewFeaturesSeen();
                          setState(() => _opacity = 0);
                          await Future.delayed(Duration(milliseconds: 250));
                          setState(() => _displayChangelog = false);
                        },
                      )
                    ],
                  ),
                ),
              ),
            ),
          );
        }
      );
    }
    return Container();
  }
}