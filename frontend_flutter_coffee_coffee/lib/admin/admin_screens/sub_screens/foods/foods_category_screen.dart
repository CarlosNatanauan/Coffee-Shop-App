import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../providers/foods/food_category_provider.dart';
import '../widgets/category_floating_edit_add_widget.dart';

class FoodsCategoryScreen extends ConsumerStatefulWidget {
  @override
  _CategoryScreenState createState() => _CategoryScreenState();
}

class _CategoryScreenState extends ConsumerState<FoodsCategoryScreen> {
  bool isFloatingWidgetVisible = false;
  String floatingWidgetMode = "Add"; // "Add" or "Update"
  String? editDocumentId;

  void showFloatingWidget({String mode = "Add", String? documentId}) {
    setState(() {
      floatingWidgetMode = mode;
      isFloatingWidgetVisible = true;
      editDocumentId = documentId;
    });
  }

  void hideFloatingWidget() {
    setState(() {
      isFloatingWidgetVisible = false;
    });
  }

  @override
  void initState() {
    super.initState();
    ref.read(foodCategoryProvider.notifier).fetchCategories();
  }

  @override
  Widget build(BuildContext context) {
    final categories = ref.watch(foodCategoryProvider);

    return Scaffold(
      appBar: AppBar(
        title: Text("Food Category"),
        leading: BackButton(
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: Stack(
        children: [
          Padding(
            padding: const EdgeInsets.only(bottom: 70.0), // Space for buttons
            child: ListView.builder(
              itemCount: categories.length,
              itemBuilder: (context, index) {
                final category = categories[index];
                return ListTile(
                  title: Text(category.categoryName),
                  leading: Checkbox(
                    value: category.selected,
                    onChanged: (bool? selected) {
                      setState(() {
                        categories[index] = categories[index].copyWith(
                          selected: selected ?? false,
                        );
                      });
                    },
                  ),
                  trailing: IconButton(
                    icon: Icon(Icons.edit),
                    onPressed: () => showFloatingWidget(
                        mode: "Update", documentId: category.documentId),
                  ),
                );
              },
            ),
          ),
          Align(
            alignment: Alignment.bottomCenter,
            child: Container(
              color: Colors.white,
              padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
              child: Row(
                children: [
                  Expanded(
                    child: ElevatedButton(
                      onPressed: categories.any((item) => item.selected)
                          ? () async {
                              final selectedCategories = categories
                                  .where((item) => item.selected)
                                  .toList();
                              for (var category in selectedCategories) {
                                await ref
                                    .read(foodCategoryProvider.notifier)
                                    .deleteCategory(category.documentId);
                              }
                            }
                          : null,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: categories.any((item) => item.selected)
                            ? Colors.red
                            : Colors.grey,
                      ),
                      child: Text("Delete"),
                    ),
                  ),
                  SizedBox(width: 10),
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () => showFloatingWidget(mode: "Add"),
                      child: Text("Add"),
                    ),
                  ),
                ],
              ),
            ),
          ),
          if (isFloatingWidgetVisible)
            Positioned.fill(
              child: GestureDetector(
                onTap: hideFloatingWidget,
                child: Container(
                  color: Colors.black54,
                ),
              ),
            ),
          if (isFloatingWidgetVisible)
            Center(
              child: FloatingEditAddWidget(
                mode: floatingWidgetMode,
                initialValue: editDocumentId != null
                    ? categories
                        .firstWhere((cat) => cat.documentId == editDocumentId)
                        .categoryName
                    : "",
                onCancel: hideFloatingWidget,
                onSave: (newValue) async {
                  if (floatingWidgetMode == "Add") {
                    await ref
                        .read(foodCategoryProvider.notifier)
                        .addCategory(newValue);
                  } else if (floatingWidgetMode == "Update" &&
                      editDocumentId != null) {
                    await ref
                        .read(foodCategoryProvider.notifier)
                        .updateCategory(editDocumentId!, newValue);
                  }
                  hideFloatingWidget();
                },
              ),
            ),
        ],
      ),
    );
  }
}
