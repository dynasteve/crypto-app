import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

// Import screens
import 'screens/login_screen.dart';
import 'screens/signup_screen.dart';
import 'screens/home_screen.dart';
import 'screens/coins_list_screen.dart';
import 'screens/deposit_screen.dart';
import 'screens/withdraw_screen.dart';
// import 'screens/coin_detail_screen.dart';

// Import services and providers
import 'services/api_service.dart';
import 'providers/balance_provider.dart';
import 'providers/coin_provider.dart';

void main() {
  runApp(const AioCryptoApp());
}

class AioCryptoApp extends StatelessWidget {
  const AioCryptoApp({super.key});

  Future<bool> _isLoggedIn() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool('logged_in') ?? false;
  }

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (_) => CoinProvider(apiService: ApiService()),
        ),
        ChangeNotifierProvider(
          create: (_) => BalanceProvider(),
    ),
      ],
      child: MaterialApp(
        title: 'AIO Crypto',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.indigo),
          useMaterial3: true,
          scaffoldBackgroundColor: Colors.grey.shade50,
        ),

        // Load screen based on login state
        home: FutureBuilder<bool>(
          future: _isLoggedIn(),
          builder: (context, snapshot) {
            if (!snapshot.hasData) {
              return const Scaffold(
                body: Center(child: CircularProgressIndicator()),
              );
            }
            return snapshot.data! ? const HomeScreen() : const LoginScreen();
          },
        ),

        // Named routes
        routes: {
          '/login': (context) => const LoginScreen(),
          '/signup': (context) => const SignupScreen(),
          '/home': (context) => const HomeScreen(),
          '/coinlist': (context) => const CoinsListScreen(),
          '/deposit': (context) => const DepositScreen(),
          '/withdraw': (context) => const WithdrawScreen(),
        },

        // Optional: catch-all route fallback
        onUnknownRoute: (_) => MaterialPageRoute(
          builder: (_) => const HomeScreen(),
        ),
      ),
    );
  }
}
