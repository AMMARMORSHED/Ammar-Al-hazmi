import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../core/localization/app_localizations.dart';
import '../../data/models/person_model.dart';
import '../../data/models/transaction_model.dart';
import '../providers/app_state.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) {
        context.read<AppState>().loadInitial();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final state = context.watch<AppState>();
    final loc = AppLocalizations.of(context);

    return Scaffold(
      appBar: AppBar(
        title: Text(loc.tr('app_name')),
        actions: [
          IconButton(
            onPressed: () {},
            icon: const Icon(Icons.search),
          ),
        ],
      ),
      body: state.isBusy
          ? const Center(child: CircularProgressIndicator())
          : RefreshIndicator(
              onRefresh: state.refreshLedgerData,
              child: ListView(
                padding: const EdgeInsets.all(16),
                children: [
                  if (state.selectedLedger != null)
                    Card(
                      child: ListTile(
                        leading: const Icon(Icons.book_outlined),
                        title: Text(state.selectedLedger!.name),
                        subtitle: Text(state.selectedLedger!.currencyCode),
                      ),
                    ),
                  GridView.count(
                    shrinkWrap: true,
                    crossAxisCount: 2,
                    physics: const NeverScrollableScrollPhysics(),
                    childAspectRatio: 1.8,
                    crossAxisSpacing: 12,
                    mainAxisSpacing: 12,
                    children: [
                      _StatCard(
                        title: loc.tr('total_receivable'),
                        value: '${state.totalReceivable.toStringAsFixed(0)} ${state.selectedLedger?.currencyCode ?? 'YER'}',
                        color: Colors.green,
                      ),
                      _StatCard(
                        title: loc.tr('total_payable'),
                        value: '${state.totalPayable.toStringAsFixed(0)} ${state.selectedLedger?.currencyCode ?? 'YER'}',
                        color: Colors.orange,
                      ),
                      _StatCard(
                        title: loc.tr('net_balance'),
                        value: '${state.netBalance.toStringAsFixed(0)} ${state.selectedLedger?.currencyCode ?? 'YER'}',
                        color: state.netBalance >= 0 ? Colors.blue : Colors.red,
                      ),
                      _StatCard(
                        title: loc.tr('people_count'),
                        value: '${state.persons.length}',
                        color: Colors.teal,
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  Text(
                    loc.tr('recent_transactions'),
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                  const SizedBox(height: 8),
                  if (state.transactions.isEmpty)
                    Card(
                      child: Padding(
                        padding: const EdgeInsets.all(28),
                        child: Text(loc.tr('no_transactions'), textAlign: TextAlign.center),
                      ),
                    )
                  else
                    ...state.transactions.take(6).map((transaction) => _TransactionTile(transaction: transaction)),
                ],
              ),
            ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          final result = await showModalBottomSheet<String>(
            context: context,
            builder: (context) => const _QuickActionSheet(),
          );

          if (result == 'person') {
            if (!mounted) return;
            await Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => const AddPersonScreen()),
            );
          }

          if (result == 'transaction') {
            if (!mounted) return;
            await Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => const AddTransactionScreen()),
            );
          }
        },
        child: const Icon(Icons.add),
      ),
      bottomNavigationBar: NavigationBar(
        destinations: const [
          NavigationDestination(icon: Icon(Icons.home_outlined), label: 'Home'),
          NavigationDestination(icon: Icon(Icons.people_alt_outlined), label: 'Accounts'),
          NavigationDestination(icon: Icon(Icons.receipt_long_outlined), label: 'Transactions'),
          NavigationDestination(icon: Icon(Icons.bar_chart_outlined), label: 'Reports'),
          NavigationDestination(icon: Icon(Icons.settings_outlined), label: 'Settings'),
        ],
      ),
    );
  }
}

class _StatCard extends StatelessWidget {
  const _StatCard({
    required this.title,
    required this.value,
    required this.color,
  });

  final String title;
  final String value;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(title),
            Text(
              value,
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.bold,
                color: color,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _TransactionTile extends StatelessWidget {
  const _TransactionTile({required this.transaction});

  final TransactionModel transaction;

  @override
  Widget build(BuildContext context) {
    final loc = AppLocalizations.of(context);
    final typeLabel = {
      'receivable': loc.tr('receivable'),
      'payable': loc.tr('payable'),
      'received': loc.tr('received'),
      'paid': loc.tr('paid'),
    }[transaction.type] ?? transaction.type;

    return Card(
      child: ListTile(
        leading: Icon(
          transaction.type == 'receivable' || transaction.type == 'received'
              ? Icons.arrow_upward
              : Icons.arrow_downward,
          color: transaction.type == 'receivable' || transaction.type == 'received'
              ? Colors.green
              : Colors.red,
        ),
        title: Text(transaction.description.isNotEmpty ? transaction.description : typeLabel),
        subtitle: Text('${transaction.date.toLocal().toString().split(' ')[0]} • $typeLabel'),
        trailing: Text(
          '${transaction.amount.toStringAsFixed(0)}',
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
      ),
    );
  }
}

class _QuickActionSheet extends StatelessWidget {
  const _QuickActionSheet();

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: const Icon(Icons.person_add_alt_1),
              title: const Text('Add person'),
              onTap: () => Navigator.pop(context, 'person'),
            ),
            ListTile(
              leading: const Icon(Icons.note_add),
              title: const Text('Add transaction'),
              onTap: () => Navigator.pop(context, 'transaction'),
            ),
          ],
        ),
      ),
    );
  }
}

