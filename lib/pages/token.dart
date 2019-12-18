import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:guildwars2_companion/blocs/account/bloc.dart';
import 'package:guildwars2_companion/widgets/button.dart';

import 'tab.dart';

class TokenPage extends StatelessWidget {
  final _formKey = GlobalKey<FormState>();

  final _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    return BlocListener<AccountBloc, AccountState>(
      listener: (BuildContext context, state) {
        if (state is AuthenticatedState) {
          Navigator.of(context).pushReplacement(
            MaterialPageRoute(builder: (BuildContext context) => TabPage()));
        }
      },
      child: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Colors.white, Color(0xFFffd2d1)],
            stops: [0.2, 1.0]
          ),
        ),
        child: Scaffold(
          key: _scaffoldKey,
          backgroundColor: Colors.transparent,
          body: BlocBuilder<AccountBloc, AccountState>(
            builder: (BuildContext context, state) {
              if (state is UnauthenticatedState) {
                return Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Image.asset('assets/token_header.png'),
                    buildTokenCard(context)
                  ],
                );
              }

              return Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Image.asset('assets/token_header.png'),
                  CircularProgressIndicator(),
                  Container(),
                ],
              );
            },
          ),
        ),
      ),
    );
  }

  Padding buildTokenCard(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(8.0),
      child: Card(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(18.0),
        ),
        child: Container(
          padding: EdgeInsets.only(left: 16.0, right: 16.0, top: 16.0, bottom: 8.0),
          width: 800.0,
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: <Widget>[
                Text(
                  'Please enter your Guild Wars 2 token',
                  style: TextStyle(
                    fontSize: 18.0,
                  ),
                ),
                SizedBox(height: 16.0,),
                TextFormField(
                  decoration: InputDecoration(
                    hintText: "Token",
                    prefixIcon: Icon(Icons.vpn_key),
                  ),
                  validator: (value) {
                    if (value.isEmpty) {
                      return 'Enter a token';
                    }
                    return null;
                  },
                  onSaved: (token) => BlocProvider.of<AccountBloc>(context).add(AuthenticateEvent(token)),
                ),
                SizedBox(height: 16.0,),
                CompanionButton(
                  padding: EdgeInsets.zero,
                  onTap: () => _tokenSubmit(),
                  text: 'Sign-in',
                ),
                CompanionButton(
                  padding: EdgeInsets.zero,
                  onTap: () {},
                  text: "Don't have a token yet?",
                  color: Colors.grey[900],
                ),
              ],
            ),
          ),
        )
      ),
    );
  }

  void _tokenSubmit() {
    if (!_formKey.currentState.validate()) {
      _scaffoldKey.currentState.showSnackBar(SnackBar(content: Text('Invalid token')));
      return;
    }

    _formKey.currentState.save();
  }
}