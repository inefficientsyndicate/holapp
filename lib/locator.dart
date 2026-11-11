import 'package:flutter_it/flutter_it.dart';

import 'manager/grocery_manager.dart';

void configureDependencies() {
  di.registerSingletonAsync<GroceryManager>(() => GroceryManager().init());
}
