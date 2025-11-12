import 'package:flutter/material.dart';
import '../models/coin.dart';
import 'package:crypto_wallet_app/screens/coin_detail_screen.dart';

class CoinTile extends StatelessWidget {
  final Coin coin;
  const CoinTile({super.key, required this.coin});

  @override
  Widget build(BuildContext context) {
    final price = coin.currentPrice.toStringAsFixed(2);
    final change = coin.priceChange24h;
    final changeText = change.isNaN ? '0.00' : change.toStringAsFixed(2);
    final changeColor = change >= 0 ? Colors.greenAccent : Colors.redAccent;

    return ListTile(
      leading: Image.network(coin.image, width: 40, height: 40, errorBuilder: (c, e, s) {
        return CircleAvatar(child: Text(coin.symbol[0]));
      }),
      title: Text('${coin.name} (${coin.symbol})'),
      subtitle: Text('\$ $price'),
      trailing: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          Text('\$${coin.marketCap.toStringAsFixed(0)}', style: const TextStyle(fontSize: 12)),
          const SizedBox(height: 4),
          Text(
            '$changeText %',
            style: TextStyle(color: changeColor, fontWeight: FontWeight.w600),
          ),
        ],
      ),
      onTap: () {
  Navigator.push(
    context,
    MaterialPageRoute(
      builder: (_) => CoinDetailScreen(coin: coin),
    ),
  );
},
    );
  }
}
