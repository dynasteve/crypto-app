// lib/models/coin.dart

class Coin {
  final String id;       // coin id used by CoinGecko, e.g. "bitcoin"
  final String symbol;   // shortened symbol, e.g. "btc"
  final String name;     // "Bitcoin"
  final String image;    // image url
  final double currentPrice; // current price in USD
  final double priceChange24h; // 24h change (in percent)
  final double marketCap; // market cap

  Coin({
    required this.id,
    required this.symbol,
    required this.name,
    required this.image,
    required this.currentPrice,
    required this.priceChange24h,
    required this.marketCap,
  });

  // Factory constructor to create a Coin from JSON map
  factory Coin.fromJson(Map<String, dynamic> json) {
    return Coin(
      id: json['id'] as String,
      symbol: (json['symbol'] as String).toUpperCase(),
      name: json['name'] as String,
      image: json['image'] as String,
      currentPrice: (json['current_price'] as num).toDouble(),
      priceChange24h: json['price_change_percentage_24h'] == null
          ? 0.0
          : (json['price_change_percentage_24h'] as num).toDouble(),
      marketCap: json['market_cap'] == null ? 0.0 : (json['market_cap'] as num).toDouble(),
    );
  }
}
