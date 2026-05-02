import 'package:uuid/uuid.dart';

abstract class Id {
  static final _uuid = Uuid();
  static String empty() => _uuid.v4();

  late String value;

  Id({required this.value});

  @override
  String toString() => value;
}
