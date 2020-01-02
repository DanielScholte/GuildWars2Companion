import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class CompanionFullButton extends StatelessWidget {
  final bool loading;
  final Widget leading;
  final Widget trailing;
  final String title;
  final List<String> subtitles;
  final VoidCallback onTap;
  final Color color;

  CompanionFullButton({
    @required this.title,
    @required this.onTap,
    @required this.color,
    this.subtitles,
    this.leading,
    this.trailing,
    this.loading = false,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: 80.0,
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(12.0),
        boxShadow: [
          BoxShadow(
            color: Colors.black26,
            blurRadius: 8.0,
          ),
        ],
      ),
      margin: EdgeInsets.all(8.0),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(12.0),
        child: Material(
          color: Colors.transparent,
          child: InkWell(
            splashColor: Colors.white12,
            highlightColor: Colors.white12,
            onTap: () => onTap(),
            child: Row(
              children: <Widget>[
                _buildLeading(context),
                _buildTitle(),
                if (trailing == null)
                  _buildArrow()
                else
                  trailing
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildLeading(BuildContext context) {
    return Container(
      width: 80.0,
      height: 80.0,
      color: Colors.black12,
      margin: EdgeInsets.only(right: 16.0),
      alignment: Alignment.center,
      child: this.loading ?
        Theme(
          data: Theme.of(context).copyWith(accentColor: Colors.white),
          child: CircularProgressIndicator(),
        ) :
        this.leading,
    );
  }

  Widget _buildTitle() {
    List<Widget> titles = [
      Text(
        this.title,
        style: TextStyle(
          color: Colors.white,
          fontSize: 18.0,
          fontWeight: FontWeight.w500
        ),
      ),
    ];

    if (this.subtitles != null) {
      titles.addAll(
        this.subtitles.map(
          (s) => Text(
            s,
            style: TextStyle(
              color: Colors.white,
              fontSize: 16.0,
            ),
          )
        ).toList()
      );
    }

    return Expanded(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: titles,
      ),
    );
  }

  Widget _buildArrow() {
    return Padding(
      padding: EdgeInsets.all(4.0),
      child: Icon(
        FontAwesomeIcons.chevronRight,
        color: Colors.white,
        size: 18.0,
      ),
    );
  }
}