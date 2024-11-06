import 'package:flutter/material.dart';

class FloatingEditAddWidget extends StatelessWidget {
  final String mode; // "Add" or "Update"
  final String initialValue;
  final VoidCallback onCancel;
  final ValueChanged<String> onSave;

  const FloatingEditAddWidget({
    required this.mode,
    required this.initialValue,
    required this.onCancel,
    required this.onSave,
  });

  @override
  Widget build(BuildContext context) {
    TextEditingController controller =
        TextEditingController(text: initialValue);

    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              "$mode Category",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 10),
            TextField(
              controller: controller,
              decoration: InputDecoration(labelText: "Category Name"),
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
                      onSave(controller.text);
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
