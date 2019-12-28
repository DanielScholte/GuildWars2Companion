import 'package:flutter/material.dart';

class CompanionInfoBox extends StatelessWidget {
  final String header;
  final String text;
  final bool loading;

  CompanionInfoBox({
    @required this.header,
    this.text = '?',
    this.loading = true
  });

  @override
  Widget build(BuildContext context) {
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