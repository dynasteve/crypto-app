import 'package:flutter/material.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import '../models/coin.dart';
import '../services/api_service.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

enum DataState { initial, loading, loaded, error, offline }

class CoinProvider extends ChangeNotifier {
  final ApiService apiService;
  List<Coin> coins = [];
  String errorMessage = '';
  DataState state = DataState.initial;

  CoinProvider({required this.apiService});

  Future<void> loadCoins() async {
    state = DataState.loading;
    errorMessage = '';
    notifyListeners();

    // simple connectivity check
    final connectivityResult = await Connectivity().checkConnectivity();
    if (connectivityResult == ConnectivityResult.none) {
      // No connection — try to load cached data
      state = DataState.offline;
      await _loadFromCache();
      notifyListeners();
      return;
    }

    try {
      final fetched = await apiService.fetchCoins(perPage: 50);
      coins = fetched;
      state = DataState.loaded;
      // Save to cache for offline use
      await _saveToCache(fetched);
    } catch (e) {
      state = DataState.error;
      errorMessage = e.toString();
    }
    notifyListeners();
  }

  Future<void> _saveToCache(List<Coin> list) async {
    final prefs = await SharedPreferences.getInstance();
    final jsonList = list.map((c) => {
      'id': c.id,
      'symbol': c.symbol,
      'name': c.name,
      'image': c.image,
      'current_price': c.currentPrice,
      'price_change_percentage_24h': c.priceChange24h,
      'market_cap': c.marketCap,
    }).toList();
    prefs.setString('cached_coins', json.encode(jsonList));
  }

  Future<void> _loadFromCache() async {
    final prefs = await SharedPreferences.getInstance();
    final cached = prefs.getString('cached_coins');
    if (cached != null) {
      final List decoded = json.decode(cached);
      coins = decoded.map((item) => Coin.fromJson(item as Map<String, dynamic>)).toList();
    } else {
      // no cache
      coins = [];
      errorMessage = 'No internet connection and no cached data available.';
    }
  }

  // Call this to refresh the list (pull-to-refresh)
  Future<void> refresh() async {
    await loadCoins();
  }
}
