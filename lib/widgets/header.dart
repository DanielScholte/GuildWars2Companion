import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:guildwars2_companion/blocs/configuration/configuration_bloc.dart';
import 'package:guildwars2_companion/blocs/notification/notification_bloc.dart';
import 'package:guildwars2_companion/models/other/configuration.dart';
import 'package:guildwars2_companion/models/other/meta_event.dart';
import 'package:guildwars2_companion/pages/general/event/schedule_notification_type.dart';
import 'package:guildwars2_companion/utils/urls.dart';

class CompanionHeader extends StatelessWidget {

  final Color color;
  final Color foregroundColor;
  final Widget child;
  final bool includeBack;
  final String wikiName;
  final bool wikiRequiresEnglish;
  final bool includeShadow;
  final bool enforceColor;
  final bool isFavorite;
  final VoidCallback onFavoriteToggle;
  final MetaEventSegment eventSegment;

  CompanionHeader({
    @required this.child,
    this.color = Colors.red,
    this.foregroundColor = Colors.white,
    this.includeBack = false,
    this.includeShadow = true,
    this.wikiName,
    this.wikiRequiresEnglish = false,
    this.enforceColor = false,
    this.isFavorite,
    this.onFavoriteToggle,
    this.eventSegment,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Theme.of(context).brightness == Brightness.light || enforceColor ? color : Theme.of(context).cardColor,
        boxShadow: [
          if (includeShadow && Theme.of(context).brightness == Brightness.light)
            BoxShadow(
              color: Colors.black38,
              blurRadius: 6.0,
            ),
        ],
      ),
      width: double.infinity,
      child: Stack(
        alignment: Alignment.topCenter,
        children: <Widget>[
          if (includeBack)
            SafeArea(
              child: Align(
                alignment: Alignment.topLeft,
                child: Padding(
                  padding: EdgeInsets.all(4.0),
                  child: Material(
                    color: Colors.transparent,
                    child: BackButton(
                      color: foregroundColor,
                    ),
                  ),
                ),
              ),
            ),
          if (wikiName != null || isFavorite != null)
            SafeArea(
              child: Align(
                alignment: Alignment.topRight,
                child: Padding(
                  padding: EdgeInsets.all(4.0),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: <Widget>[
                      if (isFavorite != null)
                        _buildFavorite(isFavorite),
                      if (eventSegment != null)
                        _buildNotification(context),
                      if (wikiName != null)
                        _buildWiki(),
                    ],
                  ),
                ),
              ),
            ),
          SafeArea(
            bottom: false,
            child: Padding(
              padding: EdgeInsets.only(left: 16.0, right: 16.0, bottom: 16.0, top: 14.0),
              child: child,
            )
          ),
        ],
      )
    );
  }

  Widget _buildFavorite(bool favorite) {
    return Material(
      color: Colors.transparent,
      child: IconButton(
        icon: Icon(
          favorite ? Icons.star : Icons.star_border,
          color: foregroundColor,
          size: 28.0,
        ),
        onPressed: () => onFavoriteToggle(),
      ),
    );
  }

  Widget _buildNotification(BuildContext context) {
    return BlocBuilder<NotificationBloc, NotificationState>(
      builder: (context, state) {
        if (state is ScheduledNotificationsState) {
          return Material(
            color: Colors.transparent,
            child: IconButton(
              icon: Icon(
                state.scheduledNotifications.any((n) => n.eventId == eventSegment.id)
                ? FontAwesomeIcons.solidBell
                : FontAwesomeIcons.bell,
                color: foregroundColor,
                size: 20.0,
              ),
              onPressed: () => Navigator.of(context).push(MaterialPageRoute(
                builder: (context) => ScheduleNotificationTypePage(
                  segment: eventSegment,
                )
              )),
            ),
          );
        }

        return Container();
      }
    );
  }

  Widget _buildWiki() {
    return BlocBuilder<ConfigurationBloc, ConfigurationState>(
      builder: (context, state) {
        final Configuration configuration = (state as LoadedConfiguration).configuration;

        if (wikiRequiresEnglish && configuration.language != 'en') {
          return Container();
        }

        if (!['en', 'es', 'de', 'fr'].contains(configuration.language)) {
          return Container();
        }

        return Material(
          color: Colors.transparent,
          child: IconButton(
            icon: Icon(
              FontAwesomeIcons.wikipediaW,
              color: foregroundColor,
              size: 20.0,
            ),
            onPressed: () => Urls.launchUrl('${_getWikiUrl(configuration.language)}${wikiName.replaceAll(' ', '+')}'),
          ),
        );
      }
    );
  }

  String _getWikiUrl(String language) {
    switch (language) {
      case 'fr':
        return Urls.wikiFrenchUrl;
      case 'de':
        return Urls.wikiGermanUrl;
      case 'es':
        return Urls.wikiSpanishUrl;
      default:
        return Urls.wikiEnglishUrl;
    }
  }
}