class AddPersonScreen extends StatefulWidget {
  const AddPersonScreen({super.key});

  @override
  State<AddPersonScreen> createState() => _AddPersonScreenState();
}

class _AddPersonScreenState extends State<AddPersonScreen> {
  final nameController = TextEditingController();
  final phoneController = TextEditingController();
  final notesController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final state = context.read<AppState>();
    final loc = AppLocalizations.of(context);

    return Scaffold(
      appBar: AppBar(title: Text(loc.tr('add_person'))),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            TextField(
              controller: nameController,
              decoration: InputDecoration(labelText: loc.tr('name')),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: phoneController,
              keyboardType: TextInputType.phone,
              decoration: InputDecoration(labelText: loc.tr('phone')),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: notesController,
              maxLines: 4,
              decoration: const InputDecoration(labelText: 'Notes'),
            ),
            const Spacer(),
            SizedBox(
              width: double.infinity,
              child: FilledButton(
                onPressed: () async {
                  final name = nameController.text.trim();
                  if (name.isEmpty) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text(loc.tr('name'))),
                    );
                    return;
                  }

                  final ledger = state.selectedLedger;
                  if (ledger == null) return;

                  await state.addPerson(
                    PersonModel(
                      ledgerId: ledger.id!,
                      name: name,
                      phone: phoneController.text.trim(),
                      notes: notesController.text.trim(),
                    ),
                  );

                  if (!mounted) return;
                  Navigator.pop(context);
                },
                child: Text(loc.tr('save')),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class AddTransactionScreen extends StatefulWidget {
  const AddTransactionScreen({super.key});

  @override
  State<AddTransactionScreen> createState() => _AddTransactionScreenState();
}

class _AddTransactionScreenState extends State<AddTransactionScreen> {
  final amountController = TextEditingController();
  final descriptionController = TextEditingController();
  final notesController = TextEditingController();
  String type = 'receivable';
  int? personId;

  @override
  Widget build(BuildContext context) {
    final state = context.read<AppState>();
    final loc = AppLocalizations.of(context);

    return Scaffold(
      appBar: AppBar(title: Text(loc.tr('add_transaction'))),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            DropdownButtonFormField<String>(
              value: type,
              items: const [
                DropdownMenuItem(value: 'receivable', child: Text('لي عنده')),
                DropdownMenuItem(value: 'payable', child: Text('عليّ له')),
                DropdownMenuItem(value: 'received', child: Text('استلام')),
                DropdownMenuItem(value: 'paid', child: Text('دفعة')),
              ],
              onChanged: (value) => setState(() => type = value ?? 'receivable'),
              decoration: const InputDecoration(labelText: 'Type'),
            ),
            const SizedBox(height: 12),
            DropdownButtonFormField<int>(
              value: state.persons.isNotEmpty ? state.persons.first.id : null,
              items: state.persons
                  .map((person) => DropdownMenuItem<int>(value: person.id, child: Text(person.name)))
                  .toList(),
              onChanged: (value) => setState(() => personId = value),
              decoration: const InputDecoration(labelText: 'Person'),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: amountController,
              keyboardType: const TextInputType.numberWithOptions(decimal: true),
              decoration: InputDecoration(labelText: loc.tr('amount')),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: descriptionController,
              decoration: InputDecoration(labelText: loc.tr('description')),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: notesController,
              maxLines: 3,
              decoration: const InputDecoration(labelText: 'Notes'),
            ),
            const Spacer(),
            SizedBox(
              width: double.infinity,
              child: FilledButton(
                onPressed: () async {
                  final amountValue = double.tryParse(amountController.text.trim());
                  final selectedPersonId = personId ?? state.persons.firstOrNull?.id;

                  if (amountValue == null || amountValue <= 0 || selectedPersonId == null) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text(loc.tr('error_generic'))),
                    );
                    return;
                  }

                  final ledger = state.selectedLedger;
                  if (ledger == null) return;

                  await state.addTransaction(
                    TransactionModel(
                      ledgerId: ledger.id!,
                      personId: selectedPersonId,
                      type: type,
                      amount: amountValue,
                      date: DateTime.now(),
                      description: descriptionController.text.trim(),
                      notes: notesController.text.trim(),
                    ),
                  );

                  if (!mounted) return;
                  Navigator.pop(context);
                },
                child: Text(loc.tr('save')),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

extension ListFirstOrNull<T> on List<T> {
  T? get firstOrNull => isEmpty ? null : first;
}
