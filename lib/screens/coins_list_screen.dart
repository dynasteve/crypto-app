import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/coin_provider.dart';
import '../widgets/coin_tile.dart';
import 'package:crypto_wallet_app/models/coin.dart';

class CoinsListScreen extends StatefulWidget {
  const CoinsListScreen({super.key});

  @override
  State<CoinsListScreen> createState() => _CoinsListScreenState();
}

class _CoinsListScreenState extends State<CoinsListScreen> {
  late CoinProvider _provider;
  final TextEditingController _searchController = TextEditingController();
  List<Coin> filteredCoins = [];

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      _provider = Provider.of<CoinProvider>(context, listen: false);
      _provider.loadCoins();
    });

    // Listen to search text changes
    _searchController.addListener(() {
      final query = _searchController.text.toLowerCase();
      setState(() {
        filteredCoins = _provider.coins.where((coin) {
          return coin.name.toLowerCase().contains(query) ||
                 coin.symbol.toLowerCase().contains(query);
        }).toList();
      });
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Crypto Wallet'),
        centerTitle: true,
      ),
      body: Consumer<CoinProvider>(
        builder: (context, provider, _) {
          if (provider.state == DataState.loading || provider.state == DataState.initial) {
            return const Center(child: CircularProgressIndicator());
          }

          if (provider.state == DataState.error && provider.coins.isEmpty) {
            return Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text('Error: ${provider.errorMessage}'),
                  const SizedBox(height: 12),
                  ElevatedButton(
                    onPressed: provider.loadCoins,
                    child: const Text('Retry'),
                  ),
                ],
              ),
            );
          }

          if (provider.coins.isEmpty) {
            return Center(child: Text(provider.errorMessage.isEmpty ? 'No coins found' : provider.errorMessage));
          }

          // Use filtered list if search text is not empty
          final coinsToShow = _searchController.text.isEmpty ? provider.coins : filteredCoins;

          return Column(
            children: [
              // Offline banner
              if (provider.state == DataState.offline)
                Container(
                  width: double.infinity,
                  color: Colors.redAccent,
                  padding: const EdgeInsets.symmetric(vertical: 8),
                  child: const Center(
                    child: Text(
                      'You are offline — showing cached coins',
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                ),

              // Search bar
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: TextField(
                  controller: _searchController,
                  decoration: InputDecoration(
                    hintText: 'Search coins',
                    prefixIcon: const Icon(Icons.search),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                ),
              ),

              // Coin list
              Expanded(
                child: RefreshIndicator(
                  onRefresh: provider.refresh,
                  child: ListView.builder(
                    physics: const AlwaysScrollableScrollPhysics(),
                    itemCount: coinsToShow.length,
                    itemBuilder: (context, index) {
                      final coin = coinsToShow[index];
                      return CoinTile(coin: coin);
                    },
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}

