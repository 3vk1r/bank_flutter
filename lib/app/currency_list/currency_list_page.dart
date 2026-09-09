
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import '/app/extensions/localization_extension.dart';
import '/domain/model/currency_model.dart';
import '/domain/model/data_source_type.dart';
import '/domain/repository/currency_repository.dart';
import '/domain/repository/settings_repository.dart';

class CurrencyListPage extends StatefulWidget {
  const CurrencyListPage({super.key});

  @override
  State<CurrencyListPage> createState() => _CurrencyListPageState();
}

class _CurrencyListPageState extends State<CurrencyListPage> {
  List<CurrencyModel> _currencies = <CurrencyModel>[];

  bool _isLoading = true;
  String? _error;

  String _searchQuery = '';

  List<CurrencyModel> get _filteredCurrencies {
    final String query = _searchQuery.trim().toLowerCase();

    if (query.isEmpty) {
      return _currencies;
    }

    return _currencies.where((currency) {
      return currency.name.toLowerCase().contains(query) ||
          currency.symbol.toLowerCase().contains(query) ||
          currency.id.toLowerCase().contains(query);
    }).toList();
  }

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      _loadCurrencies();
    });
  }

  Future<void> _loadCurrencies() async {
    final CurrencyRepository repository =
        context.read<CurrencyRepository>();

    final SettingsRepository settings =
        context.read<SettingsRepository>();

    if (mounted) {
      setState(() {
        _isLoading = true;
        _error = null;
      });
    }

    try {
      final DataSourceType source = settings.dataSource;

      // Локальный источник
      if (source == DataSourceType.local) {
        final List<CurrencyModel> cached =
            await repository.getCachedCurrencyList();

        if (!mounted) return;

        setState(() {
          _currencies = cached;
          _isLoading = false;
          _error = cached.isEmpty
              ? context.loc.noSavedData
              : null;
        });

        return;
      }

      // Интернет.
      // Сначала показываем локальный кэш.
      final List<CurrencyModel> cached =
          await repository.getCachedCurrencyList();

      if (cached.isNotEmpty && mounted) {
        setState(() {
          _currencies = cached;
          _isLoading = true;
        });
      }

      try {
        // Затем запрашиваем актуальные данные.
        final List<CurrencyModel> remote =
            await repository.getRemoteCurrencyList();

        if (!mounted) return;

        if (remote.isNotEmpty) {
          setState(() {
            _currencies = remote;
            _error = null;
          });
        } else if (cached.isEmpty) {
          setState(() {
            _error = context.loc.currencyDataError;
          });
        }
      } catch (_) {
        if (!mounted) return;

        // Если сеть недоступна, оставляем ранее загруженный кэш.
        if (cached.isEmpty) {
          setState(() {
            _error = context.loc.currencyLoadError;
          });
        }
      }
    } catch (_) {
      if (!mounted) return;

      setState(() {
        _error = context.loc.dataLoadError;
      });
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  Future<void> _refresh() async {
    await _loadCurrencies();
  }

  void _clearSearch() {
    setState(() {
      _searchQuery = '';
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(context.loc.currency),
        actions: [
          IconButton(
            onPressed: _refresh,
            tooltip: context.loc.refresh,
            icon: const Icon(Icons.refresh),
          ),
        ],
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(12, 8, 12, 8),
            child: TextField(
              onChanged: (value) {
                setState(() {
                  _searchQuery = value;
                });
              },
              decoration: InputDecoration(
                hintText: context.loc.searchCurrency,
                prefixIcon: const Icon(Icons.search),
                suffixIcon: _searchQuery.isNotEmpty
                    ? IconButton(
                        onPressed: _clearSearch,
                        tooltip: context.loc.clear,
                        icon: const Icon(Icons.clear),
                      )
                    : null,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                filled: true,
              ),
            ),
          ),
          Expanded(
            child: RefreshIndicator(
              onRefresh: _refresh,
              child: _buildBody(),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBody() {
    if (_isLoading && _currencies.isEmpty) {
      return ListView(
        physics: const AlwaysScrollableScrollPhysics(),
        children: const [
          SizedBox(
            height: 400,
            child: Center(
              child: CircularProgressIndicator(),
            ),
          ),
        ],
      );
    }

    if (_error != null && _currencies.isEmpty) {
      return ListView(
        physics: const AlwaysScrollableScrollPhysics(),
        padding: const EdgeInsets.all(24),
        children: [
          const SizedBox(height: 100),
          Icon(
            Icons.currency_exchange,
            size: 64,
            color: Theme.of(context).colorScheme.primary,
          ),
          const SizedBox(height: 16),
          Text(
            _error!,
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.bodyLarge,
          ),
          const SizedBox(height: 24),
          FilledButton.icon(
            onPressed: _refresh,
            icon: const Icon(Icons.refresh),
            label: Text(context.loc.retry),
          ),
        ],
      );
    }

    final List<CurrencyModel> filteredCurrencies =
        _filteredCurrencies;

    if (filteredCurrencies.isEmpty) {
      return ListView(
        physics: const AlwaysScrollableScrollPhysics(),
        children: [
          const SizedBox(height: 100),
          Icon(
            Icons.search_off,
            size: 56,
            color: Theme.of(context).colorScheme.primary,
          ),
          const SizedBox(height: 16),
          Text(
            _currencies.isEmpty
                ? context.loc.noSavedData
                : context.loc.currencyNotFound,
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.bodyLarge,
          ),
        ],
      );
    }

    return ListView.builder(
      physics: const AlwaysScrollableScrollPhysics(),
      padding: const EdgeInsets.fromLTRB(12, 4, 12, 12),
      itemCount: filteredCurrencies.length,
      itemBuilder: (context, index) {
        return _CurrencyCard(
          currency: filteredCurrencies[index],
        );
      },
    );
  }
}

class _CurrencyCard extends StatelessWidget {
  const _CurrencyCard({
    required this.currency,
  });

  final CurrencyModel currency;

  /// Русские названия основных валют.
  String _currencyName() {
    final String code = currency.id.toUpperCase();

    const Map<String, String> names = {
      'USD': 'Доллар США',
      'EUR': 'Евро',
      'GBP': 'Фунт стерлингов',
      'CNY': 'Китайский юань',
      'JPY': 'Японская иена',
      'CHF': 'Швейцарский франк',
      'CAD': 'Канадский доллар',
      'AUD': 'Австралийский доллар',
      'NZD': 'Новозеландский доллар',
      'SEK': 'Шведская крона',
      'NOK': 'Норвежская крона',
      'DKK': 'Датская крона',
      'PLN': 'Польский злотый',
      'CZK': 'Чешская крона',
      'HUF': 'Венгерский форинт',
      'TRY': 'Турецкая лира',
      'INR': 'Индийская рупия',
      'BRL': 'Бразильский реал',
      'ZAR': 'Южноафриканский рэнд',
      'KRW': 'Южнокорейская вона',
      'SGD': 'Сингапурский доллар',
      'HKD': 'Гонконгский доллар',
      'THB': 'Тайский бат',
      'AED': 'Дирхам ОАЭ',
      'KZT': 'Казахстанский тенге',
      'BYN': 'Белорусский рубль',
      'UAH': 'Украинская гривна',
    };

    return names[code] ?? currency.name;
  }

  @override
  Widget build(BuildContext context) {
    final NumberFormat formatter =
        NumberFormat('#,##0.00', 'ru_RU');

    final double difference =
        currency.value - currency.previousValue;

    final bool increased = difference > 0;
    final bool decreased = difference < 0;

    final Color changeColor;

    if (increased) {
      changeColor = Colors.green;
    } else if (decreased) {
      changeColor = Colors.red;
    } else {
      changeColor = Colors.grey;
    }

    return Card(
      margin: const EdgeInsets.only(bottom: 10),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            CircleAvatar(
              radius: 24,
              child: Text(
                currency.symbol,
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    _currencyName(),
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    context.loc.nominal(currency.nominal),
                    style: Theme.of(context).textTheme.bodySmall,
                  ),
                ],
              ),
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  '${formatter.format(currency.value)} ₽',
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 4),
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      increased
                          ? Icons.arrow_upward
                          : decreased
                              ? Icons.arrow_downward
                              : Icons.remove,
                      size: 14,
                      color: changeColor,
                    ),
                    const SizedBox(width: 2),
                    Text(
                      formatter.format(currency.previousValue),
                      style: TextStyle(
                        fontSize: 12,
                        color: changeColor,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

