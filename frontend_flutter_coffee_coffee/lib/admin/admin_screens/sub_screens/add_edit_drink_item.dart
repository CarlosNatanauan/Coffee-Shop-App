import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';
import '../../models/drinks/item/drink_item_model.dart';
import '../../models/drinks/item/drin_size_option.model.dart';
import '../../models/drinks/drink_category_model.dart';
import '../../models/drinks/item/drink_image_model.dart';
import '../../models/drinks/drink_addons_model.dart';
import '../../providers/drink_item_provider.dart';
import '../../providers/drink_category_provider.dart';
import '../../providers/drink_addons_provider.dart';
import '../../services/api_services.dart';

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
  String? _imageUrl; // Variable to store the URL of the existing image
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
            widget.drinkItem == null ? 'Add Drink Item' : 'Edit Drink Item'),
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              TextFormField(
                controller: _nameController,
                decoration: InputDecoration(labelText: 'Drink Name'),
                validator: (value) =>
                    value!.isEmpty ? 'Enter a drink name' : null,
              ),
              TextFormField(
                controller: _descriptionController,
                decoration: InputDecoration(labelText: 'Drink Description'),
                validator: (value) =>
                    value!.isEmpty ? 'Enter a description' : null,
              ),
              SwitchListTile(
                title: Text('Add Ons Enabled'),
                value: _addOnsEnabled,
                onChanged: (value) => setState(() => _addOnsEnabled = value),
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
                      decoration: InputDecoration(labelText: 'Select Add-On'),
                    );
                  },
                ),
              SizedBox(height: 16),
              GestureDetector(
                onTap: _pickImage,
                child: Center(
                  child: Container(
                    width: 150,
                    height: 150,
                    decoration: BoxDecoration(
                      color: Colors.grey[200],
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(color: Colors.grey),
                    ),
                    child: _selectedImage == null && _imageUrl != null
                        ? ClipRRect(
                            borderRadius: BorderRadius.circular(8),
                            child: Image.network(
                              _imageUrl!,
                              width: 150,
                              height: 150,
                              fit: BoxFit.cover,
                            ),
                          )
                        : _selectedImage != null
                            ? ClipRRect(
                                borderRadius: BorderRadius.circular(8),
                                child: Image.file(
                                  File(_selectedImage!.path),
                                  width: 150,
                                  height: 150,
                                  fit: BoxFit.cover,
                                ),
                              )
                            : Icon(Icons.add_a_photo,
                                color: Colors.grey[800], size: 20),
                  ),
                ),
              ),
              SizedBox(height: 16),
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
                    decoration: InputDecoration(labelText: 'Category'),
                  );
                },
              ),
              ElevatedButton(
                onPressed: _addSizeOption,
                child: Text('Add Size Option'),
              ),
              ..._sizeOptions.asMap().entries.map((entry) {
                int index = entry.key;
                SizeOption size = entry.value;
                return Row(
                  children: [
                    Expanded(
                      child: TextFormField(
                        initialValue: size.drinkSize,
                        decoration: InputDecoration(labelText: 'Size'),
                        onChanged: (value) => setState(() {
                          _sizeOptions[index] = SizeOption(
                            id: size.id,
                            drinkSize: value,
                            drinkPrice: size.drinkPrice,
                          );
                        }),
                      ),
                    ),
                    Expanded(
                      child: TextFormField(
                        initialValue: size.drinkPrice.toString(),
                        decoration: InputDecoration(labelText: 'Price'),
                        keyboardType: TextInputType.number,
                        onChanged: (value) => setState(() {
                          _sizeOptions[index] = SizeOption(
                            id: size.id,
                            drinkSize: size.drinkSize,
                            drinkPrice: int.tryParse(value) ?? 0,
                          );
                        }),
                      ),
                    ),
                    IconButton(
                      icon: Icon(Icons.remove),
                      onPressed: () => _removeSizeOption(index),
                    ),
                  ],
                );
              }).toList(),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: _submitForm,
                child: Text('Save Drink Item'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
