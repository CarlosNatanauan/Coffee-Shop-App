import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../providers/drink_addons_provider.dart';
import 'widgets/addon_floating_edit_add_widget.dart';

class AddOnsScreen extends ConsumerStatefulWidget {
  @override
  _AddOnsScreenState createState() => _AddOnsScreenState();
}

class _AddOnsScreenState extends ConsumerState<AddOnsScreen> {
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
    ref.read(drinkAddOnProvider.notifier).fetchAddOns();
  }

  @override
  Widget build(BuildContext context) {
    final addOns = ref.watch(drinkAddOnProvider);
    double screenHeight = MediaQuery.of(context).size.height;
    double buttonHeight = screenHeight * 0.07;

    return Scaffold(
      appBar: AppBar(
        title: Text("Add-Ons"),
        leading: BackButton(
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: Stack(
        children: [
          Column(
            children: [
              Expanded(
                child: ListView.builder(
                  itemCount: addOns.length,
                  itemBuilder: (context, index) {
                    final addOn = addOns[index];
                    return ListTile(
                      title: Text(addOn.addonsName),
                      subtitle: Text("Price: \$${addOn.addonsPrice}"),
                      leading: Checkbox(
                        value: addOn.selected,
                        onChanged: (bool? selected) {
                          // Toggle the selected state
                          ref.read(drinkAddOnProvider.notifier).updateAddOn(
                                addOn.documentId,
                                addOn.addonsName,
                                addOn.addonsPrice,
                              );
                          ref.read(drinkAddOnProvider.notifier).state = ref
                              .read(drinkAddOnProvider)
                              .map((item) => item.documentId == addOn.documentId
                                  ? item.copyWith(selected: selected ?? false)
                                  : item)
                              .toList();
                        },
                      ),
                      trailing: IconButton(
                        icon: Icon(Icons.edit),
                        onPressed: () => showFloatingWidget(
                            mode: "Update", documentId: addOn.documentId),
                      ),
                    );
                  },
                ),
              ),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 20),
                height: buttonHeight,
                child: Row(
                  children: [
                    Expanded(
                      child: ElevatedButton(
                        onPressed: addOns.any((item) => item.selected)
                            ? () async {
                                final selectedAddOns = addOns
                                    .where((item) => item.selected)
                                    .toList();
                                for (var addOn in selectedAddOns) {
                                  await ref
                                      .read(drinkAddOnProvider.notifier)
                                      .deleteAddOn(addOn.documentId);
                                }
                              }
                            : null,
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
            ],
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
              child: FloatingEditAddWidgetAddOn(
                mode: floatingWidgetMode,
                initialName: editDocumentId != null
                    ? addOns
                        .firstWhere(
                            (addOn) => addOn.documentId == editDocumentId)
                        .addonsName
                    : "",
                initialPrice: editDocumentId != null
                    ? addOns
                        .firstWhere(
                            (addOn) => addOn.documentId == editDocumentId)
                        .addonsPrice
                    : 0,
                onCancel: hideFloatingWidget,
                onSave: (newName, newPrice) async {
                  if (floatingWidgetMode == "Add") {
                    await ref
                        .read(drinkAddOnProvider.notifier)
                        .addAddOn(newName, newPrice);
                  } else if (floatingWidgetMode == "Update" &&
                      editDocumentId != null) {
                    await ref
                        .read(drinkAddOnProvider.notifier)
                        .updateAddOn(editDocumentId!, newName, newPrice);
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
