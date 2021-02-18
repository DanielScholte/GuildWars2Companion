import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:guildwars2_companion/blocs/account/bloc.dart';
import 'package:guildwars2_companion/models/account/token_entry.dart';
import 'package:guildwars2_companion/pages/configuration/configuration.dart';
import 'package:guildwars2_companion/features/home/pages/tab.dart';
import 'package:guildwars2_companion/features/account/pages/how_to.dart';
import 'package:guildwars2_companion/features/account/pages/qr_code.dart';
import 'package:guildwars2_companion/features/account/widgets/dismissible_button.dart';
import 'package:guildwars2_companion/core/widgets/header.dart';
import 'package:intl/intl.dart';

class TokenPage extends StatelessWidget {

  final _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
      systemNavigationBarColor: Theme.of(context).scaffoldBackgroundColor,
      systemNavigationBarIconBrightness: Theme.of(context).brightness == Brightness.dark ? Brightness.light : Brightness.dark
    ));

    return Scaffold(
      key: _scaffoldKey,
      body: BlocConsumer<AccountBloc, AccountState>(
        listenWhen: (previous, current) => current is AuthenticatedState || current is UnauthenticatedState,
        listener: (BuildContext context, state) {
          if (state is UnauthenticatedState) {
            if (state.message != null) {
              _scaffoldKey.currentState.showSnackBar(SnackBar(content: Text(state.message)));
            }

            return;
          }

          Navigator.of(context).pushReplacement(
            MaterialPageRoute(builder: (BuildContext context) => TabPage()));
        },
        builder: (BuildContext context, state) {
          if (state is UnauthenticatedState) {
            return Stack(
              children: <Widget>[
                _getFooter(context),
                Column(
                  children: <Widget>[
                    _getHeader(context),
                    if (state.tokens.isNotEmpty)
                      Expanded(
                        child: ListView(
                          padding: Theme.of(context).brightness == Brightness.light ? EdgeInsets.zero : EdgeInsets.only(top: 6.0),
                          children: state.tokens
                            .map((t) => _tokenCard(context, t))
                            .toList(),
                        ),
                      ),
                    if (state.tokens.isEmpty)
                      Expanded(
                        child: Padding(
                          padding: EdgeInsets.all(8.0),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: <Widget>[
                              Column(
                                children: <Widget>[
                                  Text(
                                    'No Api Keys found',
                                    style: TextStyle(
                                      fontSize: 24.0,
                                      fontWeight: FontWeight.w500
                                    ),
                                  ),
                                  Text(
                                    'Add one using the button in the bottom right corner.',
                                    style: TextStyle(
                                      fontSize: 18.0,
                                      fontWeight: FontWeight.w300
                                    ),
                                    textAlign: TextAlign.center,
                                  ),
                                ],
                              ),
                              
                            ],
                          ),
                        ),
                      ),
                  ],
                ),
              ],
            );
          }

          return Stack(
            children: <Widget>[
              _getFooter(context),
              Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  _getHeader(context),
                  CircularProgressIndicator(),
                  Container()
                ],
              ),
            ],
          );
        },
      ),
      floatingActionButton: BlocBuilder<AccountBloc, AccountState>(
        builder: (BuildContext context, state) {
          if (state is UnauthenticatedState) {
            Color backgroundColor = Theme.of(context).brightness == Brightness.light ? Colors.blue : Color(0xFF323232);
            Color backgroundColorAccent = Theme.of(context).brightness == Brightness.light ? Colors.deepOrange : Color(0xFF323232);

            return SpeedDial(
              animatedIcon: AnimatedIcons.menu_close,
              animatedIconTheme: IconThemeData(size: 26.0),
              overlayColor: Colors.black,
              overlayOpacity: .6,
              backgroundColor: backgroundColor,
              foregroundColor: Colors.white,
              elevation: Theme.of(context).brightness == Brightness.light ? 6.0 : 0.0,
              children: [
                SpeedDialChild(
                  child: Icon(
                    FontAwesomeIcons.qrcode,
                    color: Colors.white,
                    size: 18.0,
                  ),
                  backgroundColor: backgroundColor,
                  labelWidget: _speedDailLabel(context, 'Enter Api Key by Qr Code'),
                  onTap: () => Navigator.of(context).push(MaterialPageRoute(
                    builder: (context) => QrCodePage()
                  )),
                ),
                SpeedDialChild(
                  child: Icon(
                    FontAwesomeIcons.solidEdit,
                    color: Colors.white,
                    size: 18.0,
                  ),
                  backgroundColor: backgroundColor,
                  labelWidget: _speedDailLabel(context, 'Enter Api Key by text'),
                  onTap: () => _addTokenByText(context),
                ),
                SpeedDialChild(
                  child: Icon(
                    FontAwesomeIcons.question,
                    color: Colors.white,
                    size: 18.0,
                  ),
                  backgroundColor: backgroundColorAccent,
                  labelWidget: _speedDailLabel(context, 'How do I get an Api Key?'),
                  onTap: () => Navigator.of(context).push(MaterialPageRoute(
                    builder: (context) => HowToTokenPage()
                  )),
                ),
                SpeedDialChild(
                  child: Icon(
                    FontAwesomeIcons.cog,
                    color: Colors.white,
                    size: 18.0,
                  ),
                  backgroundColor: backgroundColorAccent,
                  labelWidget: _speedDailLabel(context, 'Settings'),
                  onTap: () => Navigator.of(context).push(MaterialPageRoute(
                    builder: (context) => ConfigurationPage()
                  )),
                ),
              ],
            );
          }

          return Container();
        },
      )
    );
  }

  Widget _speedDailLabel(BuildContext context, String label) {
    return Container(
      padding: EdgeInsets.all(6.0),
      margin: EdgeInsets.only(right: 16.0),
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        boxShadow: [
          if (Theme.of(context).brightness == Brightness.light)
            BoxShadow(
              color: Colors.black54,
              blurRadius: 4.0,
            ),
        ],
        borderRadius: BorderRadius.circular(6.0)
      ),
      child: Text(
        label,
        style: Theme.of(context).textTheme.bodyText1.copyWith(
          fontWeight: FontWeight.w500
        ),
      ),
    );
  }

  Widget _tokenCard(BuildContext context, TokenEntry token) {
    DateTime added = DateTime.tryParse(token.date);

    return DismissibleButton(
      key: ValueKey(token.id),
      onDismissed: () => BlocProvider.of<AccountBloc>(context).add(RemoveTokenEvent(token.id)),
      color: Colors.blue,
      leading: Icon(
        FontAwesomeIcons.key,
        color: Colors.white,
      ),
      title: token.name,
      subtitles: added != null ? [
        'Added: ${DateFormat('yyyy-MM-dd').format(added)}'
      ] : null,
      onTap: () => BlocProvider.of<AccountBloc>(context).add(AuthenticateEvent(token.token)),
    );
  }

  Widget _getHeader(BuildContext context) {
    if (Theme.of(context).brightness == Brightness.dark) {
      return CompanionHeader(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Image.asset(
              'assets/token_header_logo.png',
              height: 64.0,
            ),
            Container(width: 8.0,),
            Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(
                  'GW2 Companion',
                  style: Theme.of(context).textTheme.headline1.copyWith(
                    fontWeight: FontWeight.w500
                  ),
                ),
                Text(
                  'Api Keys',
                  style: Theme.of(context).textTheme.headline1.copyWith(
                    fontWeight: FontWeight.w300
                  ),
                ),
              ],
            )
          ],
        ),
      );
    }

    return Stack(
      children: <Widget>[
        Image.asset(
          'assets/token_header.png',
          height: 170.0,
          width: double.infinity,
          fit: BoxFit.cover,
          alignment: Alignment.bottomCenter,
        ),
        SafeArea(
          child: Center(
            child: Padding(
              padding: EdgeInsets.only(top: 8.0),
              child: Image.asset(
                'assets/token_header_logo.png',
                height: 72.0,
              ),
            ),
          ),
        )
      ],
    );
  }

  Widget _getFooter(BuildContext context) {
    if (Theme.of(context).brightness == Brightness.dark) {
      return Container();
    }

    return Align(
      child: Image.asset(
        'assets/token_footer.png',
        width: double.infinity,
        fit: BoxFit.cover,
        alignment: Alignment.bottomLeft,
      ),
      alignment: Alignment.bottomLeft,
    );
  }

  Future<void> _addTokenByText(BuildContext context) async {
    TextEditingController tokenFieldController = TextEditingController();

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Add your Guild Wars 2 Api Key'),
          content: TextField(
            controller: tokenFieldController,
            decoration: InputDecoration(
              hintText: 'Api Key',
            ),
          ),
          actions: <Widget>[
            FlatButton(
              child: Text(
                'Cancel',
                style: TextStyle(
                  fontSize: 18.0
                ),
              ),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            FlatButton(
              child: Text(
                'Add',
                style: TextStyle(
                  fontSize: 18.0
                ),
              ),
              onPressed: () {
                Navigator.of(context).pop();
                
                BlocProvider.of<AccountBloc>(context).add(AddTokenEvent(tokenFieldController.text));
              },
            ),
          ],
        );
      },
    );
  }
}
