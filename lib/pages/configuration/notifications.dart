import 'dart:io';

import 'package:flutter/material.dart';
import 'package:guildwars2_companion/widgets/appbar.dart';
import 'package:guildwars2_companion/widgets/notification_list.dart';

class NotificationsPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CompanionAppBar(
        title: 'Notifications',
        color: Colors.blue,
      ),
      body: Center(
        child: SingleChildScrollView(
          child: Column(
            children: <Widget>[
              CompanionNotificationList(),
              if (Platform.isAndroid)
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 8.0),
                  child: RichText(
                    text: TextSpan(
                      text: '',
                      style: Theme.of(context).textTheme.bodyText1,
                      children: [
                        TextSpan(
                          text: 'Warning: ',
                          style: TextStyle(
                            fontWeight: FontWeight.w500
                          ),
                        ),
                        TextSpan(
                          text: "Some Android OEMs close background services to save battery life. If you're experiencing issues with not receiving notifications, please disable battery management for this app.",
                          style: TextStyle(
                            fontWeight: FontWeight.normal
                          ),
                        ),
                      ],
                    )
                  )
                )
            ],
          ),
        ),
      )
    );
  }
}