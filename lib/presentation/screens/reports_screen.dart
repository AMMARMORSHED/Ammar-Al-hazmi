import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/app_state.dart';

class ReportsScreen extends StatelessWidget {
  const ReportsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final state = context.watch<AppState>();

    return Scaffold(
      appBar: AppBar(title: const Text('Reports')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Total receivable: ${state.totalReceivable.toStringAsFixed(0)}'),
            const SizedBox(height: 8),
            Text('Total payable: ${state.totalPayable.toStringAsFixed(0)}'),
            const SizedBox(height: 8),
            Text('Net balance: ${state.netBalance.toStringAsFixed(0)}'),
          ],
        ),
      ),
    );
  }
}
