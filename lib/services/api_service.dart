import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/coin.dart';

class ApiService {
  // Use Dart environment variable instead of .env
  final String apiKey = const String.fromEnvironment('API_KEY', defaultValue: '');

  // Base URL (CoinGecko example)
  final String baseUrl = 'https://api.coingecko.com/api/v3';

  // Fetch coins
  Future<List<Coin>> fetchCoins({int perPage = 50, int page = 1}) async {
    final uri1 = Uri.parse(
      '$baseUrl/coins/markets?vs_currency=usd&order=market_cap_desc&per_page=$perPage&page=$page&sparkline=false&price_change_percentage=24h'
    );

    final response = await http.get(uri1, headers: {
      'x_cg_demo_api_key': apiKey,
    });

    if (response.statusCode == 200) {
      final List decoded = json.decode(response.body) as List;
      return decoded.map((item) => Coin.fromJson(item as Map<String, dynamic>)).toList();
    } else {
      throw Exception('Failed to fetch coins: ${response.statusCode}');
    }
  }

  // Fetch market chart for a coin
  Future<List<List<num>>> fetchCoinMarketChart(String coinId, {int days = 7}) async {
    final uri = Uri.parse('$baseUrl/coins/$coinId/market_chart?vs_currency=usd&days=$days');
    final response = await http.get(uri);

    if (response.statusCode == 200) {
      final Map<String, dynamic> decoded = json.decode(response.body);
      final List prices = decoded['prices'] as List;
      return prices.map((p) => (p as List).map((e) => e as num).toList()).toList();
    } else {
      throw Exception('Failed to fetch market chart: ${response.statusCode}');
    }
  }
}
