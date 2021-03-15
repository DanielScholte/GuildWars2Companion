import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:guildwars2_companion/core/utils/urls.dart';

class ErrorPage extends StatelessWidget {
  final String exception;

  ErrorPage({@required this.exception});

  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle(
        systemNavigationBarColor: Theme.of(context).primaryColor,
        systemNavigationBarIconBrightness: Brightness.light
      ),
      child: Scaffold(
        backgroundColor: Theme.of(context).primaryColor,
        body: SafeArea(
          child: Center(
            child: SingleChildScrollView(
              child: Padding(
                padding: EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Image.asset(
                      'assets/token_header_logo.png',
                      height: 128.0,
                    ),
                    Container(height: 16),
                    Text(
                      'There was an error while loading GW2 Companion',
                      style: Theme.of(context).textTheme.headline1,
                      textAlign: TextAlign.center,
                    ),
                    Container(height: 96),
                    Text(
                      'You can send the error log to the developer to get the issue fixed.',
                      style: Theme.of(context).textTheme.headline2.copyWith(color: Colors.white),
                      textAlign: TextAlign.center,
                    ),
                    Container(height: 16),
                    Text(
                      'You will be contacted shortly afterwards with an estimation on when the issue will be fixed.',
                      style: Theme.of(context).textTheme.headline2.copyWith(color: Colors.white),
                      textAlign: TextAlign.center,
                    ),
                    Container(height: 16),
                    _SendLogsButton(exception: exception),
                    Container(height: 16),
                    _CopyLogsButton(exception: exception)
                  ]
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _SendLogsButton extends StatelessWidget {
  final String exception;

  _SendLogsButton({@required this.exception});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        color: Colors.white
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(12),
          onTap: () => Urls.launchUrl(Uri(
            scheme: 'mailto',
            path: Urls.emailUrl,
            queryParameters: {
              'subject': 'GW2 Companion error log',
              'body': exception
            }
          ).toString()),
          child: Container(
            height: 48,
            width: double.infinity,
            alignment: Alignment.center,
            child: Text(
              'Send error log by mail',
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Theme.of(context).primaryColor,
                fontSize: 18.0,
                fontWeight: FontWeight.w600,
              )
            ),
          ),
        ),
      ),
    );
  }
}

class _CopyLogsButton extends StatelessWidget {
  final String exception;

  _CopyLogsButton({@required this.exception});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        color: Colors.transparent,
        border: Border.all(
          color: Colors.white,
          width: 2
        )
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(12),
          onTap: () => Clipboard.setData(ClipboardData(text: exception)),
          child: Container(
            height: 48,
            width: double.infinity,
            alignment: Alignment.center,
            child: Text(
              'Copy error log to clipboard',
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Colors.white,
                fontSize: 18.0,
                fontWeight: FontWeight.w600,
              )
            ),
          ),
        ),
      ),
    );
  }
}