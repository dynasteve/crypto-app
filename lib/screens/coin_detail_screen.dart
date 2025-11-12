import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import '../models/coin.dart';
import '../services/api_service.dart';

class CoinDetailScreen extends StatefulWidget {
  final Coin coin;

  const CoinDetailScreen({super.key, required this.coin});

  @override
  State<CoinDetailScreen> createState() => _CoinDetailScreenState();
}

class _CoinDetailScreenState extends State<CoinDetailScreen> {
  late ApiService apiService;
  List<ChartData> chartData = [];
  bool isLoading = true;
  String errorMessage = '';

  @override
  void initState() {
    super.initState();
    apiService = ApiService();
    _loadChartData();
  }

  Future<void> _loadChartData() async {
    try {
      final prices = await apiService.fetchCoinMarketChart(widget.coin.id);
      setState(() {
        chartData = List.generate(
          prices.length,
          (i) => ChartData(i.toDouble(), prices[i][1].toDouble()),
        );
        isLoading = false;
      });
    } catch (e) {
      setState(() {
        errorMessage = e.toString();
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("${widget.coin.name} Price History"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: isLoading
            ? const Center(child: CircularProgressIndicator())
            : errorMessage.isNotEmpty
                ? Center(child: Text(errorMessage))
                : Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Image.network(
                            widget.coin.image,
                            width: 50,
                            height: 50,
                          ),
                          const SizedBox(width: 12),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(widget.coin.name,
                                  style: Theme.of(context).textTheme.headlineSmall),
                              Text(widget.coin.symbol.toUpperCase(),
                                  style: Theme.of(context)
                                      .textTheme
                                      .labelLarge!
                                      .copyWith(color: Colors.grey)),
                            ],
                          ),
                        ],
                      ),
                      const SizedBox(height: 20),
                      Text(
                        "\$${widget.coin.currentPrice.toStringAsFixed(2)}",
                        style: const TextStyle(
                          fontSize: 30,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        "Market Cap: \$${widget.coin.marketCap}",
                        style: const TextStyle(color: Colors.grey),
                      ),
                      const SizedBox(height: 30),
                      const Text(
                        "7 Day Price Trend",
                        style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 10),
                      Expanded(
                        child: SfCartesianChart(
                          primaryXAxis: NumericAxis(isVisible: false),
                          primaryYAxis: NumericAxis(isVisible: false),
                          series: <LineSeries<ChartData, double>>[
                            LineSeries<ChartData, double>(
                              dataSource: chartData,
                              xValueMapper: (ChartData data, _) => data.x,
                              yValueMapper: (ChartData data, _) => data.y,
                              color: Colors.greenAccent,
                              width: 2,
                              markerSettings: const MarkerSettings(isVisible: false),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
      ),
    );
  }
}

// Helper class for Syncfusion chart
class ChartData {
  final double x;
  final double y;
  ChartData(this.x, this.y);
}
