// providers.dart
import 'package:flutter_riverpod/flutter_riverpod.dart';

// Shared refresh provider
final refreshProvider = StateProvider<bool>((ref) => false);
