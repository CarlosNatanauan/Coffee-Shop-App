import 'package:flutter_riverpod/flutter_riverpod.dart';

// This provider stores the ID of the currently selected category
// `null` means no category is selected, which displays all items
final selectedDrinkCategoryProvider = StateProvider<int?>((ref) => null);
