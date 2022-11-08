import 'package:flutter/material.dart';

class SearchPage extends StatefulWidget {
  final Widget Function(BuildContext, String) builder;

  SearchPage({@required this.builder});

  @override
  _SearchPageState createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  String _search = "";

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
          child: TextFormField(
            decoration: InputDecoration(
              hintText: "Item to search for",
              labelText: "Search",
              contentPadding: EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
              focusColor: Theme.of(context).accentColor
            ),
            onChanged: (String value) {
              setState(() => _search = value );
            },
          ),
        ),
        Expanded(
          child: widget.builder(context, _search)
        )
      ]
    );
  }
}
