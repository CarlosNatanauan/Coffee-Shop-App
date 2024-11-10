import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';
import '../../../models/foods/item/food_item_model.dart';
import '../../../models/foods/food_category_model.dart';
import '../../../models/foods/item/food_image_model.dart';
import '../../../models/foods/food_addons_models.dart';
import '../../../providers/foods/food_item_provider.dart';
import '../../../providers/foods/food_category_provider.dart';
import '../../../providers/foods/food_addons_provider.dart';
import '../../../services/api_services.dart';

class AddEditFoodItem extends ConsumerStatefulWidget {
  final FoodItem? foodItem;

  AddEditFoodItem({this.foodItem});

  @override
  ConsumerState<AddEditFoodItem> createState() => _AddEditFoodItemState();
}

class _AddEditFoodItemState extends ConsumerState<AddEditFoodItem> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  final TextEditingController _priceController = TextEditingController();
  bool _addOnsEnabled = false;
  XFile? _selectedImage;
  String? _imageUrl;
  String? _selectedCategory;
  List<String> _selectedAddOns = [];
  final ImagePicker _picker = ImagePicker();
  final ApiService apiService = ApiService();
  static const String strapiBaseUrl = 'http://192.168.0.111:1337';

  @override
  void initState() {
    super.initState();
    if (widget.foodItem != null) {
      _nameController.text = widget.foodItem!.foodName;
      _descriptionController.text = widget.foodItem!.foodDescription;
      _priceController.text = widget.foodItem!.foodPrice.toString();
      _addOnsEnabled = widget.foodItem!.addOnsEnabled;
      _selectedCategory = widget.foodItem!.foodCategory.id.toString();
      _selectedAddOns =
          widget.foodItem!.foodAddOns.map((e) => e.id.toString()).toList();
      if (widget.foodItem!.foodImages.isNotEmpty) {
        _imageUrl =
            '$strapiBaseUrl${widget.foodItem!.foodImages[0].originalUrl}';
      }
    }

    // Fetch categories and add-ons after setting initial values
    Future.microtask(() async {
      await ref.read(foodCategoryProvider.notifier).fetchCategories();
      await ref.read(foodAddOnProvider.notifier).fetchAddOns();

      setState(() {
        _selectedCategory ??= ref.read(foodCategoryProvider).isNotEmpty
            ? ref.read(foodCategoryProvider).first.id.toString()
            : null;
        if (_selectedAddOns.isEmpty && ref.read(foodAddOnProvider).isNotEmpty) {
          _selectedAddOns = [ref.read(foodAddOnProvider).first.id.toString()];
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

  Future<void> _submitForm() async {
    if (_formKey.currentState!.validate()) {
      int? imageId;
      if (_selectedImage != null) {
        imageId = await _uploadImage(_selectedImage!);
        if (imageId == null) {
          print("Image upload failed");
          return;
        }
      }

      final foodItemData = FoodItem(
        id: widget.foodItem?.id ?? 0,
        documentId: widget.foodItem?.documentId ?? '',
        addOnsEnabled: _addOnsEnabled,
        foodName: _nameController.text,
        foodDescription: _descriptionController.text,
        foodCategory: FoodCategory(
          id: int.parse(_selectedCategory!),
          documentId: '',
          categoryName: '',
        ),
        foodAddOns: _selectedAddOns
            .map((id) => FoodAddOn(
                id: int.parse(id),
                documentId: '',
                addonsName: '',
                addonsPrice: 0))
            .toList(),
        foodPrice:
            double.tryParse(_priceController.text) ?? 0.0, // Parsing as double
        foodImages: imageId != null
            ? [FoodImage(id: imageId, documentId: '', originalUrl: '')]
            : widget.foodItem?.foodImages ?? [],
      );

      try {
        if (widget.foodItem == null) {
          await ref.read(foodItemProvider.notifier).addFoodItem(foodItemData);
        } else {
          await ref.read(foodItemProvider.notifier).updateFoodItem(
              widget.foodItem!.documentId, foodItemData.toJson(isUpdate: true));
        }
        Navigator.pop(context);
      } catch (e) {
        print("Failed to save food item: $e");
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
              widget.foodItem == null ? 'Add Food Item' : 'Edit Food Item'),
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
                              child: Text("Set Image of Food",
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
                      // Food Name Text Field
                      TextFormField(
                        controller: _nameController,
                        decoration: InputDecoration(
                          labelText: 'Food Name',
                          border: OutlineInputBorder(),
                          contentPadding: EdgeInsets.symmetric(
                              vertical: 10, horizontal: 15),
                        ),
                        validator: (value) =>
                            value!.isEmpty ? 'Enter a food name' : null,
                      ),
                      SizedBox(height: 10),
                      // Food Description Text Field
                      TextFormField(
                        controller: _descriptionController,
                        decoration: InputDecoration(
                          labelText: 'Food Description',
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
                          final categories = ref.watch(foodCategoryProvider);
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
                            final addOns = ref.watch(foodAddOnProvider);
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
                      // Food Price Text Field
                      Text("Set Price of Food",
                          style: TextStyle(
                              fontWeight: FontWeight.w400, fontSize: 11)),
                      SizedBox(height: 5),
                      TextFormField(
                        controller: _priceController,
                        decoration: InputDecoration(
                          labelText: 'Price',
                          border: OutlineInputBorder(),
                          contentPadding: EdgeInsets.symmetric(
                              vertical: 8.0, horizontal: 12.0),
                        ),
                        keyboardType: TextInputType.number,
                        validator: (value) => value == null || value.isEmpty
                            ? 'Enter a price'
                            : null,
                      ),
                    ],
                  ),
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  ElevatedButton(
                    onPressed: _submitForm,
                    child: Text('Save Food Item'),
                  ),
                ],
              ),
            ],
          ),
        ));
  }
}
