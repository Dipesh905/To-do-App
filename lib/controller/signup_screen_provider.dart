import 'package:flutter_riverpod/flutter_riverpod.dart';

/// obsecureValueProvider
final StateProvider<bool> obsecureValueProvider = StateProvider<bool>(
  (StateProviderRef<bool> ref) => true,
);

/// obsecureValueProvider
final StateProvider<bool> confirmPasswordObsecureProvider = StateProvider<bool>(
  (StateProviderRef<bool> ref) => true,
);