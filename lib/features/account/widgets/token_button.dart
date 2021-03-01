import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:guildwars2_companion/features/account/bloc/bloc.dart';
import 'package:guildwars2_companion/features/account/models/token_entry.dart';
import 'package:guildwars2_companion/features/account/widgets/dismissible_button.dart';
import 'package:intl/intl.dart';

class AccountTokenButton extends StatelessWidget {
  final TokenEntry token;

  AccountTokenButton({@required this.token});

  @override
  Widget build(BuildContext context) {
    DateTime added = DateTime.tryParse(token.date);

    return DismissibleButton(
      key: ValueKey(token.id),
      onDismissed: () => BlocProvider.of<AccountBloc>(context).add(RemoveTokenEvent(token.id)),
      color: Colors.blue,
      leading: Icon(
        FontAwesomeIcons.key,
        color: Colors.white,
      ),
      title: token.name,
      subtitles: added != null ? [
        'Added: ${DateFormat('yyyy-MM-dd').format(added)}'
      ] : null,
      onTap: () => BlocProvider.of<AccountBloc>(context).add(AuthenticateEvent(token.token)),
    );
  }
}