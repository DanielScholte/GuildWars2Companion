import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:guildwars2_companion/blocs/account/bloc.dart';
import 'package:guildwars2_companion/models/account/token_entry.dart';
import 'package:guildwars2_companion/pages/info.dart';
import 'package:guildwars2_companion/pages/tab.dart';
import 'package:guildwars2_companion/pages/token/how_to.dart';
import 'package:guildwars2_companion/pages/token/qr_code.dart';
import 'package:guildwars2_companion/widgets/button.dart';
import 'package:intl/intl.dart';

class TokenPage extends StatelessWidget {

  final _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
      systemNavigationBarColor: Colors.black,
      systemNavigationBarIconBrightness: Brightness.light
    ));

    return BlocListener<AccountBloc, AccountState>(
      condition: (previous, current) => current is AuthenticatedState || current is UnauthenticatedState,
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
      child: Scaffold(
        key: _scaffoldKey,
        backgroundColor: Colors.white,
        body: BlocBuilder<AccountBloc, AccountState>(
          builder: (BuildContext context, state) {
            if (state is UnauthenticatedState) {
              return Stack(
                children: <Widget>[
                  Align(
                    child: Image.asset(
                      'assets/token_footer.jpg',
                      width: double.infinity,
                      fit: BoxFit.cover,
                      alignment: Alignment.bottomLeft,
                    ),
                    alignment: Alignment.bottomLeft,
                  ),
                  Column(
                    children: <Widget>[
                      Stack(
                        children: <Widget>[
                          Image.asset(
                            'assets/token_header.jpg',
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
                      ),
                      if (state.tokens.isNotEmpty)
                        MediaQuery.removePadding(
                          removeTop: true,
                          context: context,
                          child: Expanded(
                            child: ListView(
                              children: state.tokens.map((t) => 
                                Dismissible(
                                  child: _tokenCard(context, t),
                                  key: ValueKey(t),
                                  // direction: DismissDirection.startToEnd,
                                  onDismissed: (_) => BlocProvider.of<AccountBloc>(context).add(RemoveTokenEvent(t.id)),
                                  secondaryBackground: Container(
                                    color: Colors.red,
                                    child: Row(
                                      mainAxisAlignment: MainAxisAlignment.end,
                                      children: <Widget>[
                                        Text(
                                          'Delete token',
                                          style: TextStyle(
                                            color: Colors.white,
                                            fontSize: 18.0
                                          ),
                                        ),
                                        Padding(
                                          padding: EdgeInsets.all(8.0),
                                          child: Icon(
                                            Icons.delete,
                                            color: Colors.white,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  background: Container(
                                    color: Colors.red,
                                    child: Row(
                                      children: <Widget>[
                                        Padding(
                                          padding: EdgeInsets.all(8.0),
                                          child: Icon(
                                            Icons.delete,
                                            color: Colors.white,
                                          ),
                                        ),
                                        Text(
                                          'Delete token',
                                          style: TextStyle(
                                            color: Colors.white,
                                            fontSize: 18.0
                                          ),
                                        )
                                      ],
                                    ),
                                  ),
                                )
                              ).toList(),
                            ),
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
                                      'No tokens found',
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
                Align(
                  child: Image.asset(
                    'assets/token_footer.jpg',
                    width: double.infinity,
                    fit: BoxFit.cover,
                    alignment: Alignment.bottomLeft,
                  ),
                  alignment: Alignment.bottomLeft,
                ),
                Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Stack(
                      children: <Widget>[
                        Image.asset(
                          'assets/token_header.jpg',
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
                    ),
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

              return SpeedDial(
                animatedIcon: AnimatedIcons.menu_close,
                animatedIconTheme: IconThemeData(size: 26.0),
                overlayColor: Colors.black,
                overlayOpacity: .6,
                backgroundColor: Colors.blue,
                // backgroundColor: Theme.of(context).primaryColor,
                foregroundColor: Colors.white,
                children: [
                  SpeedDialChild(
                    child: Icon(
                      FontAwesomeIcons.qrcode,
                      size: 18.0,
                    ),
                    labelStyle: TextStyle(
                      fontSize: 16.0,
                      fontWeight: FontWeight.w500
                    ),
                    backgroundColor: Colors.blue,
                    label: 'Enter token by Qr Code',
                    onTap: () => Navigator.of(context).push(MaterialPageRoute(
                      builder: (context) => QrCodePage()
                    )),
                  ),
                  SpeedDialChild(
                    child: Icon(
                      FontAwesomeIcons.solidEdit,
                      size: 18.0,
                    ),
                    labelStyle: TextStyle(
                      fontSize: 16.0,
                      fontWeight: FontWeight.w500
                    ),
                    backgroundColor: Colors.blue,
                    label: 'Enter token by text',
                    onTap: () => _addTokenByText(context),
                  ),
                  SpeedDialChild(
                    child: Icon(
                      FontAwesomeIcons.question,
                      size: 18.0,
                    ),
                    labelStyle: TextStyle(
                      fontSize: 16.0,
                      fontWeight: FontWeight.w500
                    ),
                    backgroundColor: Colors.deepOrange,
                    label: 'How do I get a token?',
                    onTap: () => Navigator.of(context).push(MaterialPageRoute(
                      builder: (context) => HowToTokenPage()
                    )),
                  ),
                  SpeedDialChild(
                    child: Icon(
                      FontAwesomeIcons.info,
                      size: 18.0,
                    ),
                    backgroundColor: Colors.deepOrange,
                    label: 'App information',
                    labelStyle: TextStyle(
                      fontSize: 16.0,
                      fontWeight: FontWeight.w500
                    ),
                    onTap: () => Navigator.of(context).push(MaterialPageRoute(
                      builder: (context) => InfoPage()
                    )),
                  ),
                ],
              );
            }

            return Container();
          },
        ),
      ),
    );
  }

  Widget _tokenCard(BuildContext context, TokenEntry token) {
    DateTime added = DateTime.tryParse(token.date);

    return CompanionButton(
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

  Future<void> _addTokenByText(BuildContext context) async {
    TextEditingController tokenFieldController = TextEditingController();

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Add your Guild Wars 2 token'),
          content: TextField(
            controller: tokenFieldController,
            decoration: InputDecoration(
              hintText: 'Token',
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
