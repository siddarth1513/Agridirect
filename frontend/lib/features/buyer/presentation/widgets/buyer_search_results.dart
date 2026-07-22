import 'package:flutter/material.dart';
import 'transport_checkout_modal.dart';
import 'farmer_details_modal.dart';

// ─── All searchable data ────────────────────────────────────────────────────

const _allCrops = [
  {
    'name': 'Organic Red Tomatoes',
    'farm': 'Green Valley Farm',
    'price': '₹40 / kg',
    'weight': '500 kg batch',
    'rating': '4.9',
    'badge': 'Seasonal',
    'imageUrl':
        'https://images.unsplash.com/photo-1592924357228-91a4daadcfea?auto=format&fit=crop&w=800&q=80',
    'icon': Icons.eco_rounded,
    'color': Colors.redAccent,
  },
  {
    'name': 'Fresh Alphonso Mangoes',
    'farm': 'Sunrise Orchards',
    'price': '₹180 / kg',
    'weight': '250 kg batch',
    'rating': '5.0',
    'badge': 'Top Rated',
    'imageUrl':
        'https://images.unsplash.com/photo-1553279768-865429fa0078?auto=format&fit=crop&w=800&q=80',
    'icon': Icons.local_florist_rounded,
    'color': Colors.amber,
  },
  {
    'name': 'Fresh Green Capsicum',
    'farm': 'Freshfields Farm',
    'price': '₹75 / kg',
    'weight': '150 kg batch',
    'rating': '4.8',
    'badge': 'Direct Farm',
    'imageUrl':
        'https://images.unsplash.com/photo-1563565375-f3fdfdbefa83?auto=format&fit=crop&w=800&q=80',
    'icon': Icons.grass_rounded,
    'color': Colors.green,
  },
  {
    'name': 'Harvested Earth Potatoes',
    'farm': 'Highland Agro',
    'price': '₹30 / kg',
    'weight': '1000 kg batch',
    'rating': '4.7',
    'badge': 'Best Price',
    'imageUrl':
        'https://images.unsplash.com/photo-1518977676601-b53f82aba655?auto=format&fit=crop&w=800&q=80',
    'icon': Icons.grain_rounded,
    'color': Colors.brown,
  },
  {
    'name': 'Fresh Red Onions',
    'farm': 'Agro Sunrise Fields',
    'price': '₹35 / kg',
    'weight': '600 kg batch',
    'rating': '4.6',
    'badge': 'Seasonal',
    'imageUrl':
        'https://images.unsplash.com/photo-1618512496248-a07fe83aa8cb?auto=format&fit=crop&w=800&q=80',
    'icon': Icons.spa_rounded,
    'color': Colors.deepOrange,
  },
  {
    'name': 'Sweet Corn',
    'farm': 'Highland Agro',
    'price': '₹50 / kg',
    'weight': '350 kg batch',
    'rating': '4.8',
    'badge': 'Best Price',
    'imageUrl':
        'https://images.unsplash.com/photo-1551754655-cd27e38d2076?auto=format&fit=crop&w=800&q=80',
    'icon': Icons.grain_rounded,
    'color': Colors.yellow,
  },
];

const _allFarmers = [
  {
    'name': 'Ramesh Kumar',
    'farm': 'Green Valley Organic',
    'location': 'Nashik, Maharashtra',
    'rating': '4.9',
    'crops': 'Tomatoes, Onions',
    'avatarColor': Colors.green,
  },
  {
    'name': 'Anita Patil',
    'farm': 'Sunrise Agro Farms',
    'location': 'Pune, Maharashtra',
    'rating': '4.8',
    'crops': 'Mangoes, Grapes',
    'avatarColor': Colors.orange,
  },
  {
    'name': 'Suresh Reddy',
    'farm': 'Freshfields Farm',
    'location': 'Chittoor, AP',
    'rating': '4.9',
    'crops': 'Potatoes, Carrots',
    'avatarColor': Colors.teal,
  },
  {
    'name': 'Vikram Singh',
    'farm': 'Earth Bounty Agro',
    'location': 'Agra, UP',
    'rating': '4.7',
    'crops': 'Potatoes, Root Crops',
    'avatarColor': Colors.indigo,
  },
];

// ─── Widget ─────────────────────────────────────────────────────────────────

