import 'package:go_router/go_router.dart';
import 'package:holapp/domain/models/entity/id.dart';
import 'package:holapp/domain/models/groceries/list/groceries_list_id.dart';
import 'package:holapp/ui/features/groceries/detail/wrapper/view/wrapper_page.dart';
import 'package:holapp/ui/features/groceries/overview/groceries_lists_overview.dart';
import 'package:holapp/ui/features/settings/settings_view.dart';

class SettingsArgs {
  final String from;

  SettingsArgs({required this.from});
}

class PathParameterNotFoundException implements Exception {
  final String path;
  final String parameter;

  @override
  String toString() => '';

  PathParameterNotFoundException({required this.path, required this.parameter});
}

final GoRouter router = GoRouter(
  routes: [
    GoRoute(
      path: Routes.overview,
      builder: (context, state) => GroceriesListsOverview(),
    ),
    GoRoute(
      path: Routes.detail,
      builder: (context, state) {
        const String parameter = 'id';

        final pathId =
            state.pathParameters[parameter] ??
            (throw PathParameterNotFoundException(
              path: Routes.detail,
              parameter: parameter,
            ));

        return GroceriesListWrapperPage(id: GroceriesListId(value: pathId));
      },
    ),
    GoRoute(
      path: Routes.settings,
      builder: (context, state) {
        return SettingsView();
      },
    ),
  ],
);

class Routes {
  Routes._(); // private constructor to prevent instantiation

  static const String overview = '/';
  static const String detail = '/detail/:id';
  static const String settings = '/settings';

  static String detailId(Id id) {
    return "/detail/$id";
  }
}
