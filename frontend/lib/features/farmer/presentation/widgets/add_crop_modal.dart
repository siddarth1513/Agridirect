import 'package:flutter/material.dart';

class AddCropModal extends StatefulWidget {
  final Map<String, dynamic>? initialCrop;

  const AddCropModal({super.key, this.initialCrop});

  @override
  State<AddCropModal> createState() => _AddCropModalState();
}

class _AddCropModalState extends State<AddCropModal> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _nameController;
  late TextEditingController _priceController;
  late TextEditingController _qtyController;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.initialCrop?['name'] ?? '');
    _priceController = TextEditingController(
      text: widget.initialCrop != null
          ? (widget.initialCrop!['price'] as String).replaceAll(RegExp(r'[^0-9]'), '')
          : '',
    );
    _qtyController = TextEditingController(
      text: widget.initialCrop != null
          ? (widget.initialCrop!['qty'] as String).replaceAll(RegExp(r'[^0-9]'), '')
          : '',
    );
  }

  @override
  void dispose() {
    _nameController.dispose();
    _priceController.dispose();
    _qtyController.dispose();
    super.dispose();
  }

  void _save() {
    if (_formKey.currentState!.validate()) {
      Navigator.of(context).pop({
        'name': _nameController.text.trim(),
        'price': '₹${_priceController.text.trim()} / kg',
        'qty': '${_qtyController.text.trim()} kg left',
        'status': int.parse(_qtyController.text.trim()) < 150 ? 'Low Stock' : 'Active',
        'color': int.parse(_qtyController.text.trim()) < 150 ? Colors.orange : Colors.green,
        'imageUrl': widget.initialCrop?['imageUrl'] ??
            'https://images.unsplash.com/photo-1592924357228-91a4daadcfea?auto=format&fit=crop&w=800&q=80',
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isEditing = widget.initialCrop != null;

    return Padding(
      padding: EdgeInsets.only(
        bottom: MediaQuery.of(context).viewInsets.bottom,
      ),
      child: Container(
        padding: const EdgeInsets.all(24.0),
        decoration: BoxDecoration(
          color: theme.dialogBackgroundColor,
          borderRadius: const BorderRadius.vertical(top: Radius.circular(28)),
        ),
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    isEditing ? 'Edit Crop Listing' : 'Add New Crop Listing',
                    style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
                  ),
                  IconButton(
                    onPressed: () => Navigator.of(context).pop(),
                    icon: const Icon(Icons.close_rounded),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _nameController,
                decoration: const InputDecoration(
                  labelText: 'Crop Name',
                  hintText: 'e.g. Organic Tomatoes',
                  prefixIcon: Icon(Icons.grass_rounded),
                ),
                validator: (val) => val == null || val.isEmpty ? 'Please enter crop name' : null,
              ),
              const SizedBox(height: 14),
              Row(
                children: [
                  Expanded(
                    child: TextFormField(
                      controller: _priceController,
                      keyboardType: TextInputType.number,
                      decoration: const InputDecoration(
                        labelText: 'Price (₹ / kg)',
                        hintText: '40',
                        prefixIcon: Icon(Icons.currency_rupee_rounded),
                      ),
                      validator: (val) => val == null || val.isEmpty ? 'Enter price' : null,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: TextFormField(
                      controller: _qtyController,
                      keyboardType: TextInputType.number,
                      decoration: const InputDecoration(
                        labelText: 'Available Quantity (kg)',
                        hintText: '500',
                        prefixIcon: Icon(Icons.inventory_rounded),
                      ),
                      validator: (val) => val == null || val.isEmpty ? 'Enter qty' : null,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 24),
              ElevatedButton(
                onPressed: _save,
                style: ElevatedButton.styleFrom(
                  minimumSize: const Size(double.infinity, 50),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                ),
                child: Text(
                  isEditing ? 'Save Changes' : 'Publish Crop Listing',
                  style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
