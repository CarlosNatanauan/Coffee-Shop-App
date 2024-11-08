import 'package:flutter/material.dart';

class FloatingEditAddWidgetAddOn extends StatelessWidget {
  final String mode; // "Add" or "Update"
  final String initialName;
  final int initialPrice;
  final VoidCallback onCancel;
  final Function(String, int) onSave;

  const FloatingEditAddWidgetAddOn({
    required this.mode,
    required this.initialName,
    required this.initialPrice,
    required this.onCancel,
    required this.onSave,
  });

  @override
  Widget build(BuildContext context) {
    TextEditingController nameController =
        TextEditingController(text: initialName);
    TextEditingController priceController =
        TextEditingController(text: initialPrice.toString());

    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              "$mode Add-On",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 10),
            TextField(
              controller: nameController,
              decoration: InputDecoration(labelText: "Add-On Name"),
            ),
            TextField(
              controller: priceController,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(labelText: "Price"),
            ),
            SizedBox(height: 20),
            Row(
              children: [
                Expanded(
                  child: TextButton(
                    onPressed: onCancel,
                    child: Text("Cancel"),
                  ),
                ),
                Expanded(
                  child: ElevatedButton(
                    onPressed: () {
                      int? price = int.tryParse(priceController.text);
                      if (price != null) {
                        onSave(nameController.text, price);
                      } else {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text("Please enter a valid price")),
                        );
                      }
                    },
                    child: Text("Save"),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
