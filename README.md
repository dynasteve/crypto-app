# Crypto Wallet App (HNG Stage 4)

A simple Crypto Wallet App built with Flutter that fetches live cryptocurrency data from the CoinGecko API, displays coin prices, and provides a 7-day price trend chart. It supports offline caching, search, and handles loading/error states gracefully.

## Features
- Fetches live crypto data (top 50 coins by market cap).
- Displays coin details including:
- Name & symbol
- Current price
- Market cap
- 7-day price trend chart
- Offline support with cached data.
- Search functionality to filter coins by name or symbol.
- Pull-to-refresh to reload data.
- Graceful loading and error states.

## Appetize Demo


## Demo Video Link

## Getting Started
### Prerequisites
- Flutter SDK >= 3.9.2
- Android Studio / VS Code
- A physical device or emulator

### Installation
#### Clone the repository
```bash
git clone YOUR_REPO_URL
cd crypto_wallet_app
```

### Install dependencies
```bash
flutter pub get
```

### Add your API key (optional if using CoinGecko public demo key)
- Create a .env file in the root of the project:
```bash
API_KEY=YOUR_API_KEY_HERE
```

Note: Do not commit .env to GitHub.

### Run the app
```bash
flutter run
```

or build APK:
```bash
flutter build apk --release
```

### Folder Structure
lib/
├─ main.dart
├─ models/        # Data models (Coin)
├─ services/      # API service (ApiService)
├─ providers/     # State management (CoinProvider)
├─ screens/       # UI screens (CoinsListScreen, CoinDetailScreen)
└─ widgets/       # Reusable widgets (CoinTile)

### Dependencies
- provider
 - State management
- http
 - API requests
- flutter_dotenv
 - Environment variables
- shared_preferences
 - Offline caching
- connectivity_plus
 - Network status
- fl_chart
 - Line chart for coin trends

### Usage
Launch the app → Coin list loads automatically.
Pull-to-refresh to update prices.
Use the search bar to filter coins.
Tap a coin → See details and 7-day price chart.
Offline → Cached data is displayed with a red banner.

### Notes
CoinGecko API is public; you can optionally use an API key for higher request limits.
App handles slow or unavailable networks gracefully.