class BuyerSearchResults extends StatelessWidget {
  final String searchQuery;

  const BuyerSearchResults({super.key, required this.searchQuery});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final q = searchQuery.toLowerCase();

    final matchedCrops = (_allCrops as List<Map<String, dynamic>>)
        .where((c) =>
            (c['name'] as String).toLowerCase().contains(q) ||
            (c['farm'] as String).toLowerCase().contains(q) ||
            (c['badge'] as String).toLowerCase().contains(q))
        .toList();

    final matchedFarmers = (_allFarmers as List<Map<String, dynamic>>)
        .where((f) =>
            (f['name'] as String).toLowerCase().contains(q) ||
            (f['farm'] as String).toLowerCase().contains(q) ||
            (f['location'] as String).toLowerCase().contains(q) ||
            (f['crops'] as String).toLowerCase().contains(q))
        .toList();

    final totalResults = matchedCrops.length + matchedFarmers.length;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // ── Result count header ─────────────────────────────────────────
        Padding(
          padding: const EdgeInsets.only(bottom: 16.0),
          child: Row(
            children: [
              Icon(Icons.search_rounded,
                  size: 18, color: theme.colorScheme.primary),
              const SizedBox(width: 8),
              RichText(
                text: TextSpan(
                  style: theme.textTheme.bodyMedium,
                  children: [
                    TextSpan(
                      text: '$totalResults result${totalResults == 1 ? '' : 's'} ',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: theme.colorScheme.primary,
                      ),
                    ),
                    TextSpan(
                      text: 'for "$searchQuery"',
                      style: TextStyle(
                        color: theme.colorScheme.onSurface.withOpacity(0.6),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),

        // ── No results ─────────────────────────────────────────────────
        if (totalResults == 0)
          Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(vertical: 48),
            decoration: BoxDecoration(
              color: theme.cardColor.withOpacity(0.6),
              borderRadius: BorderRadius.circular(20),
              border: Border.all(
                color: theme.colorScheme.onSurface.withOpacity(0.08),
              ),
            ),
            child: Column(
              children: [
                Icon(Icons.search_off_rounded,
                    size: 56,
                    color: theme.colorScheme.onSurface.withOpacity(0.25)),
                const SizedBox(height: 12),
                Text(
                  'No results found',
                  style: theme.textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: theme.colorScheme.onSurface.withOpacity(0.5),
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  'Try searching for a crop name, farm, or location',
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: theme.colorScheme.onSurface.withOpacity(0.35),
                  ),
                ),
              ],
            ),
          ),

        // ── Crops section ───────────────────────────────────────────────
        if (matchedCrops.isNotEmpty) ...[
          _SectionLabel(
              icon: Icons.eco_rounded,
              label: 'Crops (${matchedCrops.length})',
              theme: theme),
          const SizedBox(height: 10),
          ...matchedCrops.map((crop) => _CropResultTile(crop: crop)),
          const SizedBox(height: 20),
        ],

        // ── Farmers section ─────────────────────────────────────────────
        if (matchedFarmers.isNotEmpty) ...[
          _SectionLabel(
              icon: Icons.agriculture_rounded,
              label: 'Farmers (${matchedFarmers.length})',
              theme: theme),
          const SizedBox(height: 10),
          ...matchedFarmers.map((farmer) => _FarmerResultTile(farmer: farmer)),
        ],
      ],
    );
  }
}

// ─── Section label ──────────────────────────────────────────────────────────

class _SectionLabel extends StatelessWidget {
  final IconData icon;
  final String label;
  final ThemeData theme;
  const _SectionLabel(
      {required this.icon, required this.label, required this.theme});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          padding: const EdgeInsets.all(6),
          decoration: BoxDecoration(
            color: theme.colorScheme.primary.withOpacity(0.12),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Icon(icon, size: 16, color: theme.colorScheme.primary),
        ),
        const SizedBox(width: 10),
        Text(
          label,
          style: theme.textTheme.titleSmall?.copyWith(
            fontWeight: FontWeight.bold,
            letterSpacing: -0.2,
          ),
        ),
      ],
    );
  }
}

// ─── Crop result tile ───────────────────────────────────────────────────────

