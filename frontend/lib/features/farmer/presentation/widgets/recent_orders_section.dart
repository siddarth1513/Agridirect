import 'package:flutter/material.dart';

class RecentOrdersSection extends StatefulWidget {
  const RecentOrdersSection({super.key});

  @override
  State<RecentOrdersSection> createState() => _RecentOrdersSectionState();
}

class _RecentOrdersSectionState extends State<RecentOrdersSection> {
  final List<Map<String, dynamic>> _orders = [
    {
      'id': '#ORD-9931',
      'buyerName': 'FreshMart Supermarket',
      'crop': '150kg Organic Red Tomatoes',
      'amount': '₹6,000',
      'date': 'Today, 11:20 AM',
      'status': 'Pending Approval',
      'transportStatus': 'Not Dispatched',
      'selectedTransport': 'AgriDirect Express Logistics',
    },
    {
      'id': '#ORD-9884',
      'buyerName': 'Green Basket Grocery',
      'crop': '50kg Alphonso Mangoes',
      'amount': '₹9,000',
      'date': 'Yesterday',
      'status': 'Accepted',
      'transportStatus': 'Scheduled (pickup tomorrow 9 AM)',
      'selectedTransport': 'Self Farm Truck Pickup',
    },
  ];

  final List<String> _transportPartners = [
    'AgriDirect Express Logistics',
    'Self Farm Truck Pickup',
    'Local Cold Chain Transport',
  ];

  void _updateStatus(int index, String newStatus) {
    setState(() {
      _orders[index]['status'] = newStatus;
    });
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Order ${_orders[index]['id']} marked as $newStatus'),
        behavior: SnackBarBehavior.floating,
        duration: const Duration(seconds: 2),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Container(
      decoration: BoxDecoration(
        color: theme.cardColor.withOpacity(isDark ? 0.9 : 0.95),
        borderRadius: BorderRadius.circular(24),
        border: Border.all(
          color: theme.colorScheme.onSurface.withOpacity(0.08),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(isDark ? 0.2 : 0.04),
            blurRadius: 20,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: Colors.orange.withOpacity(0.15),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: const Icon(
                      Icons.receipt_long_rounded,
                      color: Colors.orange,
                      size: 20,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Text(
                    'Recent Orders & Requests',
                    style: theme.textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                      letterSpacing: -0.3,
                    ),
                  ),
                ],
              ),
              TextButton(
                onPressed: () {
                  showModalBottomSheet(
                    context: context,
                    isScrollControlled: true,
                    backgroundColor: Colors.transparent,
                    builder: (ctx) {
                      final t = Theme.of(ctx);
                      return DraggableScrollableSheet(
                        initialChildSize: 0.6,
                        maxChildSize: 0.9,
                        minChildSize: 0.4,
                        builder: (ctx2, sc) => Container(
                          padding: const EdgeInsets.all(24),
                          decoration: BoxDecoration(
                            color: t.dialogBackgroundColor,
                            borderRadius: const BorderRadius.vertical(top: Radius.circular(28)),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Text('All Orders & Requests',
                                      style: t.textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold)),
                                  IconButton(
                                      onPressed: () => Navigator.of(ctx2).pop(),
                                      icon: const Icon(Icons.close_rounded)),
                                ],
                              ),
                              const SizedBox(height: 12),
                              Expanded(
                                child: ListView.separated(
                                  controller: sc,
                                  itemCount: _orders.length,
                                  separatorBuilder: (_, __) => Divider(
                                    color: t.colorScheme.onSurface.withOpacity(0.08),
                                    height: 24,
                                  ),
                                  itemBuilder: (_, index) {
                                    final o = _orders[index];
                                    return ListTile(
                                      title: Text(o['id'] as String,
                                          style: const TextStyle(fontWeight: FontWeight.bold)),
                                      subtitle: Text('${o['buyerName']} • ${o['crop']}'),
                                      trailing: Text(o['amount'] as String,
                                          style: TextStyle(
                                              fontWeight: FontWeight.bold,
                                              color: t.colorScheme.primary)),
                                    );
                                  },
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  );
                },
                child: Text(
                  'View All (${_orders.length})',
                  style: TextStyle(
                    color: theme.colorScheme.primary,
                    fontWeight: FontWeight.w600,
                    fontSize: 13,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),

          ListView.separated(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: _orders.length,
            separatorBuilder: (context, index) => Divider(
              color: theme.colorScheme.onSurface.withOpacity(0.08),
              height: 28,
            ),
            itemBuilder: (context, index) {
              final order = _orders[index];
              final isPending = order['status'] == 'Pending Approval';
              final isAccepted = order['status'] == 'Accepted';
              final isRejected = order['status'] == 'Rejected';

              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          Text(
                            order['id'] as String,
                            style: theme.textTheme.bodyMedium?.copyWith(
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(width: 10),
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                            decoration: BoxDecoration(
                              color: isPending
                                  ? Colors.amber.withOpacity(0.15)
                                  : (isAccepted
                                      ? Colors.green.withOpacity(0.15)
                                      : Colors.red.withOpacity(0.15)),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Text(
                              order['status'] as String,
                              style: TextStyle(
                                fontSize: 11,
                                fontWeight: FontWeight.bold,
                                color: isPending
                                    ? Colors.amber.shade900
                                    : (isAccepted ? Colors.green.shade800 : Colors.red.shade800),
                              ),
                            ),
                          ),
                        ],
                      ),
                      Text(
                        order['amount'] as String,
                        style: theme.textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.bold,
                          color: theme.colorScheme.primary,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Text(
                    order['buyerName'] as String,
                    style: theme.textTheme.bodyMedium?.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    order['crop'] as String,
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: theme.colorScheme.onSurface.withOpacity(0.6),
                    ),
                  ),
                  const SizedBox(height: 14),

                  // Action Buttons: Accept / Reject
                  if (isPending) ...[
                    Row(
                      children: [
                        Expanded(
                          child: OutlinedButton.icon(
                            onPressed: () => _updateStatus(index, 'Rejected'),
                            icon: const Icon(Icons.close_rounded, color: Colors.red, size: 16),
                            label: const Text('Reject', style: TextStyle(color: Colors.red)),
                            style: OutlinedButton.styleFrom(
                              side: const BorderSide(color: Colors.red),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: ElevatedButton.icon(
                            onPressed: () => _updateStatus(index, 'Accepted'),
                            icon: const Icon(Icons.check_rounded, size: 16),
                            label: const Text('Accept Order'),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.green,
                              foregroundColor: Colors.white,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ],
              );
            },
          ),
        ],
      ),
    );
  }
}
