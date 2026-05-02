import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:holapp/domain/models/entity/id.dart';
import 'package:holapp/domain/models/groceries/list/groceries_list.dart';
import 'package:holapp/routing/hol_go_router.dart';
import 'package:holapp/ui/features/groceries/detail/disposable.dart';
import 'package:holapp/ui/features/groceries/detail/persistent.dart';
import 'package:holapp/ui/features/groceries/detail/wrapper/bloc/wrapper_state.dart';
import 'package:shadcn_flutter/shadcn_flutter_experimental.dart';

import '../bloc/wrapper_bloc.dart';
import '../bloc/wrapper_event.dart';

class GroceriesListWrapperPage extends StatelessWidget {
  final Id id;

  const GroceriesListWrapperPage({super.key, required this.id});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) =>
          GroceriesListWrapperBloc()..add(GetGroceriesListByIdEvent(id: id)),
      child: BlocBuilder<GroceriesListWrapperBloc, GroceriesListWrapperState>(
        builder: (context, state) {
          return Scaffold(
            child: switch (state) {
              Loading() => const Center(
                child: CircularProgressIndicator(size: 40),
              ),
              Finished() => loadingFinished(context, state.list),
            },
          );
        },
      ),
    );
  }

  Widget loadingFinished(BuildContext context, GroceriesList? list) {
    return switch (list) {
      null => Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Center(child: Text("List $id not found")),
          const SizedBox(height: 12),
          GhostButton(
            child: Text("Back to home"),
            onPressed: () => context.go(Routes.overview),
          ),
        ],
      ),
      DisposableGroceriesList() => DisposableGroceriesListDetail(list: list),
      PersistentGroceriesList() => PersistentGroceriesListDetail(list: list),
    };
  }
}
