import 'package:shadcn_flutter/shadcn_flutter.dart';

class Config {
  Config._(); // private constructor to prevent instantiation

  static const debounceDuration = Duration(milliseconds: 123);

  static const double _inset = 8;

  static const insetLeftRightBottom = EdgeInsets.only(
    left: _inset,
    right: _inset,
    bottom: _inset,
  );
}
