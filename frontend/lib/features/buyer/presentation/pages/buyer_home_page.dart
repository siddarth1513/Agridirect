import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/theme/organic_background.dart';
import '../../../auth/presentation/providers/auth_provider.dart';
import '../widgets/kpi_card.dart';
import '../widgets/orders_box.dart';
import '../widgets/saved_farmers_section.dart';
import '../widgets/recommended_crops_grid.dart';
import '../widgets/footer_section.dart';
import '../widgets/detail_list_modal.dart';
import '../widgets/buyer_search_results.dart';

class BuyerHomePage extends ConsumerStatefulWidget {
  const BuyerHomePage({super.key});

  @override
  ConsumerState<BuyerHomePage> createState() => _BuyerHomePageState();
}

class _BuyerHomePageState extends ConsumerState<BuyerHomePage> {
  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = '';

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _showActiveOrdersModal(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => const DetailListModal(
        title: 'Active Orders (2)',
        icon: Icons.local_shipping_outlined,
        iconColor: Color(0xFFFF9900),
        items: [
          {
            'title': 'Order #ORD-9821',
            'subtitle': 'Green Valley Farm • Organic Tomatoes (100 kg)',
            'value': '₹4,000',
            'badge': 'In Transit',
          },
          {
            'title': 'Order #ORD-9844',
            'subtitle': 'Ratnagiri Farms • Alphonso Mangoes (50 kg)',
            'value': '₹10,250',
            'badge': 'Order Placed',
          },
        ],
      ),
    );
  }

  void _showTotalSpentModal(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => const DetailListModal(
        title: 'Total Spent Breakdown',
        icon: Icons.account_balance_wallet_outlined,
        iconColor: Color(0xFF2E7D32),
        items: [
          {
            'title': 'Organic Tomatoes (300 kg)',
            'subtitle': '3 orders fulfilled from Green Valley Farm',
            'value': '₹8,500',
            'badge': 'Completed',
          },
          {
            'title': 'Alphonso Mangoes (50 kg)',
            'subtitle': '1 order fulfilled from Ratnagiri Farms',
            'value': '₹5,250',
            'badge': 'Completed',
          },
          {
            'title': 'Logistics & Transport Fees',
            'subtitle': 'Direct farm dispatch across 4 shipments',
            'value': '₹500',
            'badge': 'Paid',
          },
        ],
      ),
    );
  }

  void _showSavedFarmersModal(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => const DetailListModal(
        title: 'Saved Farmers (12)',
        icon: Icons.star_outline_rounded,
        iconColor: Color(0xFF0288D1),
        items: [
          {
            'title': 'Ramesh Kumar',
            'subtitle': 'Green Valley Farm • Organic Grains & Vegetables',
            'value': '★ 4.9',
            'badge': 'Verified Seller',
          },
          {
            'title': 'Suresh Patel',
            'subtitle': 'Golden Harvester Farms • Premium Fruits & Citrus',
            'value': '★ 4.8',
            'badge': 'Verified Seller',
          },
          {
            'title': 'Anita Devi',
            'subtitle': 'Sunshine Agro • Organic Spices & Pulses',
            'value': '★ 4.7',
            'badge': 'Verified Seller',
          },
          {
            'title': 'Vikram Singh',
            'subtitle': 'Earth Bounty • Potatoes & Root Crops',
            'value': '★ 4.9',
            'badge': 'Verified Seller',
          },
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final authState = ref.watch(authProvider);

    return Scaffold(
      body: OrganicBackground(
        child: SafeArea(
          child: CustomScrollView(
            physics: const BouncingScrollPhysics(),
            slivers: [
              // Top App Bar
              SliverPadding(
                padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 12.0),
                sliver: SliverToBoxAdapter(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Welcome back 👋',
                            style: theme.textTheme.bodyMedium?.copyWith(
                              color: theme.colorScheme.onSurface.withOpacity(0.6),
                            ),
                          ),
                          Text(
                            (authState.user?.phoneNumber.isNotEmpty == true)
                                ? authState.user!.phoneNumber
                                : (authState.user?.email.isNotEmpty == true
                                    ? authState.user!.email.split('@').first
                                    : 'Buyer'),
                            style: theme.textTheme.headlineSmall?.copyWith(
                              fontWeight: FontWeight.bold,
                              color: theme.colorScheme.primary,
                            ),
                          ),

                        ],
                      ),
                      Row(
                        children: [
                          IconButton(
                            onPressed: () => context.push('/profile'),
                            icon: Container(
                              padding: const EdgeInsets.all(8),
                              decoration: BoxDecoration(
                                color: theme.colorScheme.primary.withOpacity(0.1),
                                shape: BoxShape.circle,
                              ),
                              child: Icon(
                                Icons.person_outline_rounded,
                                color: theme.colorScheme.primary,
                              ),
                            ),
                          ),
                          IconButton(
                            onPressed: () => ref.read(authProvider.notifier).logout(),
                            icon: Container(
                              padding: const EdgeInsets.all(8),
                              decoration: BoxDecoration(
                                color: theme.colorScheme.error.withOpacity(0.1),
                                shape: BoxShape.circle,
                              ),
                              child: Icon(
                                Icons.logout_rounded,
                                color: theme.colorScheme.error,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),

              // Search Bar
              SliverPadding(
                padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 8.0),
                sliver: SliverToBoxAdapter(
                  child: TextField(
                    controller: _searchController,
                    onChanged: (value) {
                      setState(() {
                        _searchQuery = value.trim().toLowerCase();
                      });
                    },
                    decoration: InputDecoration(
                      hintText: 'Search crops, organic vegetables, or farmers...',
                      prefixIcon: Icon(
                        Icons.search_rounded,
                        color: theme.colorScheme.primary.withOpacity(0.7),
                      ),
                      suffixIcon: _searchQuery.isNotEmpty
                          ? IconButton(
                              icon: Icon(
                                Icons.close_rounded,
                                color: theme.colorScheme.onSurface.withOpacity(0.5),
                              ),
                              onPressed: () {
                                _searchController.clear();
                                setState(() {
                                  _searchQuery = '';
                                });
                              },
                            )
                          : Container(
                              margin: const EdgeInsets.all(6),
                              decoration: BoxDecoration(
                                color: theme.colorScheme.primary,
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: const Icon(
                                Icons.tune_rounded,
                                color: Colors.white,
                                size: 18,
                              ),
                            ),
                    ),
                  ),
                ),
              ),

              // ── Search Results (shown when typing) ──────────────────
              if (_searchQuery.isNotEmpty)
                SliverPadding(
                  padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 8.0),
                  sliver: SliverToBoxAdapter(
                    child: AnimatedSwitcher(
                      duration: const Duration(milliseconds: 250),
                      child: BuyerSearchResults(
                        key: ValueKey(_searchQuery),
                        searchQuery: _searchQuery,
                      ),
                    ),
                  ),
                ),

              // ── Normal dashboard (hidden while searching) ────────────
              if (_searchQuery.isEmpty) ...[  
                // KPI Metrics Cards Grid
                SliverPadding(
                  padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 16.0),
                  sliver: SliverToBoxAdapter(
                    child: LayoutBuilder(
                      builder: (context, constraints) {
                        final isDesktop = constraints.maxWidth > 700;
                        if (isDesktop) {
                          return Row(
                            children: [
                              Expanded(
                                child: KpiCard(
                                  title: 'Active Orders',
                                  value: '2',
                                  subtitle: '1 in transit',
                                  icon: Icons.local_shipping_outlined,
                                  gradient: const LinearGradient(
                                    colors: [Color(0xFFFF9900), Color(0xFFFF5500)],
                                  ),
                                  onTap: () => _showActiveOrdersModal(context),
                                ),
                              ),
                              const SizedBox(width: 16),
                              Expanded(
                                child: KpiCard(
                                  title: 'Total Spent',
                                  value: '₹14,250',
                                  subtitle: '+12% this month',
                                  icon: Icons.account_balance_wallet_outlined,
                                  gradient: const LinearGradient(
                                    colors: [Color(0xFF2E7D32), Color(0xFF4CAF50)],
                                  ),
                                  onTap: () => _showTotalSpentModal(context),
                                ),
                              ),
                              const SizedBox(width: 16),
                              Expanded(
                                child: KpiCard(
                                  title: 'Saved Farmers',
                                  value: '12',
                                  subtitle: '3 added recently',
                                  icon: Icons.star_outline_rounded,
                                  gradient: const LinearGradient(
                                    colors: [Color(0xFF0288D1), Color(0xFF26C6DA)],
                                  ),
                                  onTap: () => _showSavedFarmersModal(context),
                                ),
                              ),
                            ],
                          );
                        }

                        return Column(
                          children: [
                            Row(
                              children: [
                                Expanded(
                                  child: KpiCard(
                                    title: 'Active Orders',
                                    value: '2',
                                    subtitle: '1 in transit',
                                    icon: Icons.local_shipping_outlined,
                                    gradient: const LinearGradient(
                                      colors: [Color(0xFFFF9900), Color(0xFFFF5500)],
                                    ),
                                    onTap: () => _showActiveOrdersModal(context),
                                  ),
                                ),
                                const SizedBox(width: 12),
                                Expanded(
                                  child: KpiCard(
                                    title: 'Total Spent',
                                    value: '₹14,250',
                                    subtitle: '+12% this month',
                                    icon: Icons.account_balance_wallet_outlined,
                                    gradient: const LinearGradient(
                                      colors: [Color(0xFF2E7D32), Color(0xFF4CAF50)],
                                    ),
                                    onTap: () => _showTotalSpentModal(context),
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 12),
                            KpiCard(
                              title: 'Saved Farmers',
                              value: '12',
                              subtitle: '3 added recently',
                              icon: Icons.star_outline_rounded,
                              gradient: const LinearGradient(
                                colors: [Color(0xFF0288D1), Color(0xFF26C6DA)],
                              ),
                              onTap: () => _showSavedFarmersModal(context),
                            ),
                          ],
                        );
                      },
                    ),
                  ),
                ),

                // My Orders Section
                const SliverPadding(
                  padding: EdgeInsets.symmetric(horizontal: 20.0, vertical: 8.0),
                  sliver: SliverToBoxAdapter(
                    child: OrdersBox(),
                  ),
                ),

                // Saved Farmers Section
                const SliverPadding(
                  padding: EdgeInsets.symmetric(horizontal: 20.0, vertical: 16.0),
                  sliver: SliverToBoxAdapter(
                    child: SavedFarmersSection(),
                  ),
                ),

                // Recommended Crops Section
                SliverPadding(
                  padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 8.0),
                  sliver: SliverToBoxAdapter(
                    child: RecommendedCropsGrid(searchQuery: ''),
                  ),
                ),

                // Footer Section & Customer Support Info
                const SliverPadding(
                  padding: EdgeInsets.symmetric(horizontal: 20.0, vertical: 16.0),
                  sliver: SliverToBoxAdapter(
                    child: FooterSection(),
                  ),
                ),
              ],

              const SliverPadding(
                padding: EdgeInsets.only(bottom: 32.0),
                sliver: SliverToBoxAdapter(child: SizedBox(height: 20)),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
