import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:guildwars2_companion/features/account/bloc/account_bloc.dart';
import 'package:guildwars2_companion/features/account/widgets/layout.dart';
import 'package:guildwars2_companion/features/account/widgets/token_button.dart';
import 'package:guildwars2_companion/features/configuration/pages/configuration.dart';
import 'package:guildwars2_companion/features/tabs/pages/tab.dart';
import 'package:guildwars2_companion/features/account/pages/how_to.dart';
import 'package:guildwars2_companion/features/account/pages/qr_code.dart';

class TokenPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocConsumer<AccountBloc, AccountState>(
        listenWhen: (previous, current) => current is AuthenticatedState || current is UnauthenticatedState,
        listener: (BuildContext context, state) {
          if (state is UnauthenticatedState) {
            if (state.message != null) {
              Scaffold.of(context).showSnackBar(SnackBar(content: Text(state.message)));
            }

            return;
          }

          Navigator.of(context).pushReplacement(
            MaterialPageRoute(builder: (BuildContext context) => TabPage()));
        },
        builder: (BuildContext context, state) {
          if (state is UnauthenticatedState) {
            return TokenLayout(
              child: state.tokens.isEmpty
                ? _NoTokenWarning()
                : ListView(
                  padding: Theme.of(context).brightness == Brightness.light ? EdgeInsets.zero : EdgeInsets.only(top: 6.0),
                  children: state.tokens
                    .map((t) => AccountTokenButton(token: t))
                    .toList(),
                ),
            );
          }

          return TokenLayout(
            child: Center(
              child: CircularProgressIndicator(),
            ),
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
                  labelWidget: _SpeedDailLabel(label: 'Enter Api Key by Qr Code'),
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
                  labelWidget: _SpeedDailLabel(label: 'Enter Api Key by text'),
                  onTap: () => _addTokenByText(context),
                ),
                SpeedDialChild(
                  child: Icon(
                    FontAwesomeIcons.question,
                    color: Colors.white,
                    size: 18.0,
                  ),
                  backgroundColor: backgroundColorAccent,
                  labelWidget: _SpeedDailLabel(label: 'How do I get an Api Key?'),
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
                  labelWidget: _SpeedDailLabel(label: 'Settings'),
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

class _NoTokenWarning extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Padding(
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
    );
  }
}

class _SpeedDailLabel extends StatelessWidget {
  final String label;

  const _SpeedDailLabel({@required this.label});

  @override
  Widget build(BuildContext context) {
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
}