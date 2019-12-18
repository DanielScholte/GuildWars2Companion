import 'package:flutter/material.dart';
import 'package:guildwars2_companion/widgets/button.dart';

class TokenPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [Colors.white, Color(0xFFffd2d1)],
          stops: [0.2, 1.0]
        ),
      ),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        body: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Image.asset('assets/token_header.png'),
            // Text(
            //   'Welcome to the Guild Wars 2 Companion app!',
            //   style: TextStyle(
            //     color: Colors.red,
            //     fontSize: 18.0,
            //     fontWeight: FontWeight.w300
            //   ),
            // ),
            buildTokenCard(context)
          ],
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
                    return 'Please enter your token';
                  }
                  return null;
                },
              ),
              SizedBox(height: 16.0,),
              CompanionButton(
                padding: EdgeInsets.zero,
                onTap: () {},
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
        )
      ),
    );
  }
}