class _CropResultTile extends StatelessWidget {
  final Map<String, dynamic> crop;
  const _CropResultTile({required this.crop});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return InkWell(
      onTap: () {
        showModalBottomSheet(
          context: context,
          isScrollControlled: true,
          backgroundColor: Colors.transparent,
          builder: (_) => TransportCheckoutModal(crop: crop),
        );
      },
      borderRadius: BorderRadius.circular(16),
      child: Container(
        margin: const EdgeInsets.only(bottom: 10),
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: theme.cardColor.withOpacity(isDark ? 0.9 : 0.97),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: theme.colorScheme.onSurface.withOpacity(0.08),
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(isDark ? 0.15 : 0.03),
              blurRadius: 8,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Row(
          children: [
            // Thumbnail
            ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: Image.network(
                crop['imageUrl'] as String,
                width: 64,
                height: 64,
                fit: BoxFit.cover,
                errorBuilder: (_, __, ___) => Container(
                  width: 64,
                  height: 64,
                  color: (crop['color'] as Color).withOpacity(0.15),
                  child: Icon(crop['icon'] as IconData,
                      color: crop['color'] as Color, size: 32),
                ),
              ),
            ),
            const SizedBox(width: 14),
            // Details
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    crop['name'] as String,
                    style: theme.textTheme.bodyMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 3),
                  Text(
                    crop['farm'] as String,
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: theme.colorScheme.onSurface.withOpacity(0.55),
                    ),
                  ),
                  const SizedBox(height: 5),
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 7, vertical: 3),
                        decoration: BoxDecoration(
                          color: theme.colorScheme.primary.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(6),
                        ),
                        child: Text(
                          crop['badge'] as String,
                          style: TextStyle(
                            fontSize: 10,
                            fontWeight: FontWeight.bold,
                            color: theme.colorScheme.primary,
                          ),
                        ),
                      ),
                      const SizedBox(width: 8),
                      Text(
                        '⭐ ${crop['rating']}',
                        style: theme.textTheme.bodySmall?.copyWith(
                          fontSize: 11,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            // Price + arrow
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  crop['price'] as String,
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 14,
                    color: theme.colorScheme.primary,
                  ),
                ),
                const SizedBox(height: 6),
                Container(
                  padding: const EdgeInsets.all(6),
                  decoration: BoxDecoration(
                    color: theme.colorScheme.primary,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: const Icon(Icons.arrow_forward_rounded,
                      color: Colors.white, size: 14),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

// ─── Farmer result tile ─────────────────────────────────────────────────────

class _FarmerResultTile extends StatelessWidget {
  final Map<String, dynamic> farmer;
  const _FarmerResultTile({required this.farmer});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return InkWell(
      onTap: () {
        showModalBottomSheet(
          context: context,
          backgroundColor: Colors.transparent,
          builder: (_) => FarmerDetailsModal(farmer: farmer),
        );
      },
      borderRadius: BorderRadius.circular(16),
      child: Container(
        margin: const EdgeInsets.only(bottom: 10),
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: theme.cardColor.withOpacity(isDark ? 0.9 : 0.97),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: theme.colorScheme.onSurface.withOpacity(0.08),
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(isDark ? 0.15 : 0.03),
              blurRadius: 8,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Row(
          children: [
            // Avatar
            CircleAvatar(
              radius: 28,
              backgroundColor:
                  (farmer['avatarColor'] as Color).withOpacity(0.18),
              child: Icon(Icons.person_rounded,
                  color: farmer['avatarColor'] as Color, size: 28),
            ),
            const SizedBox(width: 14),
            // Details
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    farmer['name'] as String,
                    style: theme.textTheme.bodyMedium
                        ?.copyWith(fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    farmer['farm'] as String,
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                      color: theme.colorScheme.primary,
                    ),
                  ),
                  const SizedBox(height: 3),
                  Row(
                    children: [
                      Icon(Icons.location_on_outlined,
                          size: 12,
                          color:
                              theme.colorScheme.onSurface.withOpacity(0.45)),
                      const SizedBox(width: 3),
                      Text(
                        farmer['location'] as String,
                        style: theme.textTheme.bodySmall?.copyWith(
                          fontSize: 11,
                          color: theme.colorScheme.onSurface.withOpacity(0.5),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            // Rating
            Container(
              padding:
                  const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
              decoration: BoxDecoration(
                color: Colors.amber.withOpacity(0.15),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Text(
                '★ ${farmer['rating']}',
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Colors.amber,
                  fontSize: 13,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
