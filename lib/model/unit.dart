import 'package:meta/meta.dart';

class Unit {
  final String name;
  final double conversion;

  Unit({@required this.name, @required this.conversion});

  Unit.fromJson(Map jsonMap)
      : assert(jsonMap != null),
        assert(jsonMap['name'] != null),
        assert(jsonMap['conversion'] != null),
        name = jsonMap['name'],
        conversion = jsonMap['conversion'].toDouble();
}
