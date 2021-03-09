import 'package:flutter/widgets.dart';
import 'package:guildwars2_companion/features/account/services/permission.dart';

class PermissionRepository {
  final PermissionService permissionService;

  PermissionRepository({
    @required this.permissionService
  });

  void loadBlocsWithPermissions({
    @required BuildContext context,
    @required List<String> permissions
  }) => permissionService.loadBlocsWithPermissions(context, permissions);
}