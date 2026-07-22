import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../auth/presentation/providers/auth_provider.dart';
import '../providers/profile_provider.dart';

class ProfilePage extends ConsumerStatefulWidget {
  const ProfilePage({super.key});

  @override
  ConsumerState<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends ConsumerState<ProfilePage> {
  bool _isEditing = false;
  final _formKey = GlobalKey<FormState>();

  // Controllers
  late TextEditingController _farmNameController;
  late TextEditingController _farmAddressController;
  late TextEditingController _deliveryAddressController;

  @override
  void initState() {
    super.initState();
    _farmNameController = TextEditingController();
    _farmAddressController = TextEditingController();
    _deliveryAddressController = TextEditingController();
  }

  @override
  void dispose() {
    _farmNameController.dispose();
    _farmAddressController.dispose();
    _deliveryAddressController.dispose();
    super.dispose();
  }

  void _save(bool isFarmer) {
    if (_formKey.currentState!.validate()) {
      if (isFarmer) {
        ref.read(profileProvider.notifier).updateProfile(
              farmName: _farmNameController.text.trim(),
              farmAddress: _farmAddressController.text.trim(),
            );
      } else {
        ref.read(profileProvider.notifier).updateProfile(
              deliveryAddress: _deliveryAddressController.text.trim(),
            );
      }
      setState(() => _isEditing = false);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text('Profile updated successfully!'),
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
          backgroundColor: Theme.of(context).colorScheme.primary,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final profileState = ref.watch(profileProvider);
    final theme = Theme.of(context);

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      appBar: AppBar(
        title: const Text(
          'My Account',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout_rounded),
            tooltip: 'Logout',
            onPressed: () {
              ref.read(authProvider.notifier).logout();
            },
          ),
          const SizedBox(width: 8),
        ],
      ),
      body: profileState.when(
        data: (profile) {
          final isFarmer = profile.user.role == 'FARMER';

          if (!_isEditing) {
            _farmNameController.text = profile.farmName;
            _farmAddressController.text = profile.farmAddress;
            _deliveryAddressController.text = profile.deliveryAddress;
          }

          return SingleChildScrollView(
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  // Gradient Banner & Overlapping Avatar Header
                  Stack(
                    clipBehavior: Clip.none,
                    alignment: Alignment.center,
                    children: [
                      // Banner
                      Container(
                        height: 140,
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            colors: [
                              theme.colorScheme.primary,
                              theme.colorScheme.secondary,
                            ],
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                          ),
                          borderRadius: const BorderRadius.only(
                            bottomLeft: Radius.circular(24),
                            bottomRight: Radius.circular(24),
                          ),
                        ),
                      ),
                      // Avatar
                      Positioned(
                        bottom: -50,
                        child: Container(
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            border: Border.all(
                              color: theme.scaffoldBackgroundColor,
                              width: 5,
                            ),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.08),
                                blurRadius: 15,
                                offset: const Offset(0, 8),
                              ),
                            ],
                          ),
                          child: CircleAvatar(
                            radius: 50,
                            backgroundColor: theme.colorScheme.primary.withOpacity(0.1),
                            child: Icon(
                              isFarmer ? Icons.agriculture_rounded : Icons.shopping_basket_rounded,
                              size: 48,
                              color: theme.colorScheme.primary,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 60),

                  // Name and Chip
                  Center(
                    child: Column(
                      children: [
                        Text(
                          profile.user.email,
                          style: theme.textTheme.titleLarge?.copyWith(
                            fontWeight: FontWeight.bold,
                            letterSpacing: -0.5,
                          ),
                        ),
                        const SizedBox(height: 6),
                        Chip(
                          label: Text(isFarmer ? 'FARMER PROFILE' : 'BUYER PROFILE'),
                          backgroundColor: theme.colorScheme.primary.withOpacity(0.08),
                          side: BorderSide.none,
                          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                          labelStyle: TextStyle(
                            color: theme.colorScheme.primary,
                            fontWeight: FontWeight.bold,
                            fontSize: 12,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 24),

                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 24.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        // Stats panel card
                        Card(
                          elevation: 0,
                          color: theme.cardColor,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20),
                            side: BorderSide(color: theme.colorScheme.onSurface.withOpacity(0.08)),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.symmetric(vertical: 20.0, horizontal: 16.0),
                            child: Row(
                              children: [
                                _buildStatColumn(
                                  context: context,
                                  title: 'Rating',
                                  value: '${profile.rating.toStringAsFixed(1)} ⭐',
                                ),
                                _buildVerticalDivider(theme),
                                _buildStatColumn(
                                  context: context,
                                  title: 'Account Status',
                                  value: 'Active',
                                  valueColor: theme.colorScheme.primary,
                                ),
                                _buildVerticalDivider(theme),
                                _buildStatColumn(
                                  context: context,
                                  title: 'User ID',
                                  value: '#${profile.user.id}',
                                ),
                              ],
                            ),
                          ),
                        ),
                        const SizedBox(height: 24),

                        // Form Section
                        Card(
                          elevation: 0,
                          color: theme.cardColor,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(24),
                            side: BorderSide(color: theme.colorScheme.onSurface.withOpacity(0.08)),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.all(24.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      isFarmer ? 'Farm Details' : 'Delivery Details',
                                      style: theme.textTheme.titleMedium?.copyWith(
                                        fontWeight: FontWeight.bold,
                                        color: theme.colorScheme.primary,
                                      ),
                                    ),
                                    if (!_isEditing)
                                      TextButton.icon(
                                        onPressed: () => setState(() => _isEditing = true),
                                        icon: const Icon(Icons.edit_rounded, size: 16),
                                        label: const Text('Edit'),
                                        style: TextButton.styleFrom(
                                          foregroundColor: theme.colorScheme.primary,
                                          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                                          backgroundColor: theme.colorScheme.primary.withOpacity(0.08),
                                          shape: RoundedRectangleBorder(
                                            borderRadius: BorderRadius.circular(12),
                                          ),
                                        ),
                                      ),
                                  ],
                                ),
                                const SizedBox(height: 20),
                                if (isFarmer) ...[
                                  // Farm Name
                                  _buildField(
                                    label: 'Farm Name',
                                    controller: _farmNameController,
                                    isEditing: _isEditing,
                                    icon: Icons.storefront_rounded,
                                    hint: 'Enter your farm name',
                                    validator: (value) =>
                                        value == null || value.isEmpty ? 'Please enter farm name' : null,
                                  ),
                                  const SizedBox(height: 20),
                                  // Farm Address
                                  _buildField(
                                    label: 'Farm Location / Address',
                                    controller: _farmAddressController,
                                    isEditing: _isEditing,
                                    icon: Icons.location_on_outlined,
                                    hint: 'Enter farm address',
                                    maxLines: 3,
                                    validator: (value) =>
                                        value == null || value.isEmpty ? 'Please enter farm address' : null,
                                  ),
                                ] else ...[
                                  // Delivery Address
                                  _buildField(
                                    label: 'Delivery Address',
                                    controller: _deliveryAddressController,
                                    isEditing: _isEditing,
                                    icon: Icons.home_outlined,
                                    hint: 'Enter home/delivery address',
                                    maxLines: 3,
                                    validator: (value) =>
                                        value == null || value.isEmpty ? 'Please enter delivery address' : null,
                                  ),
                                ],
                                if (_isEditing) ...[
                                  const SizedBox(height: 28),
                                  Row(
                                    children: [
                                      Expanded(
                                        child: OutlinedButton(
                                          onPressed: () => setState(() => _isEditing = false),
                                          style: OutlinedButton.styleFrom(
                                            padding: const EdgeInsets.symmetric(vertical: 16),
                                            shape: RoundedRectangleBorder(
                                              borderRadius: BorderRadius.circular(16),
                                            ),
                                          ),
                                          child: const Text('Cancel'),
                                        ),
                                      ),
                                      const SizedBox(width: 12),
                                      Expanded(
                                        child: ElevatedButton(
                                          onPressed: () => _save(isFarmer),
                                          style: ElevatedButton.styleFrom(
                                            padding: const EdgeInsets.symmetric(vertical: 16),
                                            shape: RoundedRectangleBorder(
                                              borderRadius: BorderRadius.circular(16),
                                            ),
                                          ),
                                          child: const Text('Save'),
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ],
                            ),
                          ),
                        ),
                        const SizedBox(height: 40),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          );
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, _) => Center(
          child: Padding(
            padding: const EdgeInsets.all(24.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.error_outline_rounded, size: 64, color: theme.colorScheme.error),
                const SizedBox(height: 16),
                Text(
                  'Something went wrong',
                  style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 8),
                Text(
                  error.toString(),
                  textAlign: TextAlign.center,
                  style: TextStyle(color: theme.colorScheme.onBackground.withOpacity(0.6)),
                ),
                const SizedBox(height: 24),
                ElevatedButton.icon(
                  onPressed: () => ref.read(profileProvider.notifier).fetchProfile(),
                  icon: const Icon(Icons.refresh_rounded),
                  label: const Text('Retry'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildVerticalDivider(ThemeData theme) {
    return Container(
      height: 30,
      width: 1,
      color: theme.colorScheme.onSurface.withOpacity(0.12),
    );
  }

  Widget _buildStatColumn({
    required BuildContext context,
    required String title,
    required String value,
    Color? valueColor,
  }) {
    final theme = Theme.of(context);
    return Expanded(
      child: Column(
        children: [
          Text(
            title,
            style: TextStyle(
              fontSize: 11,
              fontWeight: FontWeight.w600,
              color: theme.colorScheme.onSurface.withOpacity(0.5),
            ),
          ),
          const SizedBox(height: 6),
          Text(
            value,
            style: TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.bold,
              color: valueColor ?? theme.colorScheme.onSurface,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildField({
    required String label,
    required TextEditingController controller,
    required bool isEditing,
    required IconData icon,
    required String hint,
    int maxLines = 1,
    String? Function(String?)? validator,
  }) {
    final theme = Theme.of(context);

    if (!isEditing) {
      // Modern display style when read-only
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w600,
              color: theme.colorScheme.onSurface.withOpacity(0.4),
            ),
          ),
          const SizedBox(height: 8),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Icon(
                icon,
                size: 20,
                color: theme.colorScheme.primary.withOpacity(0.7),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  controller.text.isNotEmpty ? controller.text : 'Not provided',
                  style: TextStyle(
                    fontSize: 15,
                    color: controller.text.isNotEmpty
                        ? theme.colorScheme.onSurface
                        : theme.colorScheme.onSurface.withOpacity(0.4),
                    fontStyle: controller.text.isNotEmpty ? FontStyle.normal : FontStyle.italic,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Divider(color: theme.colorScheme.onSurface.withOpacity(0.06)),
        ],
      );
    }

    // Input style when editing
    return TextFormField(
      controller: controller,
      maxLines: maxLines,
      decoration: InputDecoration(
        labelText: label,
        hintText: hint,
        alignLabelWithHint: maxLines > 1,
        prefixIcon: Padding(
          padding: EdgeInsets.only(bottom: maxLines > 1 ? 40.0 : 0.0),
          child: Icon(icon, color: theme.colorScheme.primary.withOpacity(0.7)),
        ),
      ),
      validator: validator,
    );
  }
}
