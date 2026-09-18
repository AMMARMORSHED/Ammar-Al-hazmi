import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../core/localization/app_localizations.dart';
import '../providers/app_state.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final loc = AppLocalizations.of(context);

    return Scaffold(
      appBar: AppBar(title: Text(loc.tr('settings'))),
      body: ListView(
        children: [
          ListTile(
            leading: const Icon(Icons.language),
            title: Text(loc.tr('language')),
            subtitle: const Text('العربية / English'),
          ),
          ListTile(
            leading: const Icon(Icons.color_lens_outlined),
            title: Text(loc.tr('theme')),
            subtitle: Text(loc.tr('system')),
          ),
          ListTile(
            leading: const Icon(Icons.backup_outlined),
            title: const Text('Backup'),
          ),
        ],
      ),
    );
  }
}

class ReportsScreen extends StatelessWidget {
  const ReportsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final state = context.watch<AppState>();
    final loc = AppLocalizations.of(context);

    return Scaffold(
      appBar: AppBar(title: Text(loc.tr('reports'))),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(loc.tr('total_receivable'), style: Theme.of(context).textTheme.titleMedium),
            Text('${state.totalReceivable.toStringAsFixed(0)} ${state.selectedLedger?.currencyCode ?? 'YER'}'),
            const SizedBox(height: 12),
            Text(loc.tr('total_payable'), style: Theme.of(context).textTheme.titleMedium),
            Text('${state.totalPayable.toStringAsFixed(0)} ${state.selectedLedger?.currencyCode ?? 'YER'}'),
            const SizedBox(height: 12),
            Text(loc.tr('net_balance'), style: Theme.of(context).textTheme.titleMedium),
            Text('${state.netBalance.toStringAsFixed(0)} ${state.selectedLedger?.currencyCode ?? 'YER'}'),
          ],
        ),
      ),
    );
  }
}
