import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:guildwars2_companion/blocs/account/bloc.dart';
import 'package:guildwars2_companion/utils/gw.dart';

class HomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AccountBloc, AccountState>(
      condition: (previous, current) => current is AuthenticatedState,
      builder: (context, state) {
        if (state is AuthenticatedState) {
          return Column(
            children: <Widget>[
              Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [Color(0xFFde382c), Colors.red] 
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black,
                      blurRadius: 8.0,
                    ),
                  ],
                  borderRadius: BorderRadius.only(bottomLeft: Radius.circular(12.0), bottomRight: Radius.circular(12.0))
                ),
                margin: EdgeInsets.only(bottom: 16.0),
                width: double.infinity,
                child: SafeArea(
                  minimum: EdgeInsets.all(16.0),
                  child: Column(
                    children: <Widget>[
                      _buildAccountHeader(state.account.name),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: <Widget>[
                          _buildPlaytimeBox(context),
                          if (state.tokenInfo.permissions.contains('progression'))
                            _buildHeaderInfoBox(context, "Mastery level", "298?", false),
                          if (state.tokenInfo.permissions.contains('progression'))
                            _buildHeaderInfoBox(context, "Achievements", "30.000?", false),
                        ],
                      )
                    ],
                  ),
                ),
              ),
            ],
          );
        }

        return Container();
      },
    );
  }

  Widget _buildAccountHeader(String accountName) {
    return Padding(
      padding: EdgeInsets.only(top: 16.0, bottom: 16.0),
      child: RichText(
        text: TextSpan(
          text: 'Welcome ',
          style: TextStyle(
            color: Colors.white,
            fontSize: 20.0,
            fontWeight: FontWeight.w300
          ),            
          children: [
            TextSpan(
              text: accountName,
              style: TextStyle(
                fontWeight: FontWeight.w400
              )
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPlaytimeBox(BuildContext context) {
    return BlocBuilder<AccountBloc, AccountState>(
      builder: (context, state) {
        if (state is AuthenticatedState) {
          return _buildHeaderInfoBox(context, 'Playtime', GuildWarsUtil.calculatePlayTime(state.account.age).toString(), false);
        }

        return _buildHeaderInfoBox(context, 'Playtime', '?', true);
      },
    );
  }

  Widget _buildHeaderInfoBox(BuildContext context, String header, String text, bool loading) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.transparent,
        border: Border.all(color: Colors.white, width: 2.0),
        borderRadius: BorderRadius.circular(12.0),
      ),
      height: 80.0,
      width: 100.0,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: <Widget>[
          Text(
            header,
            style: TextStyle(
              color: Colors.white,
              fontSize: 12.0
            ),
            textAlign: TextAlign.center,
          ),
          if (loading)
            Theme(
              data: Theme.of(context).copyWith(accentColor: Colors.white),
              child: Container(
                width: 22.0,
                height: 22.0,
                child: CircularProgressIndicator(
                  strokeWidth: 2.0,
                )
              ),
            ),
          if (!loading)
            Text(
              text,
              style: TextStyle(
                color: Colors.white,
                fontSize: 20.0,
                fontWeight: FontWeight.w600
              ),
            ),
        ],
      ),
    );
  }
}