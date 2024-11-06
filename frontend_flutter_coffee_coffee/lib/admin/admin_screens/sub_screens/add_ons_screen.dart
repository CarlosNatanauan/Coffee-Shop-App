import 'package:flutter/material.dart';
import '../sub_screens/widgets/addon_floating_edit_add_widget.dart'; // Import the specific floating widget for add-ons

class AddOnsScreen extends StatefulWidget {
  @override
  _AddOnsScreenState createState() => _AddOnsScreenState();
}

class _AddOnsScreenState extends State<AddOnsScreen> {
  List<Map<String, dynamic>> addOns = [
    {"addons_name": "Extra Shot", "addons_price": 20, "selected": false},
    {"addons_name": "Soy Milk", "addons_price": 15, "selected": false},
  ]; // Placeholder data for add-ons

  bool isFloatingWidgetVisible = false;
  String floatingWidgetMode = "Add"; // "Add" or "Update"
  int? editIndex;

  void showFloatingWidget({String mode = "Add", int? index}) {
    setState(() {
      floatingWidgetMode = mode;
      isFloatingWidgetVisible = true;
      editIndex = index;
    });
  }

  void hideFloatingWidget() {
    setState(() {
      isFloatingWidgetVisible = false;
    });
  }

  void toggleSelection(int index, bool? isSelected) {
    setState(() {
      addOns[index]["selected"] = isSelected ?? false;
    });
  }

  @override
  Widget build(BuildContext context) {
    double screenHeight = MediaQuery.of(context).size.height;
    double buttonHeight = screenHeight * 0.07;

    return Scaffold(
      appBar: AppBar(
        title: Text("Add Ons"),
        leading: BackButton(
          onPressed: () =>
              Navigator.pop(context), // Goes back to AdminDrinksScreen
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
                    return ListTile(
                      title: Text(addOns[index]["addons_name"]),
                      subtitle:
                          Text("Price: \$${addOns[index]["addons_price"]}"),
                      leading: Checkbox(
                        value: addOns[index]["selected"],
                        onChanged: (bool? selected) =>
                            toggleSelection(index, selected),
                      ),
                      trailing: IconButton(
                        icon: Icon(Icons.edit),
                        onPressed: () =>
                            showFloatingWidget(mode: "Update", index: index),
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
                        onPressed: addOns.any((item) => item["selected"])
                            ? () {
                                setState(() {
                                  addOns
                                      .removeWhere((item) => item["selected"]);
                                });
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
                  color: Colors.black54, // Darkened background
                ),
              ),
            ),
          if (isFloatingWidgetVisible)
            Center(
              child: FloatingEditAddWidgetAddOn(
                mode: floatingWidgetMode,
                initialName:
                    editIndex != null ? addOns[editIndex!]["addons_name"] : "",
                initialPrice:
                    editIndex != null ? addOns[editIndex!]["addons_price"] : 0,
                onCancel: hideFloatingWidget,
                onSave: (newName, newPrice) {
                  setState(() {
                    if (floatingWidgetMode == "Add") {
                      addOns.add({
                        "addons_name": newName,
                        "addons_price": newPrice,
                        "selected": false
                      });
                    } else if (floatingWidgetMode == "Update" &&
                        editIndex != null) {
                      addOns[editIndex!] = {
                        "addons_name": newName,
                        "addons_price": newPrice,
                        "selected": false
                      };
                    }
                    hideFloatingWidget();
                  });
                },
              ),
            ),
        ],
      ),
    );
  }
}
