import 'package:flutter/material.dart';

class FarmerDetailsModal extends StatelessWidget {
  final Map<String, dynamic> farmer;

  const FarmerDetailsModal({super.key, required this.farmer});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      padding: const EdgeInsets.all(24.0),
      decoration: BoxDecoration(
        color: theme.dialogBackgroundColor,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(28)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  CircleAvatar(
                    radius: 24,
                    backgroundColor: (farmer['avatarColor'] as Color).withOpacity(0.2),
                    child: Icon(Icons.person_rounded, color: farmer['avatarColor'] as Color, size: 28),
                  ),
                  const SizedBox(width: 12),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(farmer['name'] as String, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                      Text(farmer['farm'] as String,
                          style: TextStyle(fontSize: 12, color: theme.colorScheme.primary, fontWeight: FontWeight.w600)),
                    ],
                  ),
                ],
              ),
              IconButton(
                onPressed: () => Navigator.of(context).pop(),
                icon: const Icon(Icons.close_rounded),
              ),
            ],
          ),
          const SizedBox(height: 20),
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: theme.colorScheme.onSurface.withOpacity(0.04),
              borderRadius: BorderRadius.circular(16),
            ),
            child: Column(
              children: [
                _buildDetailRow('Location:', farmer['location'] as String, Icons.location_on_outlined, theme),
                const SizedBox(height: 10),
                _buildDetailRow('Rating:', '${farmer['rating']} ⭐ (50+ Reviews)', Icons.star_rounded, theme),
                const SizedBox(height: 10),
                _buildDetailRow('Primary Crops:', farmer['crops'] as String, Icons.eco_outlined, theme),
                const SizedBox(height: 10),
                _buildDetailRow('Experience:', '12+ Years Organic Farming', Icons.workspace_premium_rounded, theme),
              ],
            ),
          ),
          const SizedBox(height: 24),
          Row(
            children: [
              Expanded(
                child: OutlinedButton.icon(
                  onPressed: () {
                    Navigator.of(context).pop();
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('Call initiated to ${farmer['name']}'), behavior: SnackBarBehavior.floating),
                    );
                  },
                  icon: const Icon(Icons.phone_rounded),
                  label: const Text('Call Farmer'),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: ElevatedButton.icon(
                  onPressed: () {
                    Navigator.of(context).pop();
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('Opening chat with ${farmer['name']}'), behavior: SnackBarBehavior.floating),
                    );
                  },
                  icon: const Icon(Icons.chat_bubble_outline_rounded),
                  label: const Text('Message'),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildDetailRow(String label, String value, IconData icon, ThemeData theme) {
    return Row(
      children: [
        Icon(icon, size: 18, color: theme.colorScheme.primary),
        const SizedBox(width: 10),
        Text(label, style: TextStyle(fontSize: 13, color: theme.colorScheme.onSurface.withOpacity(0.6))),
        const SizedBox(width: 6),
        Expanded(
          child: Text(
            value,
            textAlign: TextAlign.end,
            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13),
          ),
        ),
      ],
    );
  }
}
