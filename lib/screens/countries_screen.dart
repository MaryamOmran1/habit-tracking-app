import 'package:flutter/material.dart';
import '../services/api_service.dart';

class CountriesScreen extends StatefulWidget {
  const CountriesScreen({super.key});

  @override
  State<CountriesScreen> createState() => _CountriesScreenState();
}

class _CountriesScreenState extends State<CountriesScreen> {
  List<String> _countries = [];
  bool _isLoading = true;
  String? _errorMessage;
  String _searchQuery = '';

  @override
  void initState() {
    super.initState();
    _fetchCountries();
  }

  Future<void> _fetchCountries() async {
    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });
    try {
      final countries = await ApiService.fetchAllCountries();
      setState(() {
        _countries = countries;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _errorMessage = 'Failed to load countries. Please try again.';
        _isLoading = false;
      });
    }
  }

  List<String> get _filteredCountries {
    if (_searchQuery.isEmpty) return _countries;
    return _countries.where((country) =>
        country.toLowerCase().contains(_searchQuery.toLowerCase())).toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Countries List'),
        backgroundColor: Colors.blue,
        foregroundColor: Colors.white,
        actions: [
          IconButton(icon: const Icon(Icons.refresh), onPressed: _fetchCountries),
        ],
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16),
            child: TextField(
              decoration: InputDecoration(
                hintText: 'Search country...',
                prefixIcon: const Icon(Icons.search),
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                suffixIcon: _searchQuery.isNotEmpty
                    ? IconButton(icon: const Icon(Icons.clear), onPressed: () => setState(() => _searchQuery = ''))
                    : null,
              ),
              onChanged: (value) => setState(() => _searchQuery = value),
            ),
          ),
          Expanded(
            child: _isLoading
                ? const Center(child: CircularProgressIndicator())
                : _errorMessage != null
                    ? Center(child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.error_outline, size: 64, color: Colors.red),
                          Text(_errorMessage!),
                          ElevatedButton(onPressed: _fetchCountries, child: const Text('Retry')),
                        ],
                      ))
                    : _filteredCountries.isEmpty
                        ? const Center(child: Text('No countries found'))
                        : ListView.builder(
                            itemCount: _filteredCountries.length,
                            itemBuilder: (context, index) => Card(
                              margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
                              child: ListTile(
                                leading: CircleAvatar(
                                  backgroundColor: Colors.blue.shade100,
                                  child: Text(_filteredCountries[index][0].toUpperCase()),
                                ),
                                title: Text(_filteredCountries[index]),
                                trailing: const Icon(Icons.chevron_right),
                              ),
                            ),
                          ),
          ),
        ],
      ),
    );
  }
}