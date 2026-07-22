import 'package:flutter/material.dart';
import '../widgets/all_listings_modal.dart';
import '../../../buyer/presentation/widgets/detail_list_modal.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/theme/organic_background.dart';
import '../../../auth/presentation/providers/auth_provider.dart';
import '../../../buyer/presentation/widgets/footer_section.dart';
import '../widgets/farmer_kpi_card.dart';
import '../widgets/my_crop_listings_grid.dart';
import '../widgets/recent_orders_section.dart';

class FarmerHomePage extends ConsumerWidget {
  const FarmerHomePage({super.key});

  void _showActiveListingsModal(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => const AllListingsModal(
        listings: [
          {'name': 'Organic Tomatoes', 'qty': '450 kg left', 'price': '₹40 / kg', 'status': 'Active', 'color': Colors.green, 'imageUrl': 'https://images.unsplash.com/photo-1592924357228-91a4daadcfea?auto=format&fit=crop&w=800&q=80'},
          {'name': 'Fresh Alphonso Mangoes', 'qty': '200 kg left', 'price': '₹180 / kg', 'status': 'Active', 'color': Colors.green, 'imageUrl': 'https://images.unsplash.com/photo-1553279768-865429fa0078?auto=format&fit=crop&w=800&q=80'},
          {'name': 'Green Capsicum', 'qty': '120 kg left', 'price': '₹75 / kg', 'status': 'Low Stock', 'color': Colors.orange, 'imageUrl': 'https://images.unsplash.com/photo-1563565375-f3fdfdbefa83?auto=format&fit=crop&w=800&q=80'},
          {'name': 'Harvested Earth Potatoes', 'qty': '800 kg left', 'price': '₹30 / kg', 'status': 'Active', 'color': Colors.green, 'imageUrl': 'https://images.unsplash.com/photo-1518977676601-b53f82aba655?auto=format&fit=crop&w=800&q=80'},
          {'name': 'Fresh Red Onions', 'qty': '600 kg left', 'price': '₹35 / kg', 'status': 'Active', 'color': Colors.green, 'imageUrl': 'https://images.unsplash.com/photo-1618512496248-a07fe83aa8cb?auto=format&fit=crop&w=800&q=80'},
          {'name': 'Sweet Corn', 'qty': '350 kg left', 'price': '₹50 / kg', 'status': 'Active', 'color': Colors.green, 'imageUrl': 'https://images.unsplash.com/photo-1551754655-cd27e38d2076?auto=format&fit=crop&w=800&q=80'},
        ],
      ),
    );
  }

  void _showPendingOrdersModal(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => const DetailListModal(
        title: 'Pending Orders (4)',
        icon: Icons.pending_actions_rounded,
        iconColor: Color(0xFFFF9900),
        items: [
          {'title': 'Order #F-1021', 'subtitle': 'Green Grocers Ltd • Organic Wheat (500 kg)', 'value': '₹22,500', 'badge': 'Action Required'},
          {'title': 'Order #F-1024', 'subtitle': 'FreshMart Retail • Fresh Tomatoes (300 kg)', 'value': '₹12,000', 'badge': 'Needs Confirmation'},
          {'title': 'Order #F-1025', 'subtitle': 'Organic Bazaars • Alphonso Mangoes (150 kg)', 'value': '₹27,000', 'badge': 'Needs Confirmation'},
          {'title': 'Order #F-1028', 'subtitle': 'Agro Retail Co • Sweet Corn (400 kg)', 'value': '₹20,000', 'badge': 'Action Required'},
        ],
      ),
    );
  }

  void _showTotalRevenueModal(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => const DetailListModal(
        title: 'Total Revenue Breakdown',
        icon: Icons.payments_outlined,
        iconColor: Color(0xFF0288D1),
        items: [
          {'title': 'July 2026 Earnings', 'subtitle': '12 orders settled via Direct Bank Transfer', 'value': '₹48,500', 'badge': 'Settled'},
          {'title': 'June 2026 Earnings', 'subtitle': '8 orders settled via UPI & Transport', 'value': '₹24,000', 'badge': 'Settled'},
          {'title': 'Government Agri Subsidy', 'subtitle': 'Direct Benefit Transfer (DBT)', 'value': '₹12,000', 'badge': 'Received'},
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final authState = ref.watch(authProvider);

    return Scaffold(
      body: OrganicBackground(
        child: SafeArea(
          child: CustomScrollView(
            physics: const BouncingScrollPhysics(),
            slivers: [
              // Top Header
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
                            'Farmer Portal 🌾',
                            style: theme.textTheme.bodyMedium?.copyWith(
                              color: theme.colorScheme.onSurface.withOpacity(0.6),
                            ),
                          ),
                          Text(
                            (authState.user?.phoneNumber.isNotEmpty == true)
                                ? authState.user!.phoneNumber
                                : (authState.user?.email.isNotEmpty == true
                                    ? authState.user!.email.split('@').first
                                    : 'Farmer'),
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

              // KPI Metrics Row (Active Listing, Pending Orders, Total Revenue)
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
                              child: FarmerKpiCard(
                                title: 'Active Listings',
                                value: '8',
                                subtitle: '3 crops low stock',
                                icon: Icons.inventory_2_outlined,
                                gradient: const LinearGradient(
                                  colors: [Color(0xFF2E7D32), Color(0xFF4CAF50)],
                                ),
                                onTap: () => _showActiveListingsModal(context),
                              ),
                            ),
                            const SizedBox(width: 16),
                            Expanded(
                              child: FarmerKpiCard(
                                title: 'Pending Orders',
                                value: '4',
                                subtitle: 'Needs confirmation',
                                icon: Icons.pending_actions_rounded,
                                gradient: const LinearGradient(
                                  colors: [Color(0xFFFF9900), Color(0xFFFF5500)],
                                ),
                                onTap: () => _showPendingOrdersModal(context),
                              ),
                            ),
                            const SizedBox(width: 16),
                            Expanded(
                              child: FarmerKpiCard(
                                title: 'Total Revenue',
                                value: '₹84,500',
                                subtitle: '+18% this month',
                                icon: Icons.payments_outlined,
                                gradient: const LinearGradient(
                                  colors: [Color(0xFF0288D1), Color(0xFF26C6DA)],
                                ),
                                onTap: () => _showTotalRevenueModal(context),
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
                                child: FarmerKpiCard(
                                  title: 'Active Listings',
                                  value: '8',
                                  subtitle: '3 low stock',
                                  icon: Icons.inventory_2_outlined,
                                  gradient: const LinearGradient(
                                    colors: [Color(0xFF2E7D32), Color(0xFF4CAF50)],
                                  ),
                                  onTap: () => _showActiveListingsModal(context),
                                ),
                              ),
                              const SizedBox(width: 12),
                              Expanded(
                                child: FarmerKpiCard(
                                  title: 'Pending Orders',
                                  value: '4',
                                  subtitle: 'Needs action',
                                  icon: Icons.pending_actions_rounded,
                                  gradient: const LinearGradient(
                                    colors: [Color(0xFFFF9900), Color(0xFFFF5500)],
                                  ),
                                  onTap: () => _showPendingOrdersModal(context),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 12),
                          FarmerKpiCard(
                            title: 'Total Revenue',
                            value: '₹84,500',
                            subtitle: '+18% growth this month',
                            icon: Icons.payments_outlined,
                            gradient: const LinearGradient(
                              colors: [Color(0xFF0288D1), Color(0xFF26C6DA)],
                            ),
                            onTap: () => _showTotalRevenueModal(context),
                          ),
                        ],
                      );
                    },
                  ),
                ),
              ),

              // My Crop Listings Grid
              const SliverPadding(
                padding: EdgeInsets.symmetric(horizontal: 20.0, vertical: 8.0),
                sliver: SliverToBoxAdapter(
                  child: MyCropListingsGrid(),
                ),
              ),

              // Recent Orders Section (With Accept/Reject & Transport options)
              const SliverPadding(
                padding: EdgeInsets.symmetric(horizontal: 20.0, vertical: 16.0),
                sliver: SliverToBoxAdapter(
                  child: RecentOrdersSection(),
                ),
              ),

              // Footer Section & Customer Support Info
              const SliverPadding(
                padding: EdgeInsets.symmetric(horizontal: 20.0, vertical: 16.0),
                sliver: SliverToBoxAdapter(
                  child: FooterSection(),
                ),
              ),

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

