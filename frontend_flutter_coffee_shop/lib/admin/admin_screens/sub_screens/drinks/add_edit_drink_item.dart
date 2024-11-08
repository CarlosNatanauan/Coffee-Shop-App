import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';
import '../../../models/drinks/item/drink_item_model.dart';
import '../../../models/drinks/item/drin_size_option.model.dart';
import '../../../models/drinks/drink_category_model.dart';
import '../../../models/drinks/item/drink_image_model.dart';
import '../../../models/drinks/drink_addons_model.dart';
import '../../../providers/drinks/drink_item_provider.dart';
import '../../../providers/drinks/drink_category_provider.dart';
import '../../../providers/drinks/drink_addons_provider.dart';
import '../../../services/api_services.dart';

class AddEditDrinkItem extends ConsumerStatefulWidget {
  final DrinkItem? drinkItem;

  AddEditDrinkItem({this.drinkItem});

  @override
  ConsumerState<AddEditDrinkItem> createState() => _AddEditDrinkItemState();
}

class _AddEditDrinkItemState extends ConsumerState<AddEditDrinkItem> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  bool _addOnsEnabled = false;
  XFile? _selectedImage;
  String? _imageUrl;
  String? _selectedCategory;
  List<String> _selectedAddOns = [];
  List<SizeOption> _sizeOptions = [];
  final ImagePicker _picker = ImagePicker();
  final ApiService apiService = ApiService();
  static const String strapiBaseUrl = 'http://192.168.0.111:1337';

  @override
  void initState() {
    super.initState();
    if (widget.drinkItem != null) {
      _nameController.text = widget.drinkItem!.drinkName;
      _descriptionController.text = widget.drinkItem!.drinkDescription;
      _addOnsEnabled = widget.drinkItem!.addOnsEnabled;
      _selectedCategory = widget.drinkItem!.drinkCategory.id.toString();
      _selectedAddOns =
          widget.drinkItem!.drinkAddOns.map((e) => e.id.toString()).toList();
      _sizeOptions = widget.drinkItem!.sizeOptions;
      if (widget.drinkItem!.drinkImages.isNotEmpty) {
        _imageUrl =
            '$strapiBaseUrl${widget.drinkItem!.drinkImages[0].originalUrl}';
      }
    }

    // Set default size option if none are available
    if (_sizeOptions.isEmpty) {
      _addSizeOption();
    }

    // Fetch categories and add-ons after setting initial values
    Future.microtask(() async {
      await ref.read(drinkCategoryProvider.notifier).fetchCategories();
      await ref.read(drinkAddOnProvider.notifier).fetchAddOns();

      setState(() {
        _selectedCategory ??= ref.read(drinkCategoryProvider).isNotEmpty
            ? ref.read(drinkCategoryProvider).first.id.toString()
            : null;
        if (_selectedAddOns.isEmpty &&
            ref.read(drinkAddOnProvider).isNotEmpty) {
          _selectedAddOns = [ref.read(drinkAddOnProvider).first.id.toString()];
        }
      });
    });
  }

  Future<void> _pickImage() async {
    try {
      final pickedFile = await _picker.pickImage(source: ImageSource.gallery);
      setState(() {
        _selectedImage = pickedFile;
        _imageUrl = null; // Clear the existing URL when a new image is selected
      });
    } catch (e) {
      print("Image picker error: $e");
    }
  }

  Future<int?> _uploadImage(XFile imageFile) async {
    final file = File(imageFile.path);
    return await apiService.uploadMediaFile(file);
  }

  void _addSizeOption() {
    setState(() {
      _sizeOptions.add(SizeOption(id: 0, drinkSize: 'Size', drinkPrice: 0));
    });
  }

  void _removeSizeOption(int index) {
    setState(() {
      _sizeOptions.removeAt(index);
    });
  }

  Future<void> _submitForm() async {
    if (_formKey.currentState!.validate()) {
      // Check for size and price completeness
      if (_sizeOptions
          .any((size) => size.drinkSize.isEmpty || size.drinkPrice == 0)) {
        _showErrorDialog("Please fill out all size options with valid prices.");
        return;
      }

      int? imageId;
      if (_selectedImage != null) {
        imageId = await _uploadImage(_selectedImage!);
        if (imageId == null) {
          print("Image upload failed");
          return;
        }
      }

      final drinkItemData = DrinkItem(
        id: widget.drinkItem?.id ?? 0,
        documentId: widget.drinkItem?.documentId ?? '',
        addOnsEnabled: _addOnsEnabled,
        drinkName: _nameController.text,
        drinkDescription: _descriptionController.text,
        drinkCategory: DrinkCategory(
          id: int.parse(_selectedCategory!),
          documentId: '',
          categoryName: '',
        ),
        drinkAddOns: _selectedAddOns
            .map((id) => DrinkAddOn(
                id: int.parse(id),
                documentId: '',
                addonsName: '',
                addonsPrice: 0))
            .toList(),
        sizeOptions: _sizeOptions,
        drinkImages: imageId != null
            ? [DrinkImage(id: imageId, documentId: '', originalUrl: '')]
            : widget.drinkItem?.drinkImages ?? [],
      );

      try {
        if (widget.drinkItem == null) {
          await ref
              .read(drinkItemProvider.notifier)
              .addDrinkItem(drinkItemData);
        } else {
          await ref.read(drinkItemProvider.notifier).updateDrinkItem(
              widget.drinkItem!.documentId,
              drinkItemData.toJson(isUpdate: true));
        }
        Navigator.pop(context);
      } catch (e) {
        print("Failed to save drink item: $e");
      }
    }
  }

  void _showErrorDialog(String message) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text("Validation Error"),
          content: Text(message),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: Text("OK"),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(
              widget.drinkItem == null ? 'Add Drink Item' : 'Edit Drink Item'),
        ),
        body: Padding(
          padding: EdgeInsets.fromLTRB(16, 5, 16, 5),
          child: Column(
            children: [
              Expanded(
                child: Form(
                  key: _formKey,
                  child: ListView(
                    children: [
                      // Image Picker Section
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 8.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Center(
                              child: Text("Set Image of Drink",
                                  style: TextStyle(
                                      fontWeight: FontWeight.w400,
                                      fontSize: 11)),
                            ),
                            GestureDetector(
                              onTap: _pickImage,
                              child: Center(
                                child: Container(
                                  width: 100,
                                  height: 100,
                                  decoration: BoxDecoration(
                                    color: Colors.grey[200],
                                    borderRadius: BorderRadius.circular(8),
                                    border: Border.all(color: Colors.grey),
                                  ),
                                  child: _selectedImage == null &&
                                          _imageUrl != null
                                      ? ClipRRect(
                                          borderRadius:
                                              BorderRadius.circular(8),
                                          child: Image.network(
                                            _imageUrl!,
                                            width: 100,
                                            height: 100,
                                            fit: BoxFit.cover,
                                          ),
                                        )
                                      : _selectedImage != null
                                          ? ClipRRect(
                                              borderRadius:
                                                  BorderRadius.circular(8),
                                              child: Image.file(
                                                File(_selectedImage!.path),
                                                width: 150,
                                                height: 150,
                                                fit: BoxFit.cover,
                                              ),
                                            )
                                          : Icon(Icons.add_a_photo,
                                              color: Colors.grey[800],
                                              size: 20),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      // Drink Name Text Field
                      TextFormField(
                        controller: _nameController,
                        decoration: InputDecoration(
                          labelText: 'Drink Name',
                          border: OutlineInputBorder(),
                          contentPadding: EdgeInsets.symmetric(
                              vertical: 10, horizontal: 15),
                        ),
                        validator: (value) =>
                            value!.isEmpty ? 'Enter a drink name' : null,
                      ),
                      SizedBox(height: 10),
                      // Drink Description Text Field
                      TextFormField(
                        controller: _descriptionController,
                        decoration: InputDecoration(
                          labelText: 'Drink Description',
                          border: OutlineInputBorder(),
                          contentPadding: EdgeInsets.symmetric(
                              vertical: 10, horizontal: 15),
                        ),
                        validator: (value) =>
                            value!.isEmpty ? 'Enter a description' : null,
                      ),
                      SizedBox(height: 10),
                      // Category Dropdown
                      Consumer(
                        builder: (context, ref, child) {
                          final categories = ref.watch(drinkCategoryProvider);
                          return DropdownButtonFormField<String>(
                            value: _selectedCategory,
                            items: categories.map((category) {
                              return DropdownMenuItem(
                                value: category.id.toString(),
                                child: Text(category.categoryName),
                              );
                            }).toList(),
                            onChanged: (value) =>
                                setState(() => _selectedCategory = value),
                            decoration: InputDecoration(
                              labelText: 'Category',
                              border: OutlineInputBorder(),
                            ),
                            validator: (value) =>
                                value == null ? 'Select a category' : null,
                          );
                        },
                      ),
                      SizedBox(height: 10),
                      // Add Ons Enabled Switch
                      Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Text(
                            'Add Ons Enabled',
                            style: TextStyle(
                              fontSize: 16,
                            ),
                          ),
                          SizedBox(width: 8), // Space between text and switch
                          Switch(
                            value: _addOnsEnabled,
                            onChanged: (value) {
                              setState(() {
                                _addOnsEnabled = value;
                              });
                            },
                          ),
                        ],
                      ),
                      if (_addOnsEnabled)
                        Consumer(
                          builder: (context, ref, child) {
                            final addOns = ref.watch(drinkAddOnProvider);
                            return DropdownButtonFormField<String>(
                              value: _selectedAddOns.isNotEmpty
                                  ? _selectedAddOns.first
                                  : null,
                              items: addOns.map((addon) {
                                return DropdownMenuItem(
                                  value: addon.id.toString(),
                                  child: Text(addon.addonsName),
                                );
                              }).toList(),
                              onChanged: (value) {
                                if (value != null)
                                  setState(() => _selectedAddOns = [value]);
                              },
                              decoration: InputDecoration(
                                labelText: 'Select Add-On',
                                border: OutlineInputBorder(),
                              ),
                            );
                          },
                        ),
                      SizedBox(height: 10),
                      Text("Set size and price of the drink",
                          style: TextStyle(
                              fontWeight: FontWeight.w400, fontSize: 11)),
                      SizedBox(height: 5),
                      ..._sizeOptions.asMap().entries.map((entry) {
                        int index = entry.key;
                        SizeOption size = entry.value;

                        return Column(
                          children: [
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.end,
                              children: [
                                Expanded(
                                  child: TextFormField(
                                    initialValue: size.drinkSize,
                                    decoration: InputDecoration(
                                      labelText: 'Size',
                                      border: OutlineInputBorder(),
                                      contentPadding: EdgeInsets.symmetric(
                                          vertical: 8.0, horizontal: 12.0),
                                    ),
                                    onChanged: (value) => setState(() {
                                      _sizeOptions[index] = SizeOption(
                                        id: size.id,
                                        drinkSize: value,
                                        drinkPrice: size.drinkPrice,
                                      );
                                    }),
                                    validator: (value) =>
                                        value!.isEmpty ? 'Enter a size' : null,
                                  ),
                                ),
                                SizedBox(width: 10),
                                Expanded(
                                  child: TextFormField(
                                    initialValue: size.drinkPrice.toString(),
                                    decoration: InputDecoration(
                                      labelText: 'Price',
                                      border: OutlineInputBorder(),
                                      contentPadding: EdgeInsets.symmetric(
                                          vertical: 8.0, horizontal: 12.0),
                                    ),
                                    keyboardType: TextInputType.number,
                                    onChanged: (value) => setState(() {
                                      _sizeOptions[index] = SizeOption(
                                        id: size.id,
                                        drinkSize: size.drinkSize,
                                        drinkPrice: int.tryParse(value) ?? 0,
                                      );
                                    }),
                                    validator: (value) =>
                                        value == null || value.isEmpty
                                            ? 'Enter a price'
                                            : null,
                                  ),
                                ),
                                IconButton(
                                  icon: Icon(Icons.delete,
                                      color: Color.fromARGB(255, 134, 2, 2)),
                                  onPressed: () => _removeSizeOption(index),
                                ),
                              ],
                            ),
                            SizedBox(
                                height: 10), // Added space between size entries
                          ],
                        );
                      }).toList(),
                    ],
                  ),
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  ElevatedButton(
                    onPressed: _addSizeOption,
                    child: Text('Add Size Option'),
                  ),
                  ElevatedButton(
                    onPressed: _submitForm,
                    child: Text('Save Drink Item'),
                  ),
                ],
              ),
            ],
          ),
        ));
  }
}
