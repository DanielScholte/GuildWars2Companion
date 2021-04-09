import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:guildwars2_companion/core/models/event_segment.dart';
import 'package:guildwars2_companion/core/utils/urls.dart';
import 'package:guildwars2_companion/core/widgets/content_elevation.dart';
import 'package:guildwars2_companion/features/configuration/bloc/configuration_bloc.dart';
import 'package:guildwars2_companion/features/event/bloc/notification_bloc.dart';
import 'package:guildwars2_companion/features/event/pages/schedule_notification_type.dart';

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
  final Function onFavoriteToggle;
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
    return CompanionContentElevation(
      radius: BorderRadius.zero,
      elevation: includeShadow ? 4.0 : 0,
      child: Container(
        color: Theme.of(context).brightness == Brightness.light || enforceColor ? color : Theme.of(context).cardColor,
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
                          _Favorite(
                            favorite: isFavorite,
                            foregroundColor: foregroundColor,
                            onFavoriteToggle: onFavoriteToggle,
                          ),
                        if (eventSegment != null)
                          _Notification(
                            eventSegment: eventSegment,
                            foregroundColor: foregroundColor,
                          ),
                        if (wikiName != null)
                          _Wiki(
                            wikiName: wikiName,
                            wikiRequiresEnglish: wikiRequiresEnglish,
                            foregroundColor: foregroundColor,
                          ),
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
      ),
    );
  }
}

class _Favorite extends StatelessWidget {
  final bool favorite;
  final Color foregroundColor;
  final Function onFavoriteToggle;

  _Favorite({
    @required this.favorite,
    @required this.foregroundColor,
    @required this.onFavoriteToggle,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: IconButton(
        icon: Icon(
          favorite ? Icons.star : Icons.star_border,
          color: foregroundColor,
          size: 28.0,
        ),
        onPressed: onFavoriteToggle,
      ),
    );
  }
}

class _Notification extends StatelessWidget {
  final MetaEventSegment eventSegment;
  final Color foregroundColor;

  _Notification({
    @required this.eventSegment,
    @required this.foregroundColor
  });

  @override
  Widget build(BuildContext context) {
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
}

class _Wiki extends StatelessWidget {
  final String wikiName;
  final bool wikiRequiresEnglish;
  final Color foregroundColor;

  _Wiki({
    @required this.wikiName,
    @required this.wikiRequiresEnglish,
    @required this.foregroundColor
  });

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ConfigurationBloc, ConfigurationState>(
      builder: (context, state) {
        if (wikiRequiresEnglish && state.configuration.language != 'en') {
          return Container();
        }

        if (!['en', 'es', 'de', 'fr'].contains(state.configuration.language)) {
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
            onPressed: () => Urls.launchUrl('${_getWikiUrl(state.configuration.language)}${wikiName.replaceAll(' ', '+')}'),
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