import 'package:crypto_wallet_app/providers/balance_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../providers/coin_provider.dart';
import '../screens/coin_detail_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  String? _username;

  @override
  void initState() {
    super.initState();
    _loadUser();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final provider = Provider.of<CoinProvider>(context, listen: false);
      provider.loadCoins();
    });
  }

  Future<void> _loadUser() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _username = prefs.getString('username') ?? 'Welcome!';
    });
    
  }

  Future<void> _logout(BuildContext context) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('logged_in', false);
    if (context.mounted) {
      Navigator.pushReplacementNamed(context, '/login');
    }
  }

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<CoinProvider>(context);

    return Scaffold(
      appBar: AppBar(
        title: Image(
          image: AssetImage("assets/logo.png"),
          width: 100,
        ),
        centerTitle: false,
      ),
      drawer: Drawer(
        child: ListView(
          children: [
            const DrawerHeader(
              decoration: BoxDecoration(color: Colors.grey),
              child: Center(
                child: Image(
          image: AssetImage("assets/logo.png"),
          width: 100,
        ),
              ),
            ),
            ListTile(
              leading: const Icon(Icons.logout),
              title: const Text("Logout"),
              onTap: () => _logout(context),
            ),
          ],
        ),
      ),
      body: RefreshIndicator(
        onRefresh: provider.refresh,
        child: SingleChildScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
              // Profile card
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.grey.shade200,
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Row(
                  children: [
                    const CircleAvatar(
                      radius: 30,
                      backgroundImage: AssetImage('assets/avatar.png'),
                      backgroundColor: Colors.grey,
                    ),
                    const SizedBox(width: 12),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          _username ?? 'Loading...',
                          style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                        ),
                        Consumer<BalanceProvider>(
  builder: (context, balanceProvider, _) => Text(
    "Balance: \$${balanceProvider.balance.toStringAsFixed(2)}",
    style: const TextStyle(color: Colors.grey),
  ),
),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),

              // Top currencies card
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.grey.shade200,
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          "Top Currencies",
                          style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                        ),
                        TextButton(
                          onPressed: () => Navigator.pushNamed(context, '/coinlist'),
                          child: const Text("See All"),
                        ),
                      ],
                    ),
                    const SizedBox(height: 10),

                    if (provider.state == DataState.loading)
                      const Center(child: CircularProgressIndicator())
                    else if (provider.coins.isEmpty)
                      const Text("No data available")
                    else
                      Column(
                        children: provider.coins
                            .take(3)
                            .map(
                              (coin) => Card(
                                margin: const EdgeInsets.symmetric(vertical: 8),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                child: ListTile(
                                  leading: Image.network(coin.image, width: 32, height: 32),
                                  title: Text(coin.name),
                                  subtitle: Text(coin.symbol.toUpperCase()),
                                  trailing: Text(
                                    "\$${coin.currentPrice.toStringAsFixed(2)}",
                                    style: const TextStyle(fontWeight: FontWeight.bold),
                                  ),
                                  onTap: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (_) => CoinDetailScreen(coin: coin),
                                      ),
                                    );
                                  },
                                ),
                              ),
                            )
                            .toList(),
                      ),
                  ],
                ),
              ),

              const SizedBox(height: 20),

              // Deposit & Withdraw buttons
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  ElevatedButton.icon(
                    onPressed: () => Navigator.pushNamed(context, '/deposit'),
                    icon: const Icon(Icons.arrow_downward),
                    label: const Text("Deposit"),
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                      backgroundColor: Colors.indigo,
                      foregroundColor: Colors.white,
                    ),
                  ),
                  ElevatedButton.icon(
                    onPressed: () => Navigator.pushNamed(context, '/withdraw'),
                    icon: const Icon(Icons.arrow_upward),
                    label: const Text("Withdraw"),
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                      backgroundColor: Colors.grey.shade800,
                      foregroundColor: Colors.white,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
