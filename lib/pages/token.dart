import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:guildwars2_companion/blocs/account/bloc.dart';
import 'package:intl/intl.dart';

import 'tab.dart';

class TokenPage extends StatelessWidget {

  final _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
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
                    child: Image.asset('assets/token_footer.png'),
                    alignment: Alignment.bottomCenter,
                  ),
                  Column(
                    children: <Widget>[
                      Image.asset('assets/token_header.png'),
                      if (state.tokens.isNotEmpty)
                        Expanded(
                          child: ListView(
                            children: state.tokens.map((t) => 
                              Dismissible(
                                child: _tokenCard(context, t),
                                key: ValueKey(t),
                                direction: DismissDirection.startToEnd,
                                onDismissed: (_) => BlocProvider.of<AccountBloc>(context).add(RemoveTokenEvent(t)),
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
                                Container()
                              ],
                            ),
                          ),
                        )
                    ],
                  ),
                ],
              );
            }

            return Stack(
              children: <Widget>[
                Align(
                  child: Image.asset('assets/token_footer.png'),
                  alignment: Alignment.bottomCenter,
                ),
                Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Image.asset('assets/token_header.png'),
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
              return FloatingActionButton(
                backgroundColor: Theme.of(context).primaryColor,
                foregroundColor: Colors.white,
                splashColor: Color(0x10FFFFFF),
                child: Icon(Icons.add),
                onPressed: () => _createToken(context),
              );
            }

            return Container();
          },
        ),
      ),
    );
  }

  Widget _tokenCard(BuildContext context, String token) {
    List<String> tokenParts = token.split(';');
    DateTime added = DateTime.tryParse(tokenParts[2]);
    return Container(
      margin: EdgeInsets.all(8.0),
      decoration: BoxDecoration(
        color: Colors.red,
        borderRadius: BorderRadius.circular(8.0),
        // boxShadow: [
        //   BoxShadow(
        //     color: Colors.black38,
        //     blurRadius: 8.0,
        //   ),
        // ]
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: () => BlocProvider.of<AccountBloc>(context).add(AuthenticateEvent(tokenParts[0])),
          borderRadius: BorderRadius.circular(8.0),
          splashColor: Color(0x22DDDDDD),
          highlightColor: Color(0x22DDDDDD),
          child: Padding(
            padding: EdgeInsets.all(8.0),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(
                      tokenParts[1],
                      style: TextStyle(
                        fontSize: 18.0,
                        fontWeight: FontWeight.w500,
                        color: Colors.white,
                      ),
                    ),
                    if (added != null)
                      Text(
                        'Added: ${DateFormat('yyyy-MM-dd - kk:mm').format(added)}',
                        style: TextStyle(
                          fontSize: 16.0,
                          color: Colors.white,
                        ),
                      ),
                  ],
                ),
                Icon(
                  Icons.chevron_right,
                  color: Colors.white,
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  Future<void> _createToken(BuildContext context) async {
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
                'Create',
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