import 'package:flutter/material.dart';
import '../models/product.dart';
import '../data/products_data.dart';
import 'page_detail.dart';

class PageSearch extends StatefulWidget {
  final String initialQuery;

  const PageSearch({super.key, required this.initialQuery});

  @override
  State<PageSearch> createState() => _PageSearchState();
}

class _PageSearchState extends State<PageSearch> {
  final TextEditingController _controller = TextEditingController();
  List<Product> _results = [];

  @override
  void initState() {
    super.initState();
    _controller.text = widget.initialQuery;
    _updateResults(widget.initialQuery);
  }

  void _updateResults(String query) {
    final q = query.toLowerCase().trim();
    if (q.isEmpty) {
      setState(() {
        _results = [];
      });
      return;
    }

    // jai  combiner tous les produits :t-shirts + chaussures + pantalons
    final allProducts = <Product>[
      ...tshirtProducts,
      ...shoesProducts,
      ...pantalonProducts,
    ];

    setState(() {
      _results = allProducts
          .where((p) => p.name.toLowerCase().contains(q))
          .toList();
    });
  }

  String _getCategory(Product p) {
    if (tshirtProducts.contains(p)) return 'T-shirt';
    if (shoesProducts.contains(p)) return 'Chaussure';
    if (pantalonProducts.contains(p)) return 'Pantalon';
    return '';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: TextField(
          controller: _controller,
          decoration: const InputDecoration(
            hintText: 'Rechercher un produit...',
            border: InputBorder.none,
          ),
          autofocus: true,
          onChanged: _updateResults,
          onSubmitted: _updateResults,
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.clear),
            onPressed: () {
              _controller.clear();
              _updateResults('');
            },
          ),
        ],
      ),
      body: _results.isEmpty
          ? const Center(
              child: Text(
                'Aucun résultat',
                style: TextStyle(fontSize: 16),
              ),
            )
          : ListView.builder(
              itemCount: _results.length,
              itemBuilder: (context, index) {
                final p = _results[index];
                final cat = _getCategory(p);

                return ListTile(
                  leading: Image.asset(
                    p.imagePath,
                    width: 50,
                    height: 50,
                    fit: BoxFit.cover,
                  ),
                  title: Text(p.name),
                  subtitle: Text(
                    '$cat • ${p.price.toStringAsFixed(2)} \$',
                  ),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => PageDetail(product: p),
                      ),
                    );
                  },
                );
              },
            ),
    );
  }
}
