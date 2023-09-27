import 'package:flutter_riverpod/flutter_riverpod.dart';

final todoStatusProvider = StateProvider<String>(
  (ref) => 'not_started',
);
