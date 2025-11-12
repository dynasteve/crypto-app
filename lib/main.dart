import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:provider/provider.dart';
import 'providers/coin_provider.dart';
import 'services/api_service.dart';
import 'screens/coins_list_screen.dart';

Future<void> main() async {
  // Ensure Flutter binding initialized before async calls
  WidgetsFlutterBinding.ensureInitialized();

  // Load environment variables
  await dotenv.load(fileName: ".env");

  runApp(const CryptoApp());
}

class CryptoApp extends StatelessWidget {
  const CryptoApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (_) => CoinProvider(apiService: ApiService()),
        ),
      ],
      child: MaterialApp(
        title: 'Crypto Wallet Stage 4',
        theme: ThemeData(
          primarySwatch: Colors.indigo,
          brightness: Brightness.dark,
        ),
        home: const CoinsListScreen(),
      ),
    );
  }
}
