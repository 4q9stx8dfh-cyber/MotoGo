import 'package:flutter/material.dart';

import 'nominatim_service.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  static const Color green = Color(0xFF00C853);
  static const Color dark = Color(0xFF121212);
  static const Color card = Color(0xFF1E1E1E);

  final TextEditingController _searchController = TextEditingController();
  final NominatimService _nominatimService = NominatimService();

  List<PlaceResult> _results = [];
  bool _isLoading = false;

  Future<void> _search(String query) async {
    if (query.trim().length < 3) {
      setState(() => _results = []);
      return;
    }

    setState(() => _isLoading = true);

    try {
      final results = await _nominatimService.searchPlaces(query);

      if (!mounted) return;

      setState(() {
        _results = results;
        _isLoading = false;
      });
    } catch (_) {
      if (!mounted) return;

      setState(() => _isLoading = false);
    }
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: dark,
      appBar: AppBar(
        backgroundColor: dark,
        elevation: 0,
        title: const Text(
          'Buscar destino',
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(18),
        child: Column(
          children: [
            TextField(
              controller: _searchController,
              autofocus: true,
              style: const TextStyle(color: Colors.white),
              onChanged: _search,
              decoration: InputDecoration(
                hintText: 'Escribe una dirección...',
                hintStyle: const TextStyle(color: Colors.white54),
                prefixIcon: const Icon(Icons.search, color: green),
                filled: true,
                fillColor: card,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(22),
                  borderSide: BorderSide.none,
                ),
              ),
            ),
            const SizedBox(height: 18),
            if (_isLoading)
              const CircularProgressIndicator(color: green)
            else
              Expanded(
                child: ListView.separated(
                  itemCount: _results.length,
                  separatorBuilder: (_, __) =>
                  const Divider(color: Colors.white12),
                  itemBuilder: (context, index) {
                    final place = _results[index];

                    return ListTile(
                      leading: const Icon(
                        Icons.location_on_outlined,
                        color: green,
                      ),
                      title: Text(
                        place.name,
                        style: const TextStyle(color: Colors.white),
                      ),
                      subtitle: Text(
                        place.address,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(color: Colors.white54),
                      ),
                      onTap: () {
                        Navigator.pop(context, place);
                      },
                    );
                  },
                ),
              ),
          ],
        ),
      ),
    );
  }
}