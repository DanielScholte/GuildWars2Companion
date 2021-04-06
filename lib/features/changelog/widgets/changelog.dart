import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:guildwars2_companion/features/changelog/bloc/changelog_bloc.dart';
import 'package:guildwars2_companion/features/changelog/repositories/changelog.dart';
import 'package:guildwars2_companion/core/widgets/simple_button.dart';

class ChangelogPopup extends StatefulWidget {
  @override
  _ChangelogPopupState createState() => _ChangelogPopupState();
}

class _ChangelogPopupState extends State<ChangelogPopup> with TickerProviderStateMixin {
  AnimationController _controller;
  Animation<double> _animation;

  @override
  void initState() {
    _controller = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 250),
    );

    _animation = Tween<double>(
      begin: 0,
      end: 1,
    ).animate(CurvedAnimation(
      curve: Curves.easeInOutSine,
      parent: _controller,
    ));

    super.initState();

    if (RepositoryProvider.of<ChangelogRepository>(context).anyNewChanges()) {
      Future.delayed(Duration(milliseconds: 250)).then((_) => _controller.forward());
    }
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _animation,
      builder: (BuildContext context, Widget child) {
        if (_animation.value == 0) {
          return Container();
        }

        return Opacity(
          opacity: _animation.value,
          child: _ChangelogLayout(
            onDismiss: () {
              BlocProvider.of<ChangelogBloc>(context).add(SetNewFeaturesSeenEvent());
              _controller.reverse();
            },
          ),
        );
      },
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }
}

class _ChangelogLayout extends StatelessWidget {
  final Function onDismiss;

  _ChangelogLayout({@required this.onDismiss});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ChangelogBloc, ChangelogState>(
      builder: (context, state) {
        return Container(
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
                        style: Theme.of(context).textTheme.headline1.copyWith(
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
                        style: Theme.of(context).textTheme.headline2.copyWith(
                          color: Colors.white
                        ),
                        textAlign: TextAlign.center,
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Column(
                          children: state.allChanges
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
                                Expanded(
                                  child: Text(
                                    c,
                                    style: Theme.of(context).textTheme.bodyText1.copyWith(
                                      color: Colors.white
                                    ),
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
                    onPressed: onDismiss,
                  )
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}