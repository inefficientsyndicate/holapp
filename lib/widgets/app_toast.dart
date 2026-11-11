import 'package:flutter/material.dart';

/// Matches the height of the pinned "add item" bar (16+16 padding plus the
/// input's own height), so a floating toast sits just above it instead of
/// covering it.
const double _inputBarHeight = 76;

/// Shows a toast (SnackBar). When [aboveInputBar] is true (the default),
/// it floats above a pinned bottom input bar instead of covering it.
void showAppToast(
  BuildContext context,
  String message, {
  bool aboveInputBar = true,
}) {
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      content: Text(message),
      behavior: aboveInputBar ? SnackBarBehavior.floating : null,
      margin: aboveInputBar
          ? const EdgeInsets.fromLTRB(16, 0, 16, _inputBarHeight)
          : null,
    ),
  );
}
