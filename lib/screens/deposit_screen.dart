import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/balance_provider.dart';

class DepositScreen extends StatefulWidget {
  const DepositScreen({super.key});

  @override
  State<DepositScreen> createState() => _DepositScreenState();
}

class _DepositScreenState extends State<DepositScreen> {
  final TextEditingController _controller = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final balanceProvider = Provider.of<BalanceProvider>(context, listen: false);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Deposit'),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Deposit Funds', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
            const SizedBox(height: 20),
            TextField(
              controller: _controller,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                hintText: 'e.g. 100.00',
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
              ),
            ),
            const SizedBox(height: 20),
            Center(
              child: ElevatedButton.icon(
                icon: const Icon(Icons.check_circle_outline),
                label: const Text('Confirm Deposit'),
                onPressed: () {
                  final amount = double.tryParse(_controller.text) ?? 0;
                  if (amount > 0) {
                    balanceProvider.deposit(amount);
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('Deposited \$${amount.toStringAsFixed(2)}')),
                    );
                    Navigator.pop(context);
                  }